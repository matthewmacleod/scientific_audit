import OAI.Computability.TypeSystem.Normalization

namespace ScientificAudit
namespace E17C

open OAI.PureTypeSystem

universe u

/--
The actual OpenAI implementation implies the fully expanded
claim-shaped normalization statement used in the audit.

Weak normalization:
  every legal term in every valid context reaches some beta-normal form.

Strong normalization:
  every legal term in every valid context is accessible under the
  converse beta-reduction relation.
-/
theorem actual_implementation_implies_expanded
    {S : Type u}
    (P : Specification S)
    (hWeak :
      ∀ Γ, ValidContext P Γ →
        ∀ M, Legal P Γ M →
          ∃ N,
            Relation.ReflTransGen Beta M N ∧
            (∀ K, ¬ Beta N K)) :
    ∀ Γ, ValidContext P Γ →
      ∀ M, Legal P Γ M →
        Acc (fun N M : Expr S => Beta M N) M := by

  have hSystemWeak : SystemWeaklyNormalizing P := by
    intro Γ hΓ M hM
    obtain ⟨N, hRed, hNormal⟩ := hWeak Γ hΓ M hM
    exact ⟨N, hRed, hNormal⟩

  have hSystemStrong : SystemStronglyNormalizing P :=
    OAI.PureTypeSystem.weak_implies_strong P hSystemWeak

  intro Γ hΓ M hM
  exact hSystemStrong Γ hΓ M hM

#print axioms OAI.PureTypeSystem.weak_implies_strong
#print axioms ScientificAudit.E17C.actual_implementation_implies_expanded

end E17C
end ScientificAudit
