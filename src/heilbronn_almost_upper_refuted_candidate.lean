import Mathlib

namespace HeilbronnAsymptotic

def EventualAlmostUpperBound
    (epsilon : ℝ)
    (Valid : ℕ → ℝ → Prop) : Prop :=
  ∃ C : ℝ,
    0 < C ∧
      ∃ n0 : ℕ,
        ∀ n : ℕ,
          n0 ≤ n →
            3 ≤ n →
              ∀ a : ℝ,
                Valid n a →
                  a ≤
                    C *
                      Real.rpow
                        (n : ℝ)
                        (-2 + epsilon)

opaque delta : ℝ
opaque Valid : ℕ → ℝ → Prop

theorem heilbronn_almost_upper_refuted_candidate :
    0 < delta / 2 ∧
      ¬ EventualAlmostUpperBound
          (delta / 2)
          Valid := by
  sorry

end HeilbronnAsymptotic
