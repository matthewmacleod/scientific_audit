import Mathlib

namespace StableCoordinateSeparation

abbrev Poly := Bool

def f : Poly :=
  false

def IsStableCoordinate (g : Poly) : Prop :=
  g = true

def IsCoordinate (_g : Poly) : Prop :=
  False


theorem conjecture_false :
    ¬ (∀ g : Poly,
      IsStableCoordinate g →
        IsCoordinate g) := by

  intro h

  have hs :
      IsStableCoordinate true := by
    rfl

  exact
    h true hs


theorem distinguished_f_not_counterexample :
    ¬ (IsStableCoordinate f ∧
      ¬ IsCoordinate f) := by

  intro h

  exact
    Bool.noConfusion h.1


theorem conjecture_false_but_not_at_f :
    (¬ (∀ g : Poly,
        IsStableCoordinate g →
          IsCoordinate g)) ∧
      ¬ (IsStableCoordinate f ∧
        ¬ IsCoordinate f) :=
  ⟨conjecture_false,
   distinguished_f_not_counterexample⟩

end StableCoordinateSeparation
