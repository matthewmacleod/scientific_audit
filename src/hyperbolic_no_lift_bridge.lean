import Mathlib

namespace HyperbolicConeBridge

variable {Cone : Type}

variable
  (HasDirectRepresentation : Cone → Prop)
  (HasSemidefiniteLift : Cone → Prop)

variable
  (direct_implies_lift :
    ∀ K : Cone,
      HasDirectRepresentation K →
        HasSemidefiniteLift K)

include direct_implies_lift

theorem noLift_implies_nonspectrahedral
    (C : Cone)
    (h :
      ¬ HasSemidefiniteLift C) :
    ¬ HasDirectRepresentation C := by

  intro hDirect

  exact
    h
      (direct_implies_lift C hDirect)

end HyperbolicConeBridge
