//===-- RISCVInstrInfoV0p71.td --- RVV for 0.71 version ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V 'V' Vector extension for version 0.7.1
///
//===----------------------------------------------------------------------===//

def VTypeI0p71AsmOperand : AsmOperandClass {
  let Name = "VTypeI0p71";
  let ParserMethod = "parseVTypeI0p71";
  let DiagnosticType = "InvalidVTypeI0p71";
  let RenderMethod = "addVTypeIOperands";
}

def VTypeI0p71 : Operand<XLenVT> {
  let ParserMatchClass = VTypeI0p71AsmOperand;
  let PrintMethod = "printVTypeI0p71";
  let DecoderMethod = "decodeUImmOperand<11>";
  let OperandType = "OPERAND_VTYPEI0p71";
  let OperandNamespace = "RISCVOp";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isUInt<11>(Imm);
    return MCOp.isBareSymbolRef();
  }];
}

let Predicates = [HasRVV0p71],
    AsmVariantName = "RVV0p71", DecoderNamespace = "RVV0p71",
    hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {
def XVSETVLI : RVInstSetVLi<(outs GPR:$rd), (ins GPR:$rs1, VTypeI0p71:$vtypei),
                            "vsetvli", "$rd, $rs1, $vtypei">,
                            Sched<[WriteVSETVLI, ReadVSETVLI]>;
def XVSETVL : RVInstSetVL<(outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                          "vsetvl", "$rd, $rs1, $rs2">,
                          Sched<[WriteVSETVL, ReadVSETVL, ReadVSETVL]>;
}
