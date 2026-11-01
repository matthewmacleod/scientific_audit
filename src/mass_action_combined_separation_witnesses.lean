import Mathlib


/-! ## Model 1: uniform-eventual true, pointwise-all-time false -/

namespace UniformEventualNotAllTime

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def PositiveState (x0 : ℝ) : Prop :=
  0 < x0

def Bound (_ε _x0 t : ℝ) : Prop :=
  1 ≤ t

def UniformEventualStatement : Prop :=
  ∃ ε : ℝ,
    GoodEpsilon ε ∧
      ∀ x0 : ℝ,
        PositiveState x0 →
          ∃ T : ℝ,
            0 ≤ T ∧
              ∀ t : ℝ,
                T ≤ t →
                  Bound ε x0 t

def PointwiseAllTimeStatement : Prop :=
  ∀ x0 : ℝ,
    PositiveState x0 →
      ∃ ε : ℝ,
        GoodEpsilon ε ∧
          ∀ t : ℝ,
            0 ≤ t →
              Bound ε x0 t

theorem uniform_eventual_true :
    UniformEventualStatement := by
  refine ⟨1 / 2, ?_, ?_⟩
  · constructor <;> norm_num
  · intro x0 hx
    refine ⟨1, by norm_num, ?_⟩
    intro t ht
    exact ht

theorem pointwise_all_time_false :
    ¬ PointwiseAllTimeStatement := by
  intro hcand

  have hx : PositiveState 1 := by
    unfold PositiveState
    norm_num

  rcases hcand 1 hx with ⟨ε, hε, hall⟩

  have h0 := hall 0 (by norm_num)

  change (1 : ℝ) ≤ 0 at h0
  norm_num at h0

theorem separation :
    UniformEventualStatement ∧
      ¬ PointwiseAllTimeStatement := by
  exact ⟨
    uniform_eventual_true,
    pointwise_all_time_false
  ⟩

theorem reference_does_not_imply_candidate :
    ¬ (UniformEventualStatement →
      PointwiseAllTimeStatement) := by
  intro h
  exact pointwise_all_time_false
    (h uniform_eventual_true)

end UniformEventualNotAllTime


/-! ## Model 2: pointwise-all-time true, uniform-eventual false -/

namespace AllTimeNotUniformEventual

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def PositiveState (x0 : ℝ) : Prop :=
  0 < x0

def Bound (ε x0 _t : ℝ) : Prop :=
  ε ≤ x0

def UniformEventualStatement : Prop :=
  ∃ ε : ℝ,
    GoodEpsilon ε ∧
      ∀ x0 : ℝ,
        PositiveState x0 →
          ∃ T : ℝ,
            0 ≤ T ∧
              ∀ t : ℝ,
                T ≤ t →
                  Bound ε x0 t

def PointwiseAllTimeStatement : Prop :=
  ∀ x0 : ℝ,
    PositiveState x0 →
      ∃ ε : ℝ,
        GoodEpsilon ε ∧
          ∀ t : ℝ,
            0 ≤ t →
              Bound ε x0 t

theorem pointwise_all_time_true :
    PointwiseAllTimeStatement := by
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

  refine ⟨ε, ⟨hεpos, hεlt⟩, ?_⟩

  intro t ht
  exact hεx

theorem uniform_eventual_false :
    ¬ UniformEventualStatement := by
  rintro ⟨ε, hε, hall⟩

  have hx : PositiveState (ε / 2) := by
    dsimp [PositiveState]
    linarith [hε.1]

  rcases hall (ε / 2) hx with ⟨T, hT, hallT⟩

  have hbound := hallT T le_rfl

  change ε ≤ ε / 2 at hbound
  linarith [hε.1]

theorem separation :
    PointwiseAllTimeStatement ∧
      ¬ UniformEventualStatement := by
  exact ⟨
    pointwise_all_time_true,
    uniform_eventual_false
  ⟩

theorem candidate_does_not_imply_reference :
    ¬ (PointwiseAllTimeStatement →
      UniformEventualStatement) := by
  intro h
  exact uniform_eventual_false
    (h pointwise_all_time_true)

end AllTimeNotUniformEventual
