import Mathlib

namespace PiExponentDefinition

theorem pi_irrationality_expanded_candidate :
    sSup
      {ν : ℝ |
        0 < ν ∧
        Set.Infinite
          {r : ℚ |
            2 ≤ r.den ∧
            0 < |Real.pi - (r : ℝ)| ∧
            |Real.pi - (r : ℝ)| <
              (r.den : ℝ) ^ (-ν)}} =
      2 := by
  sorry

end PiExponentDefinition
