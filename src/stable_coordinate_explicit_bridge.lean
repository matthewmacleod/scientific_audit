import Mathlib

namespace StableCoordinateBridge

variable {Poly : Type}

variable
  (IsStableCoordinate : Poly → Prop)
  (IsCoordinate : Poly → Prop)

theorem explicitCounterexample_implies_conjectureFalse
    (f : Poly)
    (h :
      IsStableCoordinate f ∧
        ¬ IsCoordinate f) :
    ¬ (∀ g : Poly,
      IsStableCoordinate g →
        IsCoordinate g) := by

  intro hconj

  exact
    h.2
      (hconj f h.1)

end StableCoordinateBridge
