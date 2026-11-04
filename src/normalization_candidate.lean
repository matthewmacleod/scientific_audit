import Mathlib

namespace NormalizationAudit

axiom Expr : Type
axiom Context : Type
axiom Specification : Type

axiom ValidContext : Specification → Context → Prop
axiom Legal : Specification → Context → Expr → Prop
axiom Beta : Expr → Expr → Prop

def Normal (M : Expr) : Prop :=
  ∀ N, ¬ Beta M N

def WeaklyNormalizing (M : Expr) : Prop :=
  ∃ N, Relation.ReflTransGen Beta M N ∧ Normal N

def StronglyNormalizing (M : Expr) : Prop :=
  Acc (fun N M : Expr => Beta M N) M

def SystemWeaklyNormalizing (P : Specification) : Prop :=
  ∀ Γ, ValidContext P Γ →
    ∀ M, Legal P Γ M →
      WeaklyNormalizing M

def SystemStronglyNormalizing (P : Specification) : Prop :=
  ∀ Γ, ValidContext P Γ →
    ∀ M, Legal P Γ M →
      StronglyNormalizing M

theorem normalization_candidate :
    ∀ P : Specification,
      SystemWeaklyNormalizing P →
      SystemStronglyNormalizing P := by
  sorry

end NormalizationAudit
