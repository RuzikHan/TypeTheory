%default total

divBy : (a : Nat) -> (b : Nat) -> Type
divBy a b = (k : Nat ** b * k = a)

mul2 : {a, b, c, k1, k2 : Nat} -> (b * k1 = a) -> (c * k2 = b) -> (c * (k2 * k1) = a)
mul2 {c} {k1} {k2} pf1 pf2 =  rewrite (multAssociative c k2 k1) in (rewrite (sym pf1) in rewrite (sym pf2) in Refl)

mydiv : {a : Nat} -> {b : Nat} -> {c : Nat} -> divBy a b -> divBy b c -> divBy a c
mydiv {c} (k1 ** pf1) (k2 ** pf2) = (k2 * k1 ** rewrite (sym (mul2 pf1 pf2)) in Refl)
