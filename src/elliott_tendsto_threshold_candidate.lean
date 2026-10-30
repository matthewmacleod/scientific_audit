import Mathlib

open Filter

theorem tendsto_threshold_candidate (h : ℕ → ℝ) :
    ∀ K : ℝ,
      ∀ᶠ N : ℕ in atTop,
        K ≤ h N := by
  sorry
