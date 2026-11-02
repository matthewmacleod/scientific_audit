import Mathlib

namespace ETHUniformitySeparation

abbrev Machine := ℕ

def Works (M k : ℕ) : Prop :=
  M = k

theorem per_k_machine :
    ∀ k : ℕ,
      2 ≤ k →
        ∃ M : Machine,
          Works M k := by
  intro k hk
  exact ⟨k, rfl⟩

theorem no_uniform_machine :
    ¬ (∃ M : Machine,
        ∀ k : ℕ,
          2 ≤ k →
            Works M k) := by
  rintro ⟨M, hM⟩

  have h2 : M = 2 := by
    exact hM 2 (by norm_num)

  have h3 : M = 3 := by
    exact hM 3 (by norm_num)

  have h23 : (2 : ℕ) = 3 := by
    calc
      2 = M := h2.symm
      _ = 3 := h3

  norm_num at h23

theorem per_k_not_implies_uniform :
    (∀ k : ℕ,
      2 ≤ k →
        ∃ M : Machine,
          Works M k) ∧
      ¬ (∃ M : Machine,
          ∀ k : ℕ,
            2 ≤ k →
              Works M k) :=
  ⟨per_k_machine,
   no_uniform_machine⟩

end ETHUniformitySeparation
