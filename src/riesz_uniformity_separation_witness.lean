import Mathlib

namespace RieszUniformitySeparation

abbrev Measure := Bool

def Admissible (_μ : Measure) : Prop :=
  True

def requiredTheta : Measure → ℝ
  | false => 1
  | true => 2

def BallImageConclusion
    (μ : Measure)
    (θ : ℝ)
    (_M : NNReal) : Prop :=
  θ = requiredTheta μ


theorem pointwise_bpli :
    ∀ μ : Measure,
      Admissible μ →
        ∃ θ : ℝ,
          0 < θ ∧
            ∃ M : NNReal,
              BallImageConclusion μ θ M := by

  intro μ hμ

  cases μ with

  | false =>
      refine ⟨1, by norm_num, 0, ?_⟩
      rfl

  | true =>
      refine ⟨2, by norm_num, 0, ?_⟩
      rfl


theorem no_uniform_bpli :
    ¬ (∃ θ : ℝ,
        0 < θ ∧
          ∃ M : NNReal,
            ∀ μ : Measure,
              Admissible μ →
                BallImageConclusion μ θ M) := by

  rintro ⟨θ, hθ, M, hM⟩

  have hf :
      θ = 1 := by
    simpa [Admissible, BallImageConclusion, requiredTheta]
      using hM false trivial

  have ht :
      θ = 2 := by
    simpa [Admissible, BallImageConclusion, requiredTheta]
      using hM true trivial

  linarith


theorem pointwise_not_implies_uniform :
    (∀ μ : Measure,
      Admissible μ →
        ∃ θ : ℝ,
          0 < θ ∧
            ∃ M : NNReal,
              BallImageConclusion μ θ M) ∧
      ¬ (∃ θ : ℝ,
          0 < θ ∧
            ∃ M : NNReal,
              ∀ μ : Measure,
                Admissible μ →
                  BallImageConclusion μ θ M) :=
  ⟨pointwise_bpli,
   no_uniform_bpli⟩

end RieszUniformitySeparation
