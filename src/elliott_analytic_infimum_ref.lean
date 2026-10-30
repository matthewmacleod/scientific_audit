import Mathlib

noncomputable section

open Filter

def windowSqrtSet (d : ℕ → ℝ → ℝ) (N : ℕ) : Set ℝ :=
  (fun t : ℝ => Real.sqrt (d N t)) ''
    Set.Icc (-(N : ℝ)) (N : ℝ)

theorem analytic_infimum_ref (d : ℕ → ℝ → ℝ) :
    Tendsto
      (fun N : ℕ => sInf (windowSqrtSet d N))
      atTop atTop := by
  sorry
