import Mathlib

namespace SingleFoldAudit

axiom Input : Type
axiom Witness : Type

axiom Member : Input → Prop
axiom Solves : Input → Witness → Prop

def CandidateStatement : Prop :=
  ∀ a : Input,
    (Member a → ∃! w, Solves a w) ∧
    (¬ Member a → ¬ ∃ w, Solves a w)

theorem singlefold_candidate : CandidateStatement := by
  sorry

end SingleFoldAudit
