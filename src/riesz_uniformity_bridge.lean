import Mathlib

namespace RieszUniformityBridge

variable {Measure : Type}

variable
  (Admissible : Measure → Prop)
  (BallImageConclusion :
    Measure → ℝ → NNReal → Prop)

theorem uniform_implies_pointwise
    (h :
      ∃ θ : ℝ,
        0 < θ ∧
          ∃ M : NNReal,
            ∀ μ : Measure,
              Admissible μ →
                BallImageConclusion μ θ M) :
    ∀ μ : Measure,
      Admissible μ →
        ∃ θ : ℝ,
          0 < θ ∧
            ∃ M : NNReal,
              BallImageConclusion μ θ M := by

  rcases h with
    ⟨θ, hθ, M, hM⟩

  intro μ hμ

  exact
    ⟨θ, hθ, M, hM μ hμ⟩

end RieszUniformityBridge
