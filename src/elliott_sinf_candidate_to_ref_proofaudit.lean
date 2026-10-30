import Mathlib

noncomputable section

theorem candidate_assumed
    (S : Set ℝ)
    (hS : S.Nonempty)
    (hb : BddBelow S)
    (K : ℝ) :
    ∀ x ∈ S, K ≤ x := by
  sorry

theorem reference_from_candidate
    (S : Set ℝ)
    (hS : S.Nonempty)
    (hb : BddBelow S)
    (K : ℝ) :
    K ≤ sInf S := by
  exact le_csInf hS
    (candidate_assumed S hS hb K)
