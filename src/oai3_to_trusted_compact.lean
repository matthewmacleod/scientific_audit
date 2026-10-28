import Mathlib

open MeasureTheory
open scoped RealInnerProductSpace ENNReal

noncomputable section

abbrev AuditSpace3 := EuclideanSpace ℝ (Fin 3)

/-- Exact n=3 specialization of the geometric definitions in OpenAI's
    LocalSmoothing comparator. -/
def OAIUnitSegment3 (ω x : AuditSpace3) : Set AuditSpace3 :=
  {y | ∃ t ∈ Set.Icc (- (1 / 2 : ℝ)) (1 / 2), y = x + t • ω}

def OAIIsKakeyaSet3 (F : Set AuditSpace3) : Prop :=
  ∀ ω : AuditSpace3, ‖ω‖ = 1 → ∃ x, OAIUnitSegment3 ω x ⊆ F

/-- Exact logical shape of lean-eval's trusted Wang-Zahl Kakeya predicate,
    transcribed into this file: compactness plus [0,1]-parameterized unit
    segments in every norm-one direction. -/
def TrustedIsKakeya (K : Set AuditSpace3) : Prop :=
  IsCompact K ∧
    ∀ v : AuditSpace3, ‖v‖ = 1 →
      ∃ x : AuditSpace3, ∀ t : ℝ, t ∈ Set.Icc 0 1 → x + t • v ∈ K

lemma trusted_geometry_to_oai {K : Set AuditSpace3}
    (h : TrustedIsKakeya K) : OAIIsKakeyaSet3 K := by
  intro ω hω
  rcases h.2 ω hω with ⟨x, hx⟩
  refine ⟨x + (1 / 2 : ℝ) • ω, ?_⟩
  intro y hy
  change ∃ t ∈ Set.Icc (- (1 / 2 : ℝ)) (1 / 2),
      y = (x + (1 / 2 : ℝ) • ω) + t • ω at hy
  rcases hy with ⟨t, ht, rfl⟩
  have hs : t + (1 / 2 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by
    constructor <;> linarith [ht.1, ht.2]
  have hmem := hx (t + (1 / 2 : ℝ)) hs
  convert hmem using 1 <;> module

/-- The n=3 instance of OpenAI's comparator theorem, assumed for ProofAudit. -/
theorem oai3_assumed :
    ∀ F : Set AuditSpace3, OAIIsKakeyaSet3 F → dimH F = 3 := by
  sorry

/-- Exact trusted-reference conclusion. Compactness is intentionally not used
    by the OpenAI theorem: the OpenAI statement is stronger in this respect. -/
theorem trusted_wang_zahl_from_oai {K : Set AuditSpace3}
    (hK : TrustedIsKakeya K) : dimH K = 3 := by
  exact oai3_assumed K (trusted_geometry_to_oai hK)
