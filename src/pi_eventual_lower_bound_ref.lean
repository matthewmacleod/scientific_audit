import Mathlib

namespace PiExponentSubstantive

def EventualLowerBound (x : ℝ) : Prop :=
  ∀ ν : ℝ,
    2 < ν →
      ∃ Q : ℕ,
        2 ≤ Q ∧
          ∀ (p : ℤ) (q : ℕ),
            Q ≤ q →
              (q : ℝ) ^ (-ν) ≤
                |x - (p : ℝ) / (q : ℝ)|

theorem pi_eventual_lower_bound_ref :
    EventualLowerBound Real.pi := by
  sorry

end PiExponentSubstantive
