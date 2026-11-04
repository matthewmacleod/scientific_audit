import Mathlib

namespace SATVarianceStrengthCountermodel

def Variance (x : ℝ) : ℝ :=
  x * x

def LogFactor (x : ℝ) : ℝ :=
  x

theorem logFactor_ge_one :
    ∀ x : ℝ, 1 ≤ x → 1 ≤ LogFactor x := by
  intro x hx
  exact hx

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

theorem candidate_holds :
    CandidateStatement := by
  refine ⟨1, 1, 1, by norm_num, by norm_num, by norm_num, ?_⟩
  intro x hx

  have hx0 : 0 ≤ x := by
    linarith

  have hxsub : 0 ≤ x - 1 := by
    linarith

  constructor

  · dsimp [Variance]
    have hprod : 0 ≤ x * (x - 1) :=
      mul_nonneg hx0 hxsub
    nlinarith

  · dsimp [Variance, LogFactor]
    ring_nf
    exact le_rfl

theorem ref_fails :
    ¬ RefStatement := by
  intro hRef
  rcases hRef with ⟨c, C, N, hc, hC, hN, hBounds⟩

  let x : ℝ := max N (C + 1)

  have hNx : N ≤ x :=
    le_max_left N (C + 1)

  have hCx : C + 1 ≤ x :=
    le_max_right N (C + 1)

  have hx1 : 1 ≤ x :=
    le_trans hN hNx

  have hx0 : 0 < x := by
    linarith

  have hUpper :=
    (hBounds x hNx).2

  dsimp [Variance] at hUpper

  have hDiff : 0 < x - C := by
    linarith

  have hPositive : 0 < (x - C) * x :=
    mul_pos hDiff hx0

  nlinarith

theorem candidate_does_not_imply_ref :
    ¬ (CandidateStatement → RefStatement) := by
  intro h
  exact ref_fails (h candidate_holds)

#print axioms SATVarianceStrengthCountermodel.candidate_holds
#print axioms SATVarianceStrengthCountermodel.ref_fails
#print axioms SATVarianceStrengthCountermodel.candidate_does_not_imply_ref

end SATVarianceStrengthCountermodel
