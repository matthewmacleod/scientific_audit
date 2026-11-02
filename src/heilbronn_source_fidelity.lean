import ComparatorChallenges.HeilbronnTriangle

namespace HeilbronnSourceFidelity

open OAI.Problem355


/--
The exact construction shape formalized by the pinned comparator:
a positive power improvement along an unbounded sequence of sizes.
-/
def UnboundedPowerImprovement : Prop :=
  0 < heilbronnExponent ∧
    ∃ n : ℕ → ℕ,
      ∃ P : ℕ → Finset Point,
        Filter.Tendsto n Filter.atTop Filter.atTop ∧
          ∀ j : ℕ,
            3 ≤ n j ∧
            (P j).card = n j ∧
            pointsInUnitSquare (P j) ∧
            triangleAreasAtLeast
              (P j)
              (Real.rpow
                (n j : ℝ)
                (-2 + heilbronnExponent))


/--
The pinned OpenAI power-lower-bound theorem has exactly the
unbounded-subsequence statement above.
-/
theorem pinned_power_lower_bound :
    UnboundedPowerImprovement := by
  exact heilbronn_power_lower_bound


/--
The second pinned theorem really states positivity of half the
improvement exponent together with refutation of the corresponding
eventual almost-n^-2 upper bound.
-/
def AlmostUpperBoundRefutation : Prop :=
  0 < heilbronnExponent / 2 ∧
    ¬ eventualAlmostUpperBound
        (heilbronnExponent / 2)


theorem pinned_almost_upper_bound_refutation :
    AlmostUpperBoundRefutation := by
  exact almost_n_minus_two_refuted

end HeilbronnSourceFidelity
