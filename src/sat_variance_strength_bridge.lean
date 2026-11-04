import Mathlib

namespace SATVarianceStrengthBridge

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

def CandidateStatement : Prop :=
  ∃ c C N : ℝ,
    0 < c ∧
    0 ≤ C ∧
    1 ≤ N ∧
    ∀ x : ℝ, N ≤ x →
      c * x ≤ Variance x ∧
      Variance x ≤ C * x * LogFactor x

theorem ref_implies_candidate :
    RefStatement → CandidateStatement := by
  intro hRef
  rcases hRef with ⟨c, C, N, hc, hC, hN, hBounds⟩
  refine ⟨c, C, N, hc, hC, hN, ?_⟩
  intro x hx

  rcases hBounds x hx with ⟨hLower, hUpper⟩
  refine ⟨hLower, ?_⟩

  have hx1 : 1 ≤ x :=
    le_trans hN hx

  have hx0 : 0 ≤ x := by
    linarith

  have hLog : 1 ≤ LogFactor x :=
    logFactor_ge_one x hx1

  have hCx : 0 ≤ C * x :=
    mul_nonneg hC hx0

  have hScale :
      C * x ≤ C * x * LogFactor x := by
    have h :=
      mul_le_mul_of_nonneg_left hLog hCx
    simpa using h

  exact hUpper.trans hScale

#print axioms SATVarianceStrengthBridge.ref_implies_candidate

end SATVarianceStrengthBridge
