import Mathlib

namespace HeilbronnAsymptotic

def PowerLowerSubsequence
    (delta : ℝ)
    (Valid : ℕ → ℝ → Prop) : Prop :=
  0 < delta ∧
    ∃ n : ℕ → ℕ,
      ∃ a : ℕ → ℝ,
        Filter.Tendsto n Filter.atTop Filter.atTop ∧
          ∀ j : ℕ,
            3 ≤ n j ∧
            Valid (n j) (a j) ∧
            Real.rpow (n j : ℝ) (-2 + delta) ≤
              a j

opaque delta : ℝ
opaque Valid : ℕ → ℝ → Prop

theorem heilbronn_power_subsequence_ref :
    PowerLowerSubsequence delta Valid := by
  sorry

end HeilbronnAsymptotic
