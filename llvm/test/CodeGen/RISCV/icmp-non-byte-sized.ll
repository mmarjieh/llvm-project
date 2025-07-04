; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=riscv32 -mattr=+v -O2 < %s | FileCheck %s --check-prefix=CHECK-RV32
; RUN: llc -mtriple=riscv64 -mattr=+v -O2 < %s | FileCheck %s --check-prefix=CHECK-RV64

define i1 @icmp_non_byte_type(ptr %p1, ptr %p2) nounwind {
; CHECK-RV32-LABEL: icmp_non_byte_type:
; CHECK-RV32:       # %bb.0:
; CHECK-RV32-NEXT:    lw a2, 0(a0)
; CHECK-RV32-NEXT:    lw a3, 4(a0)
; CHECK-RV32-NEXT:    lw a4, 8(a0)
; CHECK-RV32-NEXT:    lw a0, 12(a0)
; CHECK-RV32-NEXT:    lw a5, 12(a1)
; CHECK-RV32-NEXT:    lw a6, 4(a1)
; CHECK-RV32-NEXT:    lw a7, 8(a1)
; CHECK-RV32-NEXT:    lw a1, 0(a1)
; CHECK-RV32-NEXT:    xor a0, a0, a5
; CHECK-RV32-NEXT:    xor a3, a3, a6
; CHECK-RV32-NEXT:    xor a4, a4, a7
; CHECK-RV32-NEXT:    xor a1, a2, a1
; CHECK-RV32-NEXT:    or a0, a3, a0
; CHECK-RV32-NEXT:    or a1, a1, a4
; CHECK-RV32-NEXT:    or a0, a1, a0
; CHECK-RV32-NEXT:    seqz a0, a0
; CHECK-RV32-NEXT:    ret
;
; CHECK-RV64-LABEL: icmp_non_byte_type:
; CHECK-RV64:       # %bb.0:
; CHECK-RV64-NEXT:    ld a2, 0(a0)
; CHECK-RV64-NEXT:    ld a0, 8(a0)
; CHECK-RV64-NEXT:    ld a3, 8(a1)
; CHECK-RV64-NEXT:    ld a1, 0(a1)
; CHECK-RV64-NEXT:    xor a0, a0, a3
; CHECK-RV64-NEXT:    xor a1, a2, a1
; CHECK-RV64-NEXT:    or a0, a1, a0
; CHECK-RV64-NEXT:    seqz a0, a0
; CHECK-RV64-NEXT:    ret
  %v1 = load i127, ptr %p1
  %v2 = load i127, ptr %p2
  %ret = icmp eq i127 %v1, %v2
  ret i1 %ret
}
