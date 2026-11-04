import Mathlib

namespace ReconstructionThresholdBridge

axiom Reconstructs : ℝ → Prop

def RefStatement : Prop :=
  ∀ x : ℝ,
    (1 < x → Reconstructs x) ∧
    (x ≤ 1 → ¬ Reconstructs x)

def CandidateStatement : Prop :=
  ∀ x : ℝ,
    1 < x → Reconstructs x

theorem ref_implies_candidate :
    RefStatement → CandidateStatement := by
  intro hRef
  intro x hx
  exact (hRef x).1 hx

#print axioms ReconstructionThresholdBridge.ref_implies_candidate

end ReconstructionThresholdBridge
