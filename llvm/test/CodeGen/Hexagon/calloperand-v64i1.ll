; RUN: llc -mtriple=hexagon  < %s -o - | FileCheck %s --check-prefix=CHECK
; RUN: llc -mtriple=hexagon -mattr=+hvxv79,+hvx-length64b < %s -o - | FileCheck %s --check-prefix=CHECK-64
; RUN: llc -mtriple=hexagon -mattr=+hvxv79,+hvx-length128b < %s -o - | FileCheck %s --check-prefix=CHECK-128

; CHECK-LABEL: compare_vectors
; CHECK: [[REG8:(r[0-9]+):[0-9]]] = CONST64(#72340172838076673)
; CHECK: r{{[0-9]+}}:{{[0-9]+}} = and(r{{[0-9]+}}:{{[0-9]+}},[[REG8]])
; CHECK: r{{[0-9]+}}:{{[0-9]+}} = and(r{{[0-9]+}}:{{[0-9]+}},[[REG8]])
; CHECK: r{{[0-9]+}}:{{[0-9]+}} = and(r{{[0-9]+}}:{{[0-9]+}},[[REG8]])
; CHECK-64: [[REG1:(q[0-9]+)]] = vcmp.eq(v{{[0-9]+}}.b,v{{[0-9]+}}.b)
; CHECK-64: [[REG2:(r[0-9]+)]] = #-1
; CHECK-64: v0 = vand([[REG1]],[[REG2]])
; CHECK-128: r{{[0-9]+}}:{{[0-9]+}} = combine(##.LCPI0_0,#-1)
; CHECK-128: [[REG1:(q[0-9]+)]] = vcmp.eq(v0.b,v1.b)
; CHECK-128: [[REG2:(v[0-9]+)]] = vand([[REG1]],r{{[0-9]+}})
; CHECK-128: [[REG3:(v[0-9]+)]] = vmem(r{{[0-9]+}}+#0)
; CHECK-128: [[REG4:(v[0-9]+)]] = vdelta([[REG2]],[[REG3]])
; CHECK-128: [[REG5:(q[0-9]+)]] = vand([[REG4]],r{{[0-9]+}})
; CHECK-128: v0 = vand([[REG5]],r{{[0-9]+}})

define void @compare_vectors(<64 x i8> %a, <64 x i8> %b) {
entry:
  %result = icmp eq <64 x i8> %a, %b
  call i32 @f.1(<64 x i1> %result)
  ret void
}

; CHECK-LABEL: f.1:
; CHECK: [[REG9:(r[0-9]+)]] = and([[REG9]],##16843009)
; CHECK: [[REG10:(r[0-9]+)]] = and([[REG10]],##16843009)
; CHECK-64: [[REG3:(q[0-9]+)]] = vand(v0,r{{[0-9]+}})
; CHECK-64: [[REG4:(v[0-9]+)]] = vand([[REG3]],r{{[0-9]+}})
; CHECK-64: r{{[0-9]+}} = vextract([[REG4]],r{{[0-9]+}})
; CHECK-128: [[REG6:(q[0-9]+)]] = vand(v0,r{{[0-9]+}})
; CHECK-128: [[REG7:(v[0-9]+)]] = vand([[REG6]],r{{[0-9]+}})
; CHECK-128: r{{[0-9]+}} = vextract([[REG7]],r{{[0-9]+}})

define i32 @f.1(<64 x i1> %vec) {
  %element = extractelement <64 x i1> %vec, i32 6
  %is_true = icmp eq i1 %element, true
  br i1 %is_true, label %if_true, label %if_false

if_true:
  call void @action_if_true()
  br label %end

if_false:
  call void @action_if_false()
  br label %end

end:
  %result = phi i32 [1, %if_true], [0, %if_false]
  ret i32 %result
}

declare void @action_if_true()
declare void @action_if_false()
