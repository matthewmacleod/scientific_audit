import Mathlib

noncomputable section

namespace BorsukExistentialBridge

abbrev Vector4 :=
  EuclideanSpace ℝ (Fin 4)

abbrev Matrix4 :=
  EuclideanSpace ℝ (Fin 4 × Fin 4)

def projector (u : Vector4) : Matrix4 :=
  WithLp.toLp 2
    (fun ij => u ij.1 * u ij.2)

def projectorSet : Set Matrix4 :=
  projector '' {u : Vector4 | ‖u‖ = 1}

def traceOneSymmetric : Set Matrix4 :=
  {A |
    (∀ i j : Fin 4, A (i, j) = A (j, i)) ∧
    ∑ i : Fin 4, A (i, i) = 1}

def HasTenSmallCover (S : Set Matrix4) : Prop :=
  ∃ C : Fin 10 → Set Matrix4,
    (∀ i, C i ⊆ S) ∧
    S ⊆ ⋃ i, C i ∧
    ∀ i, Metric.diam (C i) < Real.sqrt 2

def CandidateStatement : Prop :=
  IsCompact projectorSet ∧
  projectorSet ⊆ traceOneSymmetric ∧
  Metric.diam projectorSet = Real.sqrt 2 ∧
  ¬ HasTenSmallCover projectorSet

def ReferenceStatement : Prop :=
  ∃ S : Set Matrix4,
    IsCompact S ∧
    S ⊆ traceOneSymmetric ∧
    Metric.diam S = Real.sqrt 2 ∧
    ¬ HasTenSmallCover S

/--
The specific projector witness immediately supplies the existential
Borsuk witness: instantiate S with projectorSet.
-/
theorem candidate_implies_reference :
    CandidateStatement → ReferenceStatement := by
  intro h
  exact ⟨projectorSet, h⟩

end BorsukExistentialBridge
