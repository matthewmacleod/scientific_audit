import Mathlib

namespace ReconstructionThresholdCountermodel

def Reconstructs (_x : ℝ) : Prop :=
  True

def RefStatement : Prop :=
  ∀ x : ℝ,
    (1 < x → Reconstructs x) ∧
    (x ≤ 1 → ¬ Reconstructs x)

def CandidateStatement : Prop :=
  ∀ x : ℝ,
    1 < x → Reconstructs x

theorem candidate_holds :
    CandidateStatement := by
  intro x hx
  trivial

theorem ref_fails :
    ¬ RefStatement := by
  intro hRef

  have hNot :
      ¬ Reconstructs (1 : ℝ) :=
    (hRef 1).2 le_rfl

  exact hNot trivial

theorem candidate_does_not_imply_ref :
    ¬ (CandidateStatement → RefStatement) := by
  intro h
  exact ref_fails (h candidate_holds)

#print axioms ReconstructionThresholdCountermodel.candidate_holds
#print axioms ReconstructionThresholdCountermodel.ref_fails
#print axioms ReconstructionThresholdCountermodel.candidate_does_not_imply_ref

end ReconstructionThresholdCountermodel
