import ComparatorChallenges.IrrationalTriangleBilliard

namespace WeakMixingSourceFidelity

open MeasureTheory Set
open scoped ENNReal symmDiff

open OAI.TriangularBilliards


/--
The ordinary ergodicity clause appearing as the final conjunct of
OpenAI's pinned `MainConclusion`.
-/
def OrdinaryErgodicityConclusion
    (Q : Triangle) : Prop :=
  ∀ A : Set Phase,
    MeasurableSet A →
      (∀ t : ℝ,
        phaseMeasure Q
          (((billiardFlow Q t) ⁻¹' A) ∆ A) = 0) →
      phaseMeasure Q A = 0 ∨
        phaseMeasure Q A = 1


/--
The pinned comparator's `MainConclusion` directly contains ordinary
ergodicity as its final conjunct.
-/
theorem mainConclusion_implies_ordinaryErgodicity
    (Q : Triangle)
    (h : MainConclusion Q) :
    OrdinaryErgodicityConclusion Q := by

  unfold MainConclusion at h

  exact h.2.2.2.2.2


/--
Therefore the actual pinned comparator theorem for an irrational
triangle entails the ordinary ergodicity criterion.
-/
theorem pinned_comparator_implies_ordinaryErgodicity
    (Q : Triangle)
    (hQ : Q.HasIrrationalAngle) :
    OrdinaryErgodicityConclusion Q := by

  exact
    mainConclusion_implies_ordinaryErgodicity
      Q
      (irrational_triangle_billiard Q hQ)

end WeakMixingSourceFidelity
