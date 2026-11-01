import Mathlib

noncomputable section

namespace BorsukIsometry

abbrev SpaceA :=
  EuclideanSpace ℝ (Fin 9)

abbrev SpaceB :=
  EuclideanSpace ℝ (Fin 3 × Fin 3)

def HasTenSmallCover {α : Type*}
    [MetricSpace α]
    (S : Set α)
    (r : ℝ) : Prop :=
  ∃ C : Fin 10 → Set α,
    (∀ i, C i ⊆ S) ∧
    S ⊆ ⋃ i, C i ∧
    ∀ i, Metric.diam (C i) < r

def BorsukObstruction {α : Type*}
    [MetricSpace α]
    (S : Set α)
    (r : ℝ) : Prop :=
  IsCompact S ∧
  Metric.diam S = r ∧
  ¬ HasTenSmallCover S r

/-- E6-B candidate: obstruction after isometric transport. -/
theorem borsuk_isometry_candidate
    (transport : SpaceA ≃ᵢ SpaceB)
    (witness : Set SpaceA) :
    BorsukObstruction
      (transport '' witness)
      (Real.sqrt 2) := by
  sorry

end BorsukIsometry
