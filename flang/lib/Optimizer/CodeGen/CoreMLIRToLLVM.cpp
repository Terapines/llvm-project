//===-- CoreMLIRToLLVM.cpp ------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "flang/Optimizer/CodeGen/CodeGen.h"
#include "flang/Optimizer/CodeGen/CodeGenOpenMP.h"
#include "flang/Optimizer/CodeGen/FIROpPatterns.h"
#include "flang/Optimizer/CodeGen/TypeConverter.h"
#include "flang/Optimizer/Dialect/Support/FIRContext.h"
#include "flang/Optimizer/Support/DataLayout.h"
#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
#include "mlir/Conversion/ComplexToLLVM/ComplexToLLVM.h"
#include "mlir/Conversion/ComplexToROCDLLibraryCalls/ComplexToROCDLLibraryCalls.h"
#include "mlir/Conversion/ComplexToStandard/ComplexToStandard.h"
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVM.h"
#include "mlir/Conversion/IndexToLLVM/IndexToLLVM.h"
#include "mlir/Conversion/MathToFuncs/MathToFuncs.h"
#include "mlir/Conversion/MathToLLVM/MathToLLVM.h"
#include "mlir/Conversion/MathToLibm/MathToLibm.h"
#include "mlir/Conversion/MathToROCDL/MathToROCDL.h"
#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
#include "mlir/Conversion/OpenMPToLLVM/ConvertOpenMPToLLVM.h"
#include "mlir/Conversion/UBToLLVM/UBToLLVM.h"
#include "mlir/Conversion/VectorToLLVM/ConvertVectorToLLVM.h"
#include "mlir/Dialect/DLTI/DLTI.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/Transforms/AddComdats.h"
#include "mlir/Dialect/OpenACC/OpenACC.h"
#include "mlir/Dialect/OpenMP/OpenMPDialect.h"
#include "mlir/Pass/PassManager.h"

namespace fir {
#define GEN_PASS_DEF_COREMLIRTOLLVM
#include "flang/Optimizer/CodeGen/CGPasses.h.inc"
} // namespace fir

namespace {
/// convert value between fir type and mlir type
struct UnrealizedConversionCastOpConversion
    : public fir::FIROpConversion<mlir::UnrealizedConversionCastOp> {
  using FIROpConversion::FIROpConversion;

  static bool isFloatingPointTy(mlir::Type ty) {
    return mlir::isa<mlir::FloatType>(ty);
  }

  llvm::LogicalResult
  matchAndRewrite(mlir::UnrealizedConversionCastOp op, OpAdaptor adaptor,
                  mlir::ConversionPatternRewriter &rewriter) const override {
    if (op->getNumOperands() != 1 || op->getNumResults() != 1)
      return mlir::failure();

    auto fromFirTy = op->getOperandTypes()[0];
    auto toFirTy = op->getResultTypes()[0];
    auto fromTy = convertType(fromFirTy);
    auto toTy = convertType(toFirTy);

    if (!fromTy || !toTy)
      return mlir::failure();

    mlir::Value op0 = adaptor.getOperands()[0];

    if (fromTy == toTy) {
      rewriter.replaceOp(op, op0);
      return mlir::success();
    }

    mlir::Location loc = op->getLoc();

    // Pointer to MemRef conversion.
    if (mlir::isa<mlir::LLVM::LLVMPointerType>(fromTy) &&
        mlir::isa<mlir::MemRefType>(toFirTy)) {
      auto dstMemRef = mlir::MemRefDescriptor::poison(rewriter, loc, toTy);
      dstMemRef.setAlignedPtr(rewriter, loc, op0);
      dstMemRef.setConstantOffset(rewriter, loc, 0);
      rewriter.replaceOp(op, {dstMemRef});
      return mlir::success();
    } else if (mlir::isa<mlir::MemRefType>(fromFirTy) &&
               mlir::isa<mlir::LLVM::LLVMPointerType>(toTy)) {
      // MemRef to pointer conversion.
      auto srcMemRef = mlir::MemRefDescriptor(op0);
      mlir::Value srcPtr =
          srcMemRef.bufferPtr(rewriter, loc, *getTypeConverter(),
                              mlir::cast<mlir::MemRefType>(fromFirTy));
      rewriter.replaceOp(op, srcPtr);
      return mlir::success();
    }

    return mlir::failure();
  }
};
} // namespace

namespace {
class CoreMLIRToLLVMPass
    : public fir::impl::CoreMLIRToLLVMBase<CoreMLIRToLLVMPass> {
public:
  using Base::Base;

  CoreMLIRToLLVMPass(fir::FIRToLLVMPassOptions options) : options(options) {}

  void runOnOperation() override final {
    auto mod = getOperation();

    // Run dynamic pass pipeline for converting Math dialect
    // operations into other dialects (llvm, func, etc.).
    // Some conversions of Math operations cannot be done
    // by just using conversion patterns. This is true for
    // conversions that affect the ModuleOp, e.g. create new
    // function operations in it. We have to run such conversions
    // as passes here.
    mlir::OpPassManager mathConversionPM("builtin.module");

    bool isAMDGCN = fir::getTargetTriple(mod).isAMDGCN();
    // If compiling for AMD target some math operations must be lowered to AMD
    // GPU library calls, the rest can be converted to LLVM intrinsics, which
    // is handled in the mathToLLVM conversion. The lowering to libm calls is
    // not needed since all math operations are handled this way.
    if (isAMDGCN) {
      mathConversionPM.addPass(mlir::createConvertMathToROCDL());
      mathConversionPM.addPass(mlir::createConvertComplexToROCDLLibraryCalls());
    }

    // Convert math::FPowI operations to inline implementation
    // only if the exponent's width is greater than 32, otherwise,
    // it will be lowered to LLVM intrinsic operation by a later conversion.
    mlir::ConvertMathToFuncsOptions mathToFuncsOptions{};
    mathToFuncsOptions.minWidthOfFPowIExponent = 33;
    mathConversionPM.addPass(
        mlir::createConvertMathToFuncs(mathToFuncsOptions));

    mlir::ConvertComplexToStandardPassOptions complexToStandardOptions{};
    if (options.ComplexRange ==
        Fortran::frontend::CodeGenOptions::ComplexRangeKind::CX_Basic) {
      complexToStandardOptions.complexRange =
          mlir::complex::ComplexRangeFlags::basic;
    } else if (options.ComplexRange == Fortran::frontend::CodeGenOptions::
                                           ComplexRangeKind::CX_Improved) {
      complexToStandardOptions.complexRange =
          mlir::complex::ComplexRangeFlags::improved;
    }
    mathConversionPM.addPass(
        mlir::createConvertComplexToStandardPass(complexToStandardOptions));

    // Convert Math dialect operations into LLVM dialect operations.
    // There is no way to prefer MathToLLVM patterns over MathToLibm
    // patterns (applied below), so we have to run MathToLLVM conversion here.
    mathConversionPM.addNestedPass<mlir::func::FuncOp>(
        mlir::createConvertMathToLLVMPass());
    if (mlir::failed(runPipeline(mathConversionPM, mod)))
      return signalPassFailure();

    std::optional<mlir::DataLayout> dl =
        fir::support::getOrSetMLIRDataLayout(mod, /*allowDefaultLayout=*/true);
    if (!dl) {
      mlir::emitError(mod.getLoc(),
                      "module operation must carry a data layout attribute "
                      "to generate llvm IR from FIR");
      signalPassFailure();
      return;
    }

    auto *context = mod.getContext();
    fir::LLVMTypeConverter typeConverter{mod, options.applyTBAA,
                                         options.forceUnifiedTBAATree, *dl};
    mlir::RewritePatternSet pattern(context);

    mlir::ub::populateUBToLLVMConversionPatterns(typeConverter, pattern);
    mlir::populateFinalizeMemRefToLLVMConversionPatterns(typeConverter,
                                                         pattern);
    pattern.add<UnrealizedConversionCastOpConversion>(typeConverter, options,
                                                      /*benefit=*/2);

    fir::populateFIRToLLVMConversionPatterns(typeConverter, pattern, options);
    mlir::populateFuncToLLVMConversionPatterns(typeConverter, pattern);
    mlir::populateOpenMPToLLVMConversionPatterns(typeConverter, pattern);
    mlir::arith::populateArithToLLVMConversionPatterns(typeConverter, pattern);
    mlir::cf::populateControlFlowToLLVMConversionPatterns(typeConverter,
                                                          pattern);
    mlir::cf::populateAssertToLLVMConversionPattern(typeConverter, pattern);
    // Math operations that have not been converted yet must be converted
    // to Libm.
    if (!isAMDGCN)
      mlir::populateMathToLibmConversionPatterns(pattern);
    mlir::populateComplexToLLVMConversionPatterns(typeConverter, pattern);
    mlir::index::populateIndexToLLVMConversionPatterns(typeConverter, pattern);
    mlir::populateVectorToLLVMConversionPatterns(typeConverter, pattern);

    // Flang specific overloads for OpenMP operations, to allow for special
    // handling of things like Box types.
    fir::populateOpenMPFIRToLLVMConversionPatterns(typeConverter, pattern);

    mlir::ConversionTarget target{*context};
    target.addLegalDialect<mlir::LLVM::LLVMDialect>();
    // The OpenMP dialect is legal for Operations without regions, for those
    // which contains regions it is legal if the region contains only the
    // LLVM dialect. Add OpenMP dialect as a legal dialect for conversion and
    // legalize conversion of OpenMP operations without regions.
    mlir::configureOpenMPToLLVMConversionLegality(target, typeConverter);
    target.addLegalDialect<mlir::omp::OpenMPDialect>();
    target.addLegalDialect<mlir::acc::OpenACCDialect>();
    target.addLegalDialect<mlir::gpu::GPUDialect>();

    // required NOPs for applying a full conversion
    target.addLegalOp<mlir::ModuleOp>();

    // apply the patterns
    if (mlir::failed(
            mlir::applyFullConversion(mod, target, std::move(pattern)))) {
      signalPassFailure();
    }

    // If we're on Windows, we might need to rename some libm calls.
    bool isMSVC = fir::getTargetTriple(mod).isOSMSVCRT();
    if (isMSVC) {
      mod->walk([&](mlir::Operation *op) {
        if (auto llvmFuncOp = mlir::dyn_cast<mlir::LLVM::LLVMFuncOp>(op)) {
          if (llvmFuncOp.getSymName() == "hypotf")
            llvmFuncOp.setSymName(
                mlir::StringAttr::get(op->getContext(), "_hypotf"));
        } else if (auto llvmCallOp = mlir::dyn_cast<mlir::LLVM::CallOp>(op)) {
          auto callee = llvmCallOp.getCallee();
          if (callee && *callee == "hypotf")
            llvmCallOp.setCalleeAttr(
                mlir::SymbolRefAttr::get(op->getContext(), "_hypotf"));
        }
      });
    }

    // Run pass to add comdats to functions that have weak linkage on relevant
    // platforms
    if (fir::getTargetTriple(mod).supportsCOMDAT()) {
      mlir::OpPassManager comdatPM("builtin.module");
      comdatPM.addPass(mlir::LLVM::createLLVMAddComdats());
      if (mlir::failed(runPipeline(comdatPM, mod)))
        return signalPassFailure();
    }
  }

private:
  fir::FIRToLLVMPassOptions options;
};
} // namespace

std::unique_ptr<mlir::Pass>
fir::createCoreMLIRToLLVMPass(FIRToLLVMPassOptions options) {
  return std::make_unique<CoreMLIRToLLVMPass>(options);
}
