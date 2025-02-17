# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xv %s \
# RUN:   --mattr=+f --riscv-no-aliases \
# RUN:   | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:   --mattr=+f | llvm-objdump -d --mattr=+xv --mattr=+f -M no-aliases - \
# RUN:   | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:   --mattr=+f | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vfsqrt.v v8, v4, v0.t
# CHECK-INST: vfsqrt.v v8, v4, v0.t
# CHECK-ENCODING: [0x57,0x14,0x40,0x8c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 40 8c <unknown>

vfsqrt.v v8, v4
# CHECK-INST: vfsqrt.v v8, v4
# CHECK-ENCODING: [0x57,0x14,0x40,0x8e]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 40 8e <unknown>

vfclass.v v8, v4, v0.t
# CHECK-INST: vfclass.v v8, v4, v0.t
# CHECK-ENCODING: [0x57,0x14,0x48,0x8c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 48 8c <unknown>

vfclass.v v8, v4
# CHECK-INST: vfclass.v v8, v4
# CHECK-ENCODING: [0x57,0x14,0x48,0x8e]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 48 8e <unknown>

vfmerge.vfm v8, v4, fa0, v0
# CHECK-INST: vfmerge.vfm v8, v4, fa0, v0
# CHECK-ENCODING: [0x57,0x54,0x45,0x5c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 54 45 5c <unknown>
