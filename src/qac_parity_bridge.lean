import Mathlib

namespace QACParityBridge

axiom Circuit : ℕ → Type
axiom Input : ℕ → Type

axiom Admissible :
  ℕ → ℝ → (n : ℕ) → Circuit n → Prop

axiom Success :
  {n : ℕ} → Circuit n → Input n → ℝ

def RefStatement : Prop :=
  ∀ (d : ℕ) (c ε : ℝ),
    1 ≤ c →
    0 < ε →
    ε ≤ (1 : ℝ) / 2 →
    ∃ n₀ : ℕ,
      ∀ n ≥ n₀,
        ∀ C : Circuit n,
          Admissible d c n C →
            ∃ x : Input n,
              Success C x < (1 : ℝ) / 2 + ε

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

theorem ref_implies_candidate :
    RefStatement → CandidateStatement := by
  intro hRef d c ε hc hε hhalf
  rcases hRef d c ε hc hε hhalf with ⟨n₀, hN⟩
  refine ⟨n₀, ?_⟩

  intro n hn C hAdm hAll

  rcases hN n hn C hAdm with ⟨x, hx⟩

  exact (not_le_of_gt hx) (hAll x)

theorem candidate_implies_ref :
    CandidateStatement → RefStatement := by
  intro hCand d c ε hc hε hhalf
  rcases hCand d c ε hc hε hhalf with ⟨n₀, hN⟩
  refine ⟨n₀, ?_⟩

  intro n hn C hAdm

  have hNotAll := hN n hn C hAdm

  by_contra hNoBad

  apply hNotAll
  intro x

  by_contra hNotLe

  have hLt :
      Success C x < (1 : ℝ) / 2 + ε :=
    lt_of_not_ge hNotLe

  exact hNoBad ⟨x, hLt⟩

theorem equivalent :
    RefStatement ↔ CandidateStatement :=
  ⟨ref_implies_candidate, candidate_implies_ref⟩

#print axioms QACParityBridge.ref_implies_candidate
#print axioms QACParityBridge.candidate_implies_ref
#print axioms QACParityBridge.equivalent

end QACParityBridge
