import Mathlib

namespace RieszUniformityAudit

axiom Measure : Type

axiom Admissible : Measure → Prop

axiom BallImageConclusion :
  Measure → ℝ → NNReal → Prop

theorem riesz_pointwise_bpli_candidate :
    ∀ μ : Measure,
      Admissible μ →
        ∃ θ : ℝ,
          0 < θ ∧
            ∃ M : NNReal,
              BallImageConclusion μ θ M := by
  sorry

end RieszUniformityAudit
