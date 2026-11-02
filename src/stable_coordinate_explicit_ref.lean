import Mathlib

namespace StableCoordinateAudit

axiom Poly : Type
axiom f : Poly

opaque IsStableCoordinate : Poly → Prop
opaque IsCoordinate : Poly → Prop

theorem stable_coordinate_explicit_ref :
    IsStableCoordinate f ∧
      ¬ IsCoordinate f := by
  sorry

end StableCoordinateAudit
