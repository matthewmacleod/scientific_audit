import Mathlib

namespace PiExponentDefinition

def GoodRationalApproximations (x ν : ℝ) : Set ℚ :=
  {r |
    2 ≤ r.den ∧
    0 < |x - (r : ℝ)| ∧
    |x - (r : ℝ)| < (r.den : ℝ) ^ (-ν)}

def ApproximationExponents (x : ℝ) : Set ℝ :=
  {ν |
    0 < ν ∧
    (GoodRationalApproximations x ν).Infinite}

noncomputable def irrationalityExponent (x : ℝ) : ℝ :=
  sSup (ApproximationExponents x)

theorem pi_irrationality_named_ref :
    irrationalityExponent Real.pi = 2 := by
  sorry

end PiExponentDefinition
