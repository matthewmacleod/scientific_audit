import Mathlib

noncomputable section

theorem sqrt_to_square
    (x r : ℝ)
    (hx : 0 ≤ x)
    (hr : 0 ≤ r)
    (h : r ≤ Real.sqrt x) :
    r ^ 2 ≤ x := by
  have hs := Real.sq_sqrt hx
  have hsn := Real.sqrt_nonneg x
  nlinarith

theorem square_to_sqrt
    (x r : ℝ)
    (hx : 0 ≤ x)
    (h : r ^ 2 ≤ x) :
    r ≤ Real.sqrt x := by
  have hs := Real.sq_sqrt hx
  have hsn := Real.sqrt_nonneg x
  nlinarith
