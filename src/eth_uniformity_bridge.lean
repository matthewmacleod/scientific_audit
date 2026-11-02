import Mathlib

namespace ETHUniformityBridge

variable {Machine : Type}
variable (Works : Machine → ℕ → Prop)

theorem uniform_implies_per_k
    (h :
      ∃ M : Machine,
        ∀ k : ℕ,
          2 ≤ k →
            Works M k) :
    ∀ k : ℕ,
      2 ≤ k →
        ∃ M : Machine,
          Works M k := by
  rcases h with ⟨M, hM⟩
  intro k hk
  exact ⟨M, hM k hk⟩

end ETHUniformityBridge
