import Mathlib

namespace ETHCrossFormalization

axiom Machine : Type
axiom Works : Machine → ℕ → Prop

theorem eth_uniform_machine_ref :
    ∃ M : Machine,
      ∀ k : ℕ,
        2 ≤ k →
          Works M k := by
  sorry

end ETHCrossFormalization
