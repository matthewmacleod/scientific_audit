import Mathlib

open MeasureTheory
open scoped RealInnerProductSpace ENNReal

noncomputable section

abbrev AuditSpace (n : ℕ) := EuclideanSpace ℝ (Fin n)

/-- Exact geometric form used in OpenAI's LocalSmoothing comparator:
    centered unit segment parameterized by t ∈ [-1/2, 1/2]. -/
def OAIUnitSegment {n : ℕ} (ω x : AuditSpace n) : Set (AuditSpace n) :=
  {y | ∃ t ∈ Set.Icc (- (1 / 2 : ℝ)) (1 / 2), y = x + t • ω}

def OAIIsKakeyaSet {n : ℕ} (F : Set (AuditSpace n)) : Prop :=
  ∀ ω : AuditSpace n, ‖ω‖ = 1 → ∃ x, OAIUnitSegment ω x ⊆ F

/-- Independent standard geometric form:
    unit segment parameterized by t ∈ [0,1]. -/
def StandardUnitSegment {n : ℕ} (ω x : AuditSpace n) : Set (AuditSpace n) :=
  {y | ∃ t ∈ Set.Icc (0 : ℝ) 1, y = x + t • ω}

def StandardIsKakeyaSet {n : ℕ} (F : Set (AuditSpace n)) : Prop :=
  ∀ ω : AuditSpace n, ‖ω‖ = 1 → ∃ x, StandardUnitSegment ω x ⊆ F

/-- A [0,1]-based unit segment can be re-centered without changing its points. -/
lemma standard_to_oai {n : ℕ} {F : Set (AuditSpace n)}
    (h : StandardIsKakeyaSet F) : OAIIsKakeyaSet F := by
  intro ω hω
  rcases h ω hω with ⟨x, hx⟩
  refine ⟨x + (1 / 2 : ℝ) • ω, ?_⟩
  intro y hy
  change ∃ t ∈ Set.Icc (- (1 / 2 : ℝ)) (1 / 2),
      y = (x + (1 / 2 : ℝ) • ω) + t • ω at hy
  rcases hy with ⟨t, ht, rfl⟩
  apply hx
  change ∃ s ∈ Set.Icc (0 : ℝ) 1,
      (x + (1 / 2 : ℝ) • ω) + t • ω = x + s • ω
  refine ⟨t + (1 / 2 : ℝ), ?_, ?_⟩
  · constructor <;> linarith [ht.1, ht.2]
  · module

/-- The OpenAI comparator's Kakeya theorem, assumed as the antecedent to audit. -/
theorem oai_assumed :
    ∀ n : ℕ, 2 ≤ n → ∀ F : Set (AuditSpace n),
      OAIIsKakeyaSet F → dimH F = n := by
  sorry

/-- Standard [0,1]-segment formulation derived only through the explicit
    re-centering bridge above. This proof is the ProofAudit target. -/
theorem standard_from_oai :
    ∀ n : ℕ, 2 ≤ n → ∀ F : Set (AuditSpace n),
      StandardIsKakeyaSet F → dimH F = n := by
  intro n hn F hF
  exact oai_assumed n hn F (standard_to_oai hF)
