import ComparatorChallenges.RieszQuantitative

namespace RieszSourceFidelity

open MeasureTheory

open OAI.RieszRectifiability


/--
The pinned comparator written out explicitly.

Crucially, θ and M are chosen before μ, so the same quantitative
constants work for the entire class with fixed d, n, C_AD, and C_R.
-/
def ExpandedQuantitativeStatement : Prop :=
  ∀ d n : ℕ,
    4 ≤ d →
      2 ≤ n →
        n + 2 ≤ d →
          ∀ C_AD : ℝ,
            1 ≤ C_AD →
              ∀ C_R : NNReal,
                ∃ θ : ℝ,
                  0 < θ ∧
                    ∃ M : NNReal,
                      ∀ μ : Measure (Ambient d),
                        μ.Regular →
                          ADRegularWithConstant n C_AD μ →
                            RieszL2BoundedWithConstant n C_R μ →
                              BallImageConclusion n μ θ M


/--
The explicit class-uniform statement is definitionally identical
to the target used by the pinned comparator.
-/
theorem expanded_iff_pinned :
    ExpandedQuantitativeStatement ↔
      QuantitativeFullStatement := by
  rfl


/--
Hence the exact pinned comparator theorem has the advertised
class-uniform quantitative quantifier structure.
-/
theorem pinned_comparator_has_uniform_constants :
    ExpandedQuantitativeStatement := by

  exact
    expanded_iff_pinned.mpr
      quantitative_higher_codimension_riesz_rectifiability

end RieszSourceFidelity
