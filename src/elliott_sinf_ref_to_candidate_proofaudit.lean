import Mathlib

noncomputable section

theorem reference_assumed
    (S : Set ℝ)
    (hS : S.Nonempty)
    (hb : BddBelow S)
    (K : ℝ) :
    K ≤ sInf S := by
  sorry

theorem candidate_from_reference
    (S : Set ℝ)
    (hS : S.Nonempty)
    (hb : BddBelow S)
    (K : ℝ) :
    ∀ x ∈ S, K ≤ x := by
  intro x hx
  exact le_trans
    (reference_assumed S hS hb K)
    (csInf_le hb hx)
