import Mathlib

namespace NormalizationAudit

axiom Expr : Type
axiom Context : Type
axiom Specification : Type

axiom ValidContext : Specification → Context → Prop
axiom Legal : Specification → Context → Expr → Prop
axiom Beta : Expr → Expr → Prop

theorem normalization_ref :
    ∀ P : Specification,
      (∀ Γ, ValidContext P Γ →
        ∀ M, Legal P Γ M →
          ∃ N,
            Relation.ReflTransGen Beta M N ∧
            (∀ K, ¬ Beta N K)) →
      ∀ Γ, ValidContext P Γ →
        ∀ M, Legal P Γ M →
          Acc (fun N M : Expr => Beta M N) M := by
  sorry

end NormalizationAudit
