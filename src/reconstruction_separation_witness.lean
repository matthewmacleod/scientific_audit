import Mathlib

namespace ReconstructionSeparation

def Admissible (lam : ℝ) : Prop :=
  -(1 / 2 : ℝ) ≤ lam ∧ lam ≤ 1

/-- A concrete interpretation of the otherwise-hidden regular advantage.
    It reconstructs for every parameter choice. -/
def regularAdvantage
    (_b : ℕ)
    (lam : ℝ)
    (_h : Admissible lam) :
    ℕ → ℝ :=
  fun _ => 1

/-- OpenAI's reconstruction semantics. -/
def Reconstructs (a : ℕ → ℝ) : Prop :=
  ∃ L : ℝ,
    0 < L ∧
      Filter.Tendsto a Filter.atTop (nhds L)

lemma reconstructs_regularAdvantage
    (b : ℕ)
    (lam : ℝ)
    (h : Admissible lam) :
    Reconstructs (regularAdvantage b lam h) := by
  refine ⟨1, by norm_num, ?_⟩
  change Filter.Tendsto
    (fun _ : ℕ => (1 : ℝ))
    Filter.atTop
    (nhds 1)
  exact tendsto_const_nhds

def SupercriticalStatement : Prop :=
  ∀ (b : ℕ),
    2 ≤ b →
    ∀ (lam : ℝ),
      ∀ (h : Admissible lam),
        1 < (b : ℝ) * lam ^ 2 →
          Reconstructs (regularAdvantage b lam h)

def ExactThresholdStatement : Prop :=
  ∀ (b : ℕ),
    2 ≤ b →
    ∀ (lam : ℝ),
      ∀ (h : Admissible lam),
        Reconstructs (regularAdvantage b lam h) ↔
          1 < (b : ℝ) * lam ^ 2

/-- The weaker OpenAI-style supercritical statement is true
    in this concrete interpretation. -/
theorem supercritical_statement_true :
    SupercriticalStatement := by
  intro b hb lam h hcrit
  exact reconstructs_regularAdvantage b lam h

lemma admissible_zero : Admissible 0 := by
  constructor <;> norm_num

/-- The exact-threshold reference is false in the same interpretation. -/
theorem exact_threshold_statement_false :
    ¬ ExactThresholdStatement := by
  intro href

  have hiff :=
    href 2 (by norm_num) 0 admissible_zero

  have hrec :
      Reconstructs
        (regularAdvantage 2 0 admissible_zero) :=
    reconstructs_regularAdvantage 2 0 admissible_zero

  have hcrit :
      1 < (2 : ℝ) * (0 : ℝ) ^ 2 :=
    hiff.mp hrec

  norm_num at hcrit

/-- Explicit separation witness:
    the candidate holds while the reference fails. -/
theorem separation :
    SupercriticalStatement ∧
      ¬ ExactThresholdStatement := by
  exact ⟨
    supercritical_statement_true,
    exact_threshold_statement_false
  ⟩

/-- Consequently the candidate does not imply the reference
    in this concrete model. -/
theorem reverse_implication_fails :
    ¬ (SupercriticalStatement →
      ExactThresholdStatement) := by
  intro h
  exact exact_threshold_statement_false
    (h supercritical_statement_true)

end ReconstructionSeparation
