# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xv %s \
# RUN:   --riscv-no-aliases | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:   | llvm-objdump -d --mattr=+xv -M no-aliases - \
# RUN:   | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:   | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vmerge.vvm v8, v4, v20, v0
# CHECK-INST: vmerge.vvm v8, v4, v20, v0
# CHECK-ENCODING: [0x57,0x04,0x4a,0x5c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 04 4a 5c <unknown>

vmerge.vxm v8, v4, a0, v0
# CHECK-INST: vmerge.vxm v8, v4, a0, v0
# CHECK-ENCODING: [0x57,0x44,0x45,0x5c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 44 45 5c <unknown>

vmerge.vim v8, v4, 15, v0
# CHECK-INST: vmerge.vim v8, v4, 15, v0
# CHECK-ENCODING: [0x57,0xb4,0x47,0x5c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 b4 47 5c <unknown>
