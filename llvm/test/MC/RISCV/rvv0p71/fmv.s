# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xv %s \
# RUN:         --mattr=+f \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:         --mattr=+f \
# RUN:        | llvm-objdump -d --mattr=+xv --mattr=+f - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:         --mattr=+f \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vfmv.v.f v8, fa0
# CHECK-INST: vfmv.v.f v8, fa0
# CHECK-ENCODING: [0x57,0x54,0x05,0x5e]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 54 05 5e <unknown>

vfmv.f.s fa0, v4
# CHECK-INST: vfmv.f.s fa0, v4
# CHECK-ENCODING: [0x57,0x15,0x40,0x32]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 15 40 32 <unknown>

vfmv.s.f v8, fa0
# CHECK-INST: vfmv.s.f v8, fa0
# CHECK-ENCODING: [0x57,0x54,0x05,0x36]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 54 05 36 <unknown>
