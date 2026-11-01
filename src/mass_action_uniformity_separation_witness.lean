import Mathlib

namespace MassActionUniformitySeparation

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def PositiveState (x0 : ℝ) : Prop :=
  0 < x0

/-- Concrete bound relation used for the separation model. -/
def Bound (ε x0 : ℝ) : Prop :=
  ε ≤ x0

def UniformStatement : Prop :=
  ∃ ε : ℝ,
    GoodEpsilon ε ∧
      ∀ x0 : ℝ,
        PositiveState x0 →
          Bound ε x0

def PointwiseStatement : Prop :=
  ∀ x0 : ℝ,
    PositiveState x0 →
      ∃ ε : ℝ,
        GoodEpsilon ε ∧
          Bound ε x0

/-- Every positive initial state admits its own positive epsilon. -/
theorem pointwise_statement_true :
    PointwiseStatement := by
  intro x0 hx

  let ε : ℝ := min (x0 / 2) (1 / 2)

  have hxhalf : 0 < x0 / 2 := by
    dsimp [PositiveState] at hx
    linarith

  have hhalf : 0 < (1 / 2 : ℝ) := by
    norm_num

  have hεpos : 0 < ε := by
    dsimp [ε]
    exact lt_min hxhalf hhalf

  have hεlt : ε < 1 := by
    dsimp [ε]
    exact lt_of_le_of_lt
      (min_le_right (x0 / 2) (1 / 2))
      (by norm_num)

  have hεx : ε ≤ x0 := by
    dsimp [ε]
    exact le_trans
      (min_le_left (x0 / 2) (1 / 2))
      (by linarith)

  exact ⟨ε, ⟨hεpos, hεlt⟩, hεx⟩

/-- No single positive epsilon can work for every positive initial state. -/
theorem uniform_statement_false :
    ¬ UniformStatement := by
  rintro ⟨ε, hε, hall⟩

  have hx : PositiveState (ε / 2) := by
    dsimp [PositiveState]
    linarith [hε.1]

  have hbound := hall (ε / 2) hx

  change ε ≤ ε / 2 at hbound
  linarith [hε.1]

/-- Explicit model satisfying the pointwise candidate
    while falsifying the uniform reference. -/
theorem separation :
    PointwiseStatement ∧ ¬ UniformStatement := by
  exact ⟨pointwise_statement_true, uniform_statement_false⟩

/-- Therefore pointwise existence does not imply
    existence of a uniform witness. -/
theorem reverse_implication_fails :
    ¬ (PointwiseStatement → UniformStatement) := by
  intro h
  exact uniform_statement_false
    (h pointwise_statement_true)

end MassActionUniformitySeparation
