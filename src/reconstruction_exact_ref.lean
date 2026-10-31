import Mathlib

def Admissible (lam : ℝ) : Prop :=
  -(1 / 2 : ℝ) ≤ lam ∧ lam ≤ 1

theorem reconstruction_exact_ref
    (Reconstructs : ℕ → ℝ → Prop)
    (b : ℕ)
    (hb : 2 ≤ b)
    (lam : ℝ)
    (hlam : Admissible lam) :
    Reconstructs b lam ↔
      1 < (b : ℝ) * lam ^ 2 := by
  sorry
