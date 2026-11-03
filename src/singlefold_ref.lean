import Mathlib

namespace SingleFoldAudit

axiom Input : Type
axiom Witness : Type

axiom Member : Input → Prop
axiom Solves : Input → Witness → Prop

def RefStatement : Prop :=
  ∀ a : Input,
    (Member a ↔ ∃ w, Solves a w) ∧
    ∀ w v, Solves a w → Solves a v → w = v

theorem singlefold_ref : RefStatement := by
  sorry

end SingleFoldAudit
