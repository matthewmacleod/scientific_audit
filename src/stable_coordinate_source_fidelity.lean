import ComparatorChallenges.StableCoordinateFour

namespace StableCoordinateSourceFidelity

open OAI.StableCoordinate


/--
The exact pinned comparator contains the degree-five,
one-stable-but-noncoordinate polynomial claim.
-/
theorem pinned_polynomial_package :
    f.totalDegree = 5 ∧
      IsOneStableCoordinate f ∧
      ¬ IsCoordinate (by decide : 0 < 4) f := by
  exact principal_package.1


/--
The exact pinned comparator also contains the all-fiber claim:
every complex fiber is affine three-space and nonrectifiable.
-/
theorem pinned_fiber_package :
    ∀ t : ℂ,
      IsAffineThreeSpaceFiber t ∧
        ¬ IsRectifiableFiber t := by
  exact principal_package.2


/--
The stable-but-noncoordinate witness supplied by the pinned
comparator directly refutes the four-variable one-stable
coordinate conjecture.
-/
theorem pinned_counterexample_refutes_conjecture :
    ¬ (∀ g : R 4,
      IsOneStableCoordinate g →
        IsCoordinate (by decide : 0 < 4) g) := by

  intro h

  have hp :
      IsOneStableCoordinate f ∧
        ¬ IsCoordinate (by decide : 0 < 4) f :=
    principal_package.1.2

  exact hp.2 (h f hp.1)

end StableCoordinateSourceFidelity
