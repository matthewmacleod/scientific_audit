import Mathlib

noncomputable section

open Filter

def Nonnegative (g : ℕ → ℝ → ℝ) : Prop :=
  ∀ N t, 0 ≤ g N t

theorem analytic_infimum_nosqrt_ref
    (g : ℕ → ℝ → ℝ)
    (hg : Nonnegative g) :
    Tendsto
      (fun N : ℕ =>
        sInf ((fun t : ℝ => g N t) ''
          Set.Icc (-(N : ℝ)) (N : ℝ)))
      atTop atTop := by
  sorry
