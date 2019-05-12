%default total

mymax : (a : Nat) -> (b : Nat) -> maximum a (minimum a b) = a
mymax Z Z = Refl
mymax Z b = Refl
mymax a Z = rewrite (minimumZeroZeroLeft a) in maximumZeroNLeft a
mymax (S a) (S b) = rewrite (mymax a b) in Refl
