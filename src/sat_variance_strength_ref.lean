import Mathlib

namespace SATVarianceStrength

axiom Variance : ℝ → ℝ
axiom LogFactor : ℝ → ℝ

axiom logFactor_ge_one :
  ∀ x : ℝ, 1 ≤ x → 1 ≤ LogFactor x

def RefStatement : Prop :=
  ∃ c C N : ℝ,
    0 < c ∧
    0 ≤ C ∧
    1 ≤ N ∧
    ∀ x : ℝ, N ≤ x →
      c * x ≤ Variance x ∧
      Variance x ≤ C * x

theorem sat_variance_strength_ref : RefStatement := by
  sorry

end SATVarianceStrength
