import Mathlib

namespace PiExponentRepresentation

def EventualLowerBound (x : ℝ) : Prop :=
  ∀ ν : ℝ,
    2 < ν →
      ∃ Q : ℕ,
        2 ≤ Q ∧
          ∀ (p : ℤ) (q : ℕ),
            Q ≤ q →
              (q : ℝ) ^ (-ν) ≤
                |x - (p : ℝ) / (q : ℝ)|

theorem pi_eventual_nat_ref :
    EventualLowerBound Real.pi := by
  sorry

end PiExponentRepresentation
