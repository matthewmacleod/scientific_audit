import Mathlib

noncomputable section

open Filter

def Nonnegative (g : ℕ → ℝ → ℝ) : Prop :=
  ∀ N t, 0 ≤ g N t

theorem analytic_threshold_nosqrt_candidate
    (g : ℕ → ℝ → ℝ)
    (hg : Nonnegative g) :
    ∀ K : ℝ,
      ∀ᶠ N : ℕ in atTop,
        ∀ t : ℝ,
          t ∈ Set.Icc (-(N : ℝ)) (N : ℝ) →
            K ≤ g N t := by
  sorry
