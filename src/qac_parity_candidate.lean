import Mathlib

namespace QACParityAudit

axiom Circuit : ℕ → Type
axiom Input : ℕ → Type

axiom Admissible :
  ℕ → ℝ → (n : ℕ) → Circuit n → Prop

axiom Success :
  {n : ℕ} → Circuit n → Input n → ℝ

def CandidateStatement : Prop :=
  ∀ (d : ℕ) (c ε : ℝ),
    1 ≤ c →
    0 < ε →
    ε ≤ (1 : ℝ) / 2 →
    ∃ n₀ : ℕ,
      ∀ n ≥ n₀,
        ∀ C : Circuit n,
          Admissible d c n C →
            ¬ (∀ x : Input n,
              (1 : ℝ) / 2 + ε ≤ Success C x)

theorem qac_parity_candidate :
    CandidateStatement := by
  sorry

end QACParityAudit
