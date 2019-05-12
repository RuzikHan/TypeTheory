%default total

square : Nat -> Nat
square a = mult a a

lte_plus_b_right : LTE a c -> (b : Nat) -> LTE (plus a b) (plus c b)
lte_plus_b_right x Z {a = a} {c = c} = rewrite (plusZeroRightNeutral a) in rewrite (plusZeroRightNeutral c) in x
lte_plus_b_right x (S k) {a = a} {c = c} = rewrite (sym (plusSuccRightSucc a k)) in rewrite (sym (plusSuccRightSucc c k)) in (lte_plus_b_right (LTESucc x) k)

lte_plus_b_left : LTE a c -> (b : Nat) -> LTE (plus b a) (plus b c)
lte_plus_b_left x Z {a = a} {c = c} = x
lte_plus_b_left x (S k) {a = a} {c = c} = rewrite (plusCommutative k a) in rewrite (plusCommutative k c) in lte_plus_b_right (LTESucc x) k

lte_a_plus_b : (LTE c a) -> (b : Nat) -> LTE c (plus a b)
lte_a_plus_b LTEZero _ = LTEZero
lte_a_plus_b x Z {a = a} = rewrite (plusZeroRightNeutral a) in x
lte_a_plus_b x (S k) {a = a} = rewrite (sym (plusSuccRightSucc a k)) in (lte_a_plus_b (lteSuccRight x) k)

plus_2_lte : LTE a b -> LTE c d -> LTE (plus a c) (plus b d)
plus_2_lte LTEZero y {a = Z} {b = b} {c = c} {d = d} = rewrite (plusCommutative b d) in lte_a_plus_b y b
plus_2_lte x LTEZero {a = a} {b = b} {c = Z} {d = d} = rewrite (plusZeroRightNeutral a) in lte_a_plus_b x d
plus_2_lte x y {a = a} {b = b} {c = c} {d = d} = lteTransitive (lte_plus_b_right x c) (lte_plus_b_left y b)

a_plus_b_lte : (a : Nat) -> (b : Nat) -> LTE a (plus a b)
a_plus_b_lte a b = lteAddRight a

lte_a_minus_b : (LTE a c) -> (b : Nat) -> LTE (minus a b) c
lte_a_minus_b LTEZero b = LTEZero
lte_a_minus_b {a = a} x Z = rewrite (minusZeroRight a) in x
lte_a_minus_b x (S b) {a = (S m)} = lte_a_minus_b (lteSuccLeft x) b

mult_2_lte : LTE a b -> LTE c d -> LTE (mult a c) (mult b d)
mult_2_lte LTEZero _ = LTEZero
mult_2_lte x y {a = a} {b = b} {c = Z} {d = d} = rewrite (multZeroRightZero a) in LTEZero
mult_2_lte x y {a = a} {b = b} {c = (S n)} {d = (S m)} = rewrite(multRightSuccPlus a n) in rewrite(multRightSuccPlus b m) in (plus_2_lte x (mult_2_lte x (fromLteSucc y)))

get_lte : (a : Nat) -> (b : Nat) -> LTE (square (minus a b)) (square (plus a b))
get_lte a b = mult_2_lte (lte_a_minus_b (a_plus_b_lte a b) b) (lte_a_minus_b (a_plus_b_lte a b) b)

a_less_b_lte : (LTE a b) -> minus a b = 0
a_less_b_lte {a = Z} {b = _} y = Refl
a_less_b_lte {a = (S m)} {b = (S n)} (LTESucc z) = rewrite (a_less_b_lte z) in Refl

mysq : (a : Nat) -> (b : Nat) -> minus (square (minus a b)) (square (plus a b)) = 0
mysq a b = a_less_b_lte (get_lte a b)
