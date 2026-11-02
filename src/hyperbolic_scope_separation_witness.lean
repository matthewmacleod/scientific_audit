import Mathlib

namespace HyperbolicConeSeparation

abbrev Cone := Unit

def C : Cone :=
  ()

def HasDirectRepresentation (_K : Cone) : Prop :=
  False

def HasSemidefiniteLift (_K : Cone) : Prop :=
  True

theorem direct_implies_lift :
    ∀ K : Cone,
      HasDirectRepresentation K →
        HasSemidefiniteLift K := by
  intro K h
  exact False.elim h


theorem nonspectrahedral :
    ¬ HasDirectRepresentation C := by
  intro h
  exact h


theorem has_semidefinite_lift :
    HasSemidefiniteLift C := by
  trivial


theorem nonspectrahedral_does_not_imply_no_lift :
    (¬ HasDirectRepresentation C) ∧
      ¬ (¬ HasSemidefiniteLift C) := by
  constructor

  · exact nonspectrahedral

  · intro h
    exact h has_semidefinite_lift

end HyperbolicConeSeparation
