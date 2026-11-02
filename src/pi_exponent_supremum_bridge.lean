import Mathlib

namespace PiExponentSupremumBridge

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

/--
Abstract E7-C3.

Once exponent 2 is admissible and every admissible exponent is at
most 2, the irrationality exponent is exactly 2.
-/
theorem exponent_eq_two_of_bounds
    {x : ℝ}
    (htwo : (2 : ℝ) ∈ ApproximationExponents x)
    (hupper :
      ∀ ν ∈ ApproximationExponents x, ν ≤ 2) :
    irrationalityExponent x = 2 := by

  apply le_antisymm

  · exact csSup_le ⟨2, htwo⟩ hupper

  · exact le_csSup ⟨2, hupper⟩ htwo

end PiExponentSupremumBridge
