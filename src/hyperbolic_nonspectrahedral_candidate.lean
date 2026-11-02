import Mathlib

namespace HyperbolicConeScope

axiom Cone : Type
axiom C : Cone

axiom HasDirectRepresentation : Cone → Prop
axiom HasSemidefiniteLift : Cone → Prop

axiom direct_implies_lift :
  ∀ K : Cone,
    HasDirectRepresentation K →
      HasSemidefiniteLift K

theorem hyperbolic_nonspectrahedral_candidate :
    ¬ HasDirectRepresentation C := by
  sorry

end HyperbolicConeScope
