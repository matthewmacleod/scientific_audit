import Mathlib

noncomputable section

theorem sinf_lower_bound_ref
    (S : Set ℝ)
    (hS : S.Nonempty)
    (hb : BddBelow S)
    (K : ℝ) :
    K ≤ sInf S := by
  sorry
