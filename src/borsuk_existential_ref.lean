import Mathlib

noncomputable section

namespace BorsukExistential

abbrev Matrix4 :=
  EuclideanSpace ℝ (Fin 4 × Fin 4)

def traceOneSymmetric : Set Matrix4 :=
  {A |
    (∀ i j : Fin 4, A (i, j) = A (j, i)) ∧
    ∑ i : Fin 4, A (i, i) = 1}

def HasTenSmallCover (S : Set Matrix4) : Prop :=
  ∃ C : Fin 10 → Set Matrix4,
    (∀ i, C i ⊆ S) ∧
    S ⊆ ⋃ i, C i ∧
    ∀ i, Metric.diam (C i) < Real.sqrt 2

/-- Existential form of the Borsuk witness claim,
    still expressed in the trace-one matrix representation. -/
theorem borsuk_existential_ref :
    ∃ S : Set Matrix4,
      IsCompact S ∧
      S ⊆ traceOneSymmetric ∧
      Metric.diam S = Real.sqrt 2 ∧
      ¬ HasTenSmallCover S := by
  sorry

end BorsukExistential
