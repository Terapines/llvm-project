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

//===----------------------------------------------------------------------===//
// Operand and SDNode transformation definitions.
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

//===----------------------------------------------------------------------===//
// Instruction class templates
//===----------------------------------------------------------------------===//

class RVV0p71VLoadStore<bits<3> nf, bits<3> mop, bits<3> width,
                        dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;
  bit vm;

  let Inst{31-29} = nf;
  let Inst{28-26} = mop;
  let Inst{25} = vm;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = width;
  let Inst{11-7} = rd;

  let Uses = [VTYPE, VL];
}

let hasSideEffects = 0, mayLoad = 1, mayStore = 0, RVVConstraint = VMConstraint,
    Opcode = OPC_LOAD_FP.Value in {
  class RVV0p71VLxU<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b000, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1})$vm"> {
    let rs2 = 0b00000;
  }
  class RVV0p71VLx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b100, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1})$vm"> {
    let rs2 = 0b00000;
  }
  class RVV0p71VLxUFF<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b000, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1})$vm"> {
    let rs2 = 0b10000;
  }
  class RVV0p71VLxFF<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b100, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1})$vm"> {
    let rs2 = 0b10000;
  }
  class RVV0p71VLSxU<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b010, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, GPR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
  class RVV0p71VLSx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b110, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, GPR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
  class RVV0p71VLXxU<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b011, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
  class RVV0p71VLXx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b111, width, (outs VR:$rd),
                          (ins GPRMem:$rs1, VR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1,
    Opcode = OPC_STORE_FP.Value in {
  class RVV0p71VSx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b000, width, (outs),
                          (ins VR:$rd, GPRMem:$rs1, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1})$vm"> {
    let rs2 = 0b00000;
  }
  class RVV0p71VSSx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b010, width, (outs),
                          (ins VR:$rd, GPRMem:$rs1, GPR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
  class RVV0p71VSXx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b011, width, (outs),
                          (ins VR:$rd, GPRMem:$rs1, VR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
  class RVV0p71VSUXx<bits<3> width, string opcodestr>
      : RVV0p71VLoadStore<0b000, 0b111, width, (outs),
                          (ins VR:$rd, GPRMem:$rs1, VR:$rs2, VMaskOp:$vm),
                          opcodestr, "$rd, (${rs1}), $rs2$vm">;
}

multiclass VWSMAC_V_X<string opcodestr, bits<6> funct6> {
  def V : VALUrVV<funct6, OPIVV, opcodestr # ".vv">,
          Sched<[WriteVIWMulAddV_UpperBound, ReadVIWMulAddV_UpperBound,
                 ReadVIWMulAddV_UpperBound, ReadVMask]>;
  def X : VALUrVX<funct6, OPIVX, opcodestr # ".vx">,
          Sched<[WriteVIWMulAddX_UpperBound, ReadVIWMulAddV_UpperBound,
                 ReadVIWMulAddX_UpperBound, ReadVMask]>;
}

multiclass VWSMAC_X<string opcodestr, bits<6> funct6> {
  def X : VALUrVX<funct6, OPIVX, opcodestr # ".vx">,
          Sched<[WriteVIWMulAddX_UpperBound, ReadVIWMulAddV_UpperBound,
                 ReadVIWMulAddX_UpperBound, ReadVMask]>;
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let AsmVariantName = "RVV0p71", DecoderNamespace = "RVV0p71" in {
let Predicates = [HasRVV0p71] in {
// Configuration-Setting Instructions
let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {
def XVSETVLI : RVInstSetVLi<(outs GPR:$rd), (ins GPR:$rs1, VTypeI0p71:$vtypei),
                            "vsetvli", "$rd, $rs1, $vtypei">,
                            Sched<[WriteVSETVLI, ReadVSETVLI]>;
def XVSETVL : RVInstSetVL<(outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                          "vsetvl", "$rd, $rs1, $rs2">,
                          Sched<[WriteVSETVL, ReadVSETVL, ReadVSETVL]>;
} // hasSideEffects = 1, mayLoad = 0, mayStore = 0

// Vector Unit-Stride Instructions
def XVLB_V : RVV0p71VLx<0b000, "vlb.v">;
def XVLH_V : RVV0p71VLx<0b101, "vlh.v">;
def XVLW_V : RVV0p71VLx<0b110, "vlw.v">;
def XVLBU_V : RVV0p71VLxU<0b000, "vlbu.v">;
def XVLHU_V : RVV0p71VLxU<0b101, "vlhu.v">;
def XVLWU_V : RVV0p71VLxU<0b110, "vlwu.v">;
def XVLE_V : RVV0p71VLxU<0b111, "vle.v">;
def XVSB_V : RVV0p71VSx<0b000, "vsb.v">;
def XVSH_V : RVV0p71VSx<0b101, "vsh.v">;
def XVSW_V : RVV0p71VSx<0b110, "vsw.v">;
def XVSE_V : RVV0p71VSx<0b111, "vse.v">;

// Vector Strided Instructions
def XVLSB_V : RVV0p71VLSx<0b000, "vlsb.v">;
def XVLSH_V : RVV0p71VLSx<0b101, "vlsh.v">;
def XVLSW_V : RVV0p71VLSx<0b110, "vlsw.v">;
def XVLSBU_V : RVV0p71VLSxU<0b000, "vlsbu.v">;
def XVLSHU_V : RVV0p71VLSxU<0b101, "vlshu.v">;
def XVLSWU_V : RVV0p71VLSxU<0b110, "vlswu.v">;
def XVLSE_V : RVV0p71VLSxU<0b111, "vlse.v">;
def XVSSB_V : RVV0p71VSSx<0b000, "vssb.v">;
def XVSSH_V : RVV0p71VSSx<0b101, "vssh.v">;
def XVSSW_V : RVV0p71VSSx<0b110, "vssw.v">;
def XVSSE_V : RVV0p71VSSx<0b111, "vsse.v">;

// Vector indexed loads and stores
def XVLXB_V : RVV0p71VLXx<0b000, "vlxb.v">;
def XVLXH_V : RVV0p71VLXx<0b101, "vlxh.v">;
def XVLXW_V : RVV0p71VLXx<0b110, "vlxw.v">;
def XVLXBU_V : RVV0p71VLXxU<0b000, "vlxbu.v">;
def XVLXHU_V : RVV0p71VLXxU<0b101, "vlxhu.v">;
def XVLXWU_V : RVV0p71VLXxU<0b110, "vlxwu.v">;
def XVLXE_V : RVV0p71VLXxU<0b111, "vlxe.v">;
def XVSXB_V : RVV0p71VSXx<0b000, "vsxb.v">;
def XVSXH_V : RVV0p71VSXx<0b101, "vsxh.v">;
def XVSXW_V : RVV0p71VSXx<0b110, "vsxw.v">;
def XVSXE_V : RVV0p71VSXx<0b111, "vsxe.v">;
def XVSUXB_V : RVV0p71VSUXx<0b000, "vsuxb.v">;
def XVSUXH_V : RVV0p71VSUXx<0b101, "vsuxh.v">;
def XVSUXW_V : RVV0p71VSUXx<0b110, "vsuxw.v">;
def XVSUXE_V : RVV0p71VSUXx<0b111, "vsuxe.v">;

// Unit-stride Fault-Only-First Loads
def XVLBFF_V : RVV0p71VLxFF<0b000, "vlbff.v">;
def XVLHFF_V : RVV0p71VLxFF<0b101, "vlhff.v">;
def XVLWFF_V : RVV0p71VLxFF<0b110, "vlwff.v">;
def XVLBUFF_V : RVV0p71VLxUFF<0b000, "vlbuff.v">;
def XVLHUFF_V : RVV0p71VLxUFF<0b101, "vlhuff.v">;
def XVLWUFF_V : RVV0p71VLxUFF<0b110, "vlwuff.v">;
def XVLEFF_V : RVV0p71VLxUFF<0b111, "vleff.v">;

// Vector Single-Width Integer Add and Subtract
defm XVADD_V : VALU_IV_V_X_I<"vadd", 0b000000>;
defm XVSUB_V : VALU_IV_V_X<"vsub", 0b000010>;
defm XVRSUB_V : VALU_IV_X_I<"vrsub", 0b000011>;

// Vector Widening Integer Add/Subtract
// Refer to 11.2 Widening Vector Arithmetic Instructions
// The destination vector register group cannot overlap a source vector
// register group of a different element width (including the mask register
// if masked), otherwise an illegal instruction exception is raised.
let Constraints = "@earlyclobber $vd" in {
let RVVConstraint = WidenV in {
defm XVWADDU_V : VALU_MV_V_X<"vwaddu", 0b110000>;
defm XVWSUBU_V : VALU_MV_V_X<"vwsubu", 0b110010>;
defm XVWADD_V : VALU_MV_V_X<"vwadd", 0b110001>;
defm XVWSUB_V : VALU_MV_V_X<"vwsub", 0b110011>;
} // RVVConstraint = WidenV
// Set earlyclobber for following instructions for second and mask operands.
// This has the downside that the earlyclobber constraint is too coarse and
// will impose unnecessary restrictions by not allowing the destination to
// overlap with the first (wide) operand.
let RVVConstraint = WidenW in {
defm XVWADDU_W : VALU_MV_V_X<"vwaddu", 0b110100, "w">;
defm XVWSUBU_W : VALU_MV_V_X<"vwsubu", 0b110110, "w">;
defm XVWADD_W : VALU_MV_V_X<"vwadd", 0b110101, "w">;
defm XVWSUB_W : VALU_MV_V_X<"vwsub", 0b110111, "w">;
} // RVVConstraint = WidenW
} // Constraints = "@earlyclobber $vd"

// Vector Integer Add-with-Carry / Subtract-with-Borrow Instructions
defm XVADC_V : VALUm_IV_V_X_I<"vadc", 0b010000>;
let Constraints = "@earlyclobber $vd", RVVConstraint = NoConstraint in {
defm XVMADC_V : VALUm_IV_V_X_I<"vmadc", 0b010001>;
defm XVMADC_V : VALUNoVm_IV_V_X_I<"vmadc", 0b010001>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = NoConstraint
defm XVSBC_V : VALUm_IV_V_X<"vsbc", 0b010010>;
let Constraints = "@earlyclobber $vd", RVVConstraint = NoConstraint in {
defm XVMSBC_V : VALUm_IV_V_X<"vmsbc", 0b010011>;
defm XVMSBC_V : VALUNoVm_IV_V_X<"vmsbc", 0b010011>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = NoConstraint

// Vector Bitwise Logical Instructions
defm XVAND_V : VALU_IV_V_X_I<"vand", 0b001001>;
defm XVOR_V : VALU_IV_V_X_I<"vor", 0b001010>;
defm XVXOR_V : VALU_IV_V_X_I<"vxor", 0b001011>;

// Vector Single-Width Bit Shift Instructions
defm XVSLL_V : VSHT_IV_V_X_I<"vsll", 0b100101, uimm5>;
defm XVSRL_V : VSHT_IV_V_X_I<"vsrl", 0b101000, uimm5>;
defm XVSRA_V : VSHT_IV_V_X_I<"vsra", 0b101001, uimm5>;

// Vector Narrowing Integer Right Shift Instructions
// Refer to 11.3. Narrowing Vector Arithmetic Instructions
// The destination vector register group cannot overlap the first source
// vector register group (specified by vs2). The destination vector register
// group cannot overlap the mask register if used, unless LMUL=1.
let Constraints = "@earlyclobber $vd" in {
defm XVNSRL_W : VNSHT_IV_V_X_I<"vnsrl", 0b101100, uimm5, "w">;
defm XVNSRA_W : VNSHT_IV_V_X_I<"vnsra", 0b101101, uimm5, "w">;
} // Constraints = "@earlyclobber $vd"

// Vector Integer Comparison Instructions
let RVVConstraint = NoConstraint in {
defm XVMSEQ_V : VCMP_IV_V_X_I<"vmseq", 0b011000>;
defm XVMSNE_V : VCMP_IV_V_X_I<"vmsne", 0b011001>;
defm XVMSLTU_V : VCMP_IV_V_X<"vmsltu", 0b011010>;
defm XVMSLT_V : VCMP_IV_V_X<"vmslt", 0b011011>;
defm XVMSLEU_V : VCMP_IV_V_X_I<"vmsleu", 0b011100>;
defm XVMSLE_V : VCMP_IV_V_X_I<"vmsle", 0b011101>;
defm XVMSGTU_V : VCMP_IV_X_I<"vmsgtu", 0b011110>;
defm XVMSGT_V : VCMP_IV_X_I<"vmsgt", 0b011111>;
} // RVVConstraint = NoConstraint

// Vector Integer Min/Max Instructions
defm XVMINU_V : VCMP_IV_V_X<"vminu", 0b000100>;
defm XVMIN_V : VCMP_IV_V_X<"vmin", 0b000101>;
defm XVMAXU_V : VCMP_IV_V_X<"vmaxu", 0b000110>;
defm XVMAX_V : VCMP_IV_V_X<"vmax", 0b000111>;

// Vector Single-Width Integer Multiply Instructions
defm XVMUL_V : VMUL_MV_V_X<"vmul", 0b100101>;
defm XVMULH_V : VMUL_MV_V_X<"vmulh", 0b100111>;
defm XVMULHU_V : VMUL_MV_V_X<"vmulhu", 0b100100>;
defm XVMULHSU_V : VMUL_MV_V_X<"vmulhsu", 0b100110>;

// Vector Integer Divide Instructions
defm XVDIVU_V : VDIV_MV_V_X<"vdivu", 0b100000>;
defm XVDIV_V : VDIV_MV_V_X<"vdiv", 0b100001>;
defm XVREMU_V : VDIV_MV_V_X<"vremu", 0b100010>;
defm XVREM_V : VDIV_MV_V_X<"vrem", 0b100011>;

// Vector Widening Integer Multiply Instructions
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV in {
defm XVWMUL_V : VWMUL_MV_V_X<"vwmul", 0b111011>;
defm XVWMULU_V : VWMUL_MV_V_X<"vwmulu", 0b111000>;
defm XVWMULSU_V : VWMUL_MV_V_X<"vwmulsu", 0b111010>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV

// Vector Single-Width Integer Multiply-Add Instructions
defm XVMACC_V : VMAC_MV_V_X<"vmacc", 0b101101>;
defm XVNMSAC_V : VMAC_MV_V_X<"vnmsac", 0b101111>;
defm XVMADD_V : VMAC_MV_V_X<"vmadd", 0b101001>;
defm XVNMSUB_V : VMAC_MV_V_X<"vnmsub", 0b101011>;

// Vector Widening Integer Multiply-Add Instructions
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV in {
defm XVWMACCU_V : VWMAC_MV_V_X<"vwmaccu", 0b111100>;
defm XVWMACC_V : VWMAC_MV_V_X<"vwmacc", 0b111101>;
defm XVWMACCSU_V : VWMAC_MV_V_X<"vwmaccsu", 0b111111>;
defm XVWMACCUS_V : VWMAC_MV_X<"vwmaccus", 0b111110>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV

// Vector Integer Merge Instructions
defm XVMERGE_V : VMRG_IV_V_X_I<"vmerge", 0b010111>;

// Vector Integer Move Instructions
let hasSideEffects = 0, mayLoad = 0, mayStore = 0, vs2 = 0, vm = 1,
    RVVConstraint = NoConstraint  in {
// op vd, vs1
def XVMV_V_V : RVInstVV<0b010111, OPIVV, (outs VR:$vd),
                       (ins VR:$vs1), "vmv.v.v", "$vd, $vs1">,
              Sched<[WriteVIMovV_UpperBound, ReadVIMovV_UpperBound]>;
// op vd, rs1
def XVMV_V_X : RVInstVX<0b010111, OPIVX, (outs VR:$vd),
                       (ins GPR:$rs1), "vmv.v.x", "$vd, $rs1">,
              Sched<[WriteVIMovX_UpperBound, ReadVIMovX_UpperBound]>;
// op vd, imm
def XVMV_V_I : RVInstIVI<0b010111, (outs VR:$vd),
                       (ins simm5:$imm), "vmv.v.i", "$vd, $imm">,
              Sched<[WriteVIMovI_UpperBound]>;
              
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0

// Vector Fixed-Point Arithmetic Instructions
defm XVSADDU_V : VSALU_IV_V_X_I<"vsaddu", 0b100000>;
defm XVSADD_V : VSALU_IV_V_X_I<"vsadd", 0b100001>;
defm XVSSUBU_V : VSALU_IV_V_X<"vssubu", 0b100010>;
defm XVSSUB_V : VSALU_IV_V_X<"vssub", 0b100011>;

// Vector Single-Width Averaging Add and Subtract
defm XVAADDU_V : VAALU_MV_V_X<"vaaddu", 0b001000>;
defm XVAADD_V : VAALU_MV_V_X<"vaadd", 0b001001>;
defm XVASUBU_V : VAALU_MV_V_X<"vasubu", 0b001010>;
defm XVASUB_V : VAALU_MV_V_X<"vasub", 0b001011>;

// Vector Single-Width Fractional Multiply with Rounding and Saturation
defm XVSMUL_V : VSMUL_IV_V_X<"vsmul", 0b100111>;

// Vector Widening Saturating Scaled Multiply-Add
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV in {
defm XVWSMACCU_V : VWSMAC_V_X<"vwsmaccu", 0b111100>;
defm XVWSMACC_V : VWSMAC_V_X<"vwsmacc", 0b111101>;
defm XVWSMACCSU_V : VWSMAC_V_X<"vwsmaccsu", 0b111111>;
defm XVWSMACCUS_V : VWSMAC_X<"vwsmaccus", 0b111110>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV

// Vector Single-Width Scaling Shift Instructions
defm XVSSRL_V : VSSHF_IV_V_X_I<"vssrl", 0b101010, uimm5>;
defm XVSSRA_V : VSSHF_IV_V_X_I<"vssra", 0b101011, uimm5>;

// Vector Narrowing Fixed-Point Clip Instructions
let Constraints = "@earlyclobber $vd" in {
defm XVNCLIPU_W : VNCLP_IV_V_X_I<"vnclipu", 0b101110, uimm5, "w">;
defm XVNCLIP_W : VNCLP_IV_V_X_I<"vnclip", 0b101111, uimm5, "w">;
} // Constraints = "@earlyclobber $vd"
} // Predicates = [HasRVV0p71]

let Predicates = [HasRVV0p71, HasStdExtF] in {
// Vector Single-Width Floating-Point Add/Subtract Instructions
let Uses = [FRM], mayRaiseFPException = true in {
defm XVFADD_V : VALU_FV_V_F<"vfadd", 0b000000>;
defm XVFSUB_V : VALU_FV_V_F<"vfsub", 0b000010>;
defm XVFRSUB_V : VALU_FV_F<"vfrsub", 0b100111>;
}

// Vector Widening Floating-Point Add/Subtract Instructions
let Constraints = "@earlyclobber $vd",
    Uses = [FRM],
    mayRaiseFPException = true in {
let RVVConstraint = WidenV in {
defm XVFWADD_V : VWALU_FV_V_F<"vfwadd", 0b110000>;
defm XVFWSUB_V : VWALU_FV_V_F<"vfwsub", 0b110010>;
} // RVVConstraint = WidenV
// Set earlyclobber for following instructions for second and mask operands.
// This has the downside that the earlyclobber constraint is too coarse and
// will impose unnecessary restrictions by not allowing the destination to
// overlap with the first (wide) operand.
let RVVConstraint = WidenW in {
defm XVFWADD_W : VWALU_FV_V_F<"vfwadd", 0b110100, "w">;
defm XVFWSUB_W : VWALU_FV_V_F<"vfwsub", 0b110110, "w">;
} // RVVConstraint = WidenW
} // Constraints = "@earlyclobber $vd", Uses = [FRM], mayRaiseFPException = true

// Vector Single-Width Floating-Point Multiply/Divide Instructions
let Uses = [FRM], mayRaiseFPException = true in {
defm XVFMUL_V : VMUL_FV_V_F<"vfmul", 0b100100>;
defm XVFDIV_V : VDIV_FV_V_F<"vfdiv", 0b100000>;
defm XVFRDIV_V : VRDIV_FV_F<"vfrdiv", 0b100001>;
}

// Vector Widening Floating-Point Multiply
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV,
    Uses = [FRM], mayRaiseFPException = true in {
defm XVFWMUL_V : VWMUL_FV_V_F<"vfwmul", 0b111000>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV, Uses = [FRM], mayRaiseFPException = true

// Vector Single-Width Floating-Point Fused Multiply-Add Instructions
let Uses = [FRM], mayRaiseFPException = true in {
defm XVFMACC_V : VMAC_FV_V_F<"vfmacc", 0b101100>;
defm XVFNMACC_V : VMAC_FV_V_F<"vfnmacc", 0b101101>;
defm XVFMSAC_V : VMAC_FV_V_F<"vfmsac", 0b101110>;
defm XVFNMSAC_V : VMAC_FV_V_F<"vfnmsac", 0b101111>;
defm XVFMADD_V : VMAC_FV_V_F<"vfmadd", 0b101000>;
defm XVFNMADD_V : VMAC_FV_V_F<"vfnmadd", 0b101001>;
defm XVFMSUB_V : VMAC_FV_V_F<"vfmsub", 0b101010>;
defm XVFNMSUB_V : VMAC_FV_V_F<"vfnmsub", 0b101011>;
}

// Vector Widening Floating-Point Fused Multiply-Add Instructions
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenV,
    Uses = [FRM], mayRaiseFPException = true in {
defm XVFWMACC_V : VWMAC_FV_V_F<"vfwmacc", 0b111100>;
defm XVFWNMACC_V : VWMAC_FV_V_F<"vfwnmacc", 0b111101>;
defm XVFWMSAC_V : VWMAC_FV_V_F<"vfwmsac", 0b111110>;
defm XVFWNMSAC_V : VWMAC_FV_V_F<"vfwnmsac", 0b111111>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenV, Uses = [FRM], mayRaiseFPException = true

// Vector Floating-Point Square-Root Instruction
let Uses = [FRM], mayRaiseFPException = true in {
defm XVFSQRT_V : VSQR_FV_VS2<"vfsqrt.v", 0b010011, 0b00000>;
}

// Vector Floating-Point MIN/MAX Instructions
let mayRaiseFPException = true in {
defm XVFMIN_V : VCMP_FV_V_F<"vfmin", 0b000100>;
defm XVFMAX_V : VCMP_FV_V_F<"vfmax", 0b000110>;
}

// Vector Floating-Point Sign-Injection Instructions
defm XVFSGNJ_V : VSGNJ_FV_V_F<"vfsgnj", 0b001000>;
defm XVFSGNJN_V : VSGNJ_FV_V_F<"vfsgnjn", 0b001001>;
defm XVFSGNJX_V : VSGNJ_FV_V_F<"vfsgnjx", 0b001010>;

// Vector Floating-Point Compare Instructions
let RVVConstraint = NoConstraint, mayRaiseFPException = true in {
defm XVMFEQ_V : VCMP_FV_V_F<"vmfeq", 0b011000>;
defm XVMFNE_V : VCMP_FV_V_F<"vmfne", 0b011100>;
defm XVMFLT_V : VCMP_FV_V_F<"vmflt", 0b011011>;
defm XVMFLE_V : VCMP_FV_V_F<"vmfle", 0b011001>;
defm XVMFGT_V : VCMP_FV_F<"vmfgt", 0b011101>;
defm XVMFGE_V : VCMP_FV_F<"vmfge", 0b011111>;
defm XVMFORD_V : VCMP_FV_V_F<"vmford", 0b011010>;
} // RVVConstraint = NoConstraint, mayRaiseFPException = true

// Vector Floating-Point Classify Instruction
defm XVFCLASS_V : VCLS_FV_VS2<"vfclass.v", 0b010011, 0b10000>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {

// Vector Floating-Point Merge Instruction
let vm = 0 in
def XVFMERGE_VFM : RVInstVX<0b010111, OPFVF, (outs VR:$vd),
                           (ins VR:$vs2, FPR32:$rs1, VMV0:$v0),
                           "vfmerge.vfm", "$vd, $vs2, $rs1, v0">,
                  Sched<[WriteVFMergeV_UpperBound, ReadVFMergeV_UpperBound,
                         ReadVFMergeF_UpperBound, ReadVMask]>;

// Vector Floating-Point Move Instruction
let RVVConstraint = NoConstraint in
let vm = 1, vs2 = 0 in
def XVFMV_V_F : RVInstVX<0b010111, OPFVF, (outs VR:$vd),
                       (ins FPR32:$rs1), "vfmv.v.f", "$vd, $rs1">,
               Sched<[WriteVFMovV_UpperBound, ReadVFMovF_UpperBound]>;

} // hasSideEffects = 0, mayLoad = 0, mayStore = 0

// Single-Width Floating-Point/Integer Type-Convert Instructions
let mayRaiseFPException = true in {
let Uses = [FRM] in {
defm XVFCVT_XU_F_V : VCVTI_FV_VS2<"vfcvt.xu.f.v", 0b010010, 0b00000>;
defm XVFCVT_X_F_V : VCVTI_FV_VS2<"vfcvt.x.f.v", 0b010010, 0b00001>;
defm XVFCVT_F_XU_V : VCVTF_IV_VS2<"vfcvt.f.xu.v", 0b010010, 0b00010>;
defm XVFCVT_F_X_V : VCVTF_IV_VS2<"vfcvt.f.x.v", 0b010010, 0b00011>;
}
} // mayRaiseFPException = true

// Widening Floating-Point/Integer Type-Convert Instructions
let Constraints = "@earlyclobber $vd", RVVConstraint = WidenCvt,
    mayRaiseFPException = true in {
let Uses = [FRM] in {
defm XVFWCVT_XU_F_V : VWCVTI_FV_VS2<"vfwcvt.xu.f.v", 0b010010, 0b01000>;
defm XVFWCVT_X_F_V : VWCVTI_FV_VS2<"vfwcvt.x.f.v", 0b010010, 0b01001>;
}
defm XVFWCVT_F_XU_V : VWCVTF_IV_VS2<"vfwcvt.f.xu.v", 0b010010, 0b01010>;
defm XVFWCVT_F_X_V : VWCVTF_IV_VS2<"vfwcvt.f.x.v", 0b010010, 0b01011>;
defm XVFWCVT_F_F_V : VWCVTF_FV_VS2<"vfwcvt.f.f.v", 0b010010, 0b01100>;
} // Constraints = "@earlyclobber $vd", RVVConstraint = WidenCvt

// Narrowing Floating-Point/Integer Type-Convert Instructions
let Constraints = "@earlyclobber $vd", mayRaiseFPException = true in {
let Uses = [FRM] in {
defm XVFNCVT_XU_F_W : VNCVTI_FV_VS2<"vfncvt.xu.f.v", 0b010010, 0b10000>;
defm XVFNCVT_X_F_W : VNCVTI_FV_VS2<"vfncvt.x.f.v", 0b010010, 0b10001>;
defm XVFNCVT_F_XU_W : VNCVTF_IV_VS2<"vfncvt.f.xu.v", 0b010010, 0b10010>;
defm XVFNCVT_F_X_W : VNCVTF_IV_VS2<"vfncvt.f.x.v", 0b010010, 0b10011>;
defm XVFNCVT_F_F_W : VNCVTF_FV_VS2<"vfncvt.f.f.v", 0b010010, 0b10100>;
}
} // Constraints = "@earlyclobber $vd", mayRaiseFPException = true
} // Predicates = [HasRVV0p71, HasStdExtF]
} // AsmVariantName = "RVV0p71", DecoderNamespace = "RVV0p71"
