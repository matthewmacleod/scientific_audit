import Mathlib

def Admissible (lam : ℝ) : Prop :=
  -(1 / 2 : ℝ) ≤ lam ∧ lam ≤ 1

theorem reconstruction_supercritical_candidate
    (Reconstructs : ℕ → ℝ → Prop)
    (b : ℕ)
    (hb : 2 ≤ b)
    (lam : ℝ)
    (hlam : Admissible lam) :
    1 < (b : ℝ) * lam ^ 2 →
      Reconstructs b lam := by
  sorry
