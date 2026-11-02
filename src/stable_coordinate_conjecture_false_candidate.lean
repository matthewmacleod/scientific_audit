import Mathlib

namespace StableCoordinateAudit

axiom Poly : Type
axiom f : Poly

opaque IsStableCoordinate : Poly → Prop
opaque IsCoordinate : Poly → Prop

theorem stable_coordinate_conjecture_false_candidate :
    ¬ (∀ g : Poly,
      IsStableCoordinate g →
        IsCoordinate g) := by
  sorry

end StableCoordinateAudit
