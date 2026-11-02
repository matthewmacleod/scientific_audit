import Mathlib

namespace PiExponentDenominatorBridge

def EventualLowerBound (x : ℝ) : Prop :=
  ∀ ν : ℝ,
    2 < ν →
      ∃ Q : ℕ,
        2 ≤ Q ∧
          ∀ (p : ℤ) (q : ℕ),
            Q ≤ q →
              (q : ℝ) ^ (-ν) ≤
                |x - (p : ℝ) / (q : ℝ)|

def IntegerEventualLowerBound (x : ℝ) : Prop :=
  ∀ ν : ℝ,
    2 < ν →
      ∃ Q : ℤ,
        2 ≤ Q ∧
          ∀ (p q : ℤ),
            Q ≤ q →
              (q : ℝ) ^ (-ν) ≤
                |x - (p : ℝ) / (q : ℝ)|

theorem eventualLowerBound_iff_integer (x : ℝ) :
    EventualLowerBound x ↔
      IntegerEventualLowerBound x := by
  constructor

  · intro h ν hν

    rcases h ν hν with
      ⟨Q, hQ2, hbound⟩

    refine ⟨(Q : ℤ), ?_, ?_⟩

    · exact_mod_cast hQ2

    · intro p q hQq

      have h2Q :
          (2 : ℤ) ≤ (Q : ℤ) := by
        exact_mod_cast hQ2

      have hq_nonneg :
          (0 : ℤ) ≤ q := by
        omega

      let qn : ℕ := q.toNat

      have hqn_int :
          (qn : ℤ) = q := by
        dsimp [qn]
        exact Int.toNat_of_nonneg hq_nonneg

      have hQq' :
          (Q : ℤ) ≤ (qn : ℤ) := by
        simpa [hqn_int] using hQq

      have hQqn :
          Q ≤ qn := by
        exact_mod_cast hQq'

      have hb :=
        hbound p qn hQqn

      have hqn_real :
          (qn : ℝ) = (q : ℝ) := by
        exact_mod_cast hqn_int

      simpa [hqn_real] using hb

  · intro h ν hν

    rcases h ν hν with
      ⟨Q, hQ2, hbound⟩

    have hQ_nonneg :
        (0 : ℤ) ≤ Q := by
      omega

    let Qn : ℕ := Q.toNat

    have hQn_int :
        (Qn : ℤ) = Q := by
      dsimp [Qn]
      exact Int.toNat_of_nonneg hQ_nonneg

    refine ⟨Qn, ?_, ?_⟩

    · have h2Qn :
          (2 : ℤ) ≤ (Qn : ℤ) := by
        simpa [hQn_int] using hQ2

      exact_mod_cast h2Qn

    · intro p q hQnq

      have hQq :
          Q ≤ (q : ℤ) := by
        rw [← hQn_int]
        exact_mod_cast hQnq

      have hb :=
        hbound p (q : ℤ) hQq

      simpa using hb

end PiExponentDenominatorBridge
