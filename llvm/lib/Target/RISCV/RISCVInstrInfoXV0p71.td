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

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasRVV0p71],
    AsmVariantName = "RVV0p71", DecoderNamespace = "RVV0p71" in {
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
} // Predicates = [HasRVV0p71], AsmVariantName = "RVV0p71", DecoderNamespace = "RVV0p71"
