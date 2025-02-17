# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xv %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:        | llvm-objdump -d --mattr=+xv - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xv %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vmacc.vv v8, v20, v4, v0.t
# CHECK-INST: vmacc.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xb4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a b4 <unknown>

vmacc.vv v8, v20, v4
# CHECK-INST: vmacc.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xb6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a b6 <unknown>

vmacc.vx v8, a0, v4, v0.t
# CHECK-INST: vmacc.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xb4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 b4 <unknown>

vmacc.vx v8, a0, v4
# CHECK-INST: vmacc.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xb6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 b6 <unknown>

vnmsac.vv v8, v20, v4, v0.t
# CHECK-INST: vnmsac.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xbc]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a bc <unknown>

vnmsac.vv v8, v20, v4
# CHECK-INST: vnmsac.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xbe]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a be <unknown>

vnmsac.vx v8, a0, v4, v0.t
# CHECK-INST: vnmsac.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xbc]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 bc <unknown>

vnmsac.vx v8, a0, v4
# CHECK-INST: vnmsac.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xbe]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 be <unknown>

vmadd.vv v8, v20, v4, v0.t
# CHECK-INST: vmadd.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xa4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a a4 <unknown>

vmadd.vv v8, v20, v4
# CHECK-INST: vmadd.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xa6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a a6 <unknown>

vmadd.vx v8, a0, v4, v0.t
# CHECK-INST: vmadd.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xa4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 a4 <unknown>

vmadd.vx v8, a0, v4
# CHECK-INST: vmadd.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xa6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 a6 <unknown>

vnmsub.vv v8, v20, v4, v0.t
# CHECK-INST: vnmsub.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xac]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a ac <unknown>

vnmsub.vv v8, v20, v4
# CHECK-INST: vnmsub.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xae]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a ae <unknown>

vnmsub.vx v8, a0, v4, v0.t
# CHECK-INST: vnmsub.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xac]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 ac <unknown>

vnmsub.vx v8, a0, v4
# CHECK-INST: vnmsub.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xae]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 ae <unknown>

vwmaccu.vv v8, v20, v4, v0.t
# CHECK-INST: vwmaccu.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xf0]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a f0 <unknown>

vwmaccu.vv v8, v20, v4
# CHECK-INST: vwmaccu.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xf2]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a f2 <unknown>

vwmaccu.vx v8, a0, v4, v0.t
# CHECK-INST: vwmaccu.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xf0]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 f0 <unknown>

vwmaccu.vx v8, a0, v4
# CHECK-INST: vwmaccu.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xf2]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 f2 <unknown>

vwmacc.vv v8, v20, v4, v0.t
# CHECK-INST: vwmacc.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xf4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a f4 <unknown>

vwmacc.vv v8, v20, v4
# CHECK-INST: vwmacc.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xf6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a f6 <unknown>

vwmacc.vx v8, a0, v4, v0.t
# CHECK-INST: vwmacc.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xf4]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 f4 <unknown>

vwmacc.vx v8, a0, v4
# CHECK-INST: vwmacc.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xf6]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 f6 <unknown>

vwmaccsu.vv v8, v20, v4, v0.t
# CHECK-INST: vwmaccsu.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x24,0x4a,0xfc]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a fc <unknown>

vwmaccsu.vv v8, v20, v4
# CHECK-INST: vwmaccsu.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x24,0x4a,0xfe]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 24 4a fe <unknown>

vwmaccsu.vx v8, a0, v4, v0.t
# CHECK-INST: vwmaccsu.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xfc]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 fc <unknown>

vwmaccsu.vx v8, a0, v4
# CHECK-INST: vwmaccsu.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xfe]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 fe <unknown>

vwmaccus.vx v8, a0, v4, v0.t
# CHECK-INST: vwmaccus.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x64,0x45,0xf8]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 f8 <unknown>

vwmaccus.vx v8, a0, v4
# CHECK-INST: vwmaccus.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x64,0x45,0xfa]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors){{$}}
# CHECK-UNKNOWN: 57 64 45 fa <unknown>

vwsmaccu.vv v8, v20, v4, v0.t
# CHECK-INST: vwsmaccu.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x04,0x4a,0xf0]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a f0 <unknown>

vwsmaccu.vv v8, v20, v4
# CHECK-INST: vwsmaccu.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x04,0x4a,0xf2]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a f2 <unknown>

vwsmaccu.vx v8, a0, v4, v0.t
# CHECK-INST: vwsmaccu.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x44,0x45,0xf0]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 f0 <unknown>

vwsmaccu.vx v8, a0, v4
# CHECK-INST: vwsmaccu.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x44,0x45,0xf2]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 f2 <unknown>

vwsmacc.vv v8, v20, v4, v0.t
# CHECK-INST: vwsmacc.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x04,0x4a,0xf4]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a f4 <unknown>

vwsmacc.vv v8, v20, v4
# CHECK-INST: vwsmacc.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x04,0x4a,0xf6]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a f6 <unknown>

vwsmacc.vx v8, a0, v4, v0.t
# CHECK-INST: vwsmacc.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x44,0x45,0xf4]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 f4 <unknown>

vwsmacc.vx v8, a0, v4
# CHECK-INST: vwsmacc.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x44,0x45,0xf6]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 f6 <unknown>

vwsmaccsu.vv v8, v20, v4, v0.t
# CHECK-INST: vwsmaccsu.vv v8, v20, v4, v0.t
# CHECK-ENCODING: [0x57,0x04,0x4a,0xf8]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a f8 <unknown>

vwsmaccsu.vv v8, v20, v4
# CHECK-INST: vwsmaccsu.vv v8, v20, v4
# CHECK-ENCODING: [0x57,0x04,0x4a,0xfa]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 04 4a fa <unknown>

vwsmaccsu.vx v8, a0, v4, v0.t
# CHECK-INST: vwsmaccsu.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x44,0x45,0xf8]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 f8 <unknown>

vwsmaccsu.vx v8, a0, v4
# CHECK-INST: vwsmaccsu.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x44,0x45,0xfa]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 fa <unknown>

vwsmaccus.vx v8, a0, v4, v0.t
# CHECK-INST: vwsmaccus.vx v8, a0, v4, v0.t
# CHECK-ENCODING: [0x57,0x44,0x45,0xfc]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 fc <unknown>

vwsmaccus.vx v8, a0, v4
# CHECK-INST: vwsmaccus.vx v8, a0, v4
# CHECK-ENCODING: [0x57,0x44,0x45,0xfe]
# CHECK-ERROR: unrecognized instruction mnemonic
# CHECK-UNKNOWN: 57 44 45 fe <unknown>