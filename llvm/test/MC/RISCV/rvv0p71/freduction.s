# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xv %s \
# RUN:         --mattr=+f --riscv-no-aliases \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:         --mattr=+f \
# RUN:        | llvm-objdump -d --mattr=+xv --mattr=+f \
# RUN:        -M no-aliases - | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:         --mattr=+f \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vfredosum.vs v8, v4, v20, v0.t
# CHECK-INST: vfredosum.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0x0c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 0c <unknown>

vfredosum.vs v8, v4, v20
# CHECK-INST: vfredosum.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0x0e]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 0e <unknown>

vfredsum.vs v8, v4, v20, v0.t
# CHECK-INST: vfredsum.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0x04]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 04 <unknown>

vfredsum.vs v8, v4, v20
# CHECK-INST: vfredsum.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0x06]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 06 <unknown>

vfredmax.vs v8, v4, v20, v0.t
# CHECK-INST: vfredmax.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0x1c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 1c <unknown>

vfredmax.vs v8, v4, v20
# CHECK-INST: vfredmax.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0x1e]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 1e <unknown>

vfredmin.vs v8, v4, v20, v0.t
# CHECK-INST: vfredmin.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0x14]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 14 <unknown>

vfredmin.vs v8, v4, v20
# CHECK-INST: vfredmin.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0x16]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a 16 <unknown>

vfwredosum.vs v8, v4, v20, v0.t
# CHECK-INST: vfwredosum.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0xcc]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a cc <unknown>

vfwredosum.vs v8, v4, v20
# CHECK-INST: vfwredosum.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0xce]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a ce <unknown>

vfwredsum.vs v8, v4, v20, v0.t
# CHECK-INST: vfwredsum.vs v8, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x14,0x4a,0xc4]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a c4 <unknown>

vfwredsum.vs v8, v4, v20
# CHECK-INST: vfwredsum.vs v8, v4, v20
# CHECK-ENCODING: [0x57,0x14,0x4a,0xc6]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 14 4a c6 <unknown>

vfredosum.vs v0, v4, v20, v0.t
# CHECK-INST: vfredosum.vs v0, v4, v20, v0.t
# CHECK-ENCODING: [0x57,0x10,0x4a,0x0c]
# CHECK-ERROR: instruction requires the following: 'V'{{.*}}'Zve32f', 'Zve64f' or 'Zve64d' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 10 4a 0c <unknown>
