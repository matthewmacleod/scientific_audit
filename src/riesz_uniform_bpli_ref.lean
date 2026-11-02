import Mathlib

namespace RieszUniformityAudit

axiom Measure : Type

axiom Admissible : Measure → Prop

axiom BallImageConclusion :
  Measure → ℝ → NNReal → Prop

theorem riesz_uniform_bpli_ref :
    ∃ θ : ℝ,
      0 < θ ∧
        ∃ M : NNReal,
          ∀ μ : Measure,
            Admissible μ →
              BallImageConclusion μ θ M := by
  sorry

end RieszUniformityAudit
