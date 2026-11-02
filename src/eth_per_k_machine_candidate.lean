import Mathlib

namespace ETHCrossFormalization

axiom Machine : Type
axiom Works : Machine → ℕ → Prop

theorem eth_per_k_machine_candidate :
    ∀ k : ℕ,
      2 ≤ k →
        ∃ M : Machine,
          Works M k := by
  sorry

end ETHCrossFormalization
