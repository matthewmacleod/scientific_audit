import Mathlib

namespace ETHCountingToDecisionBridge

variable {Machine : Type}

variable
  (Counts3SATWithin :
    Machine → ℝ → Prop)

variable
  (Decides3SATWithin :
    Machine → ℝ → Prop)

variable
  (counting_implies_deciding :
    ∀ M : Machine,
      ∀ δ : ℝ,
        Counts3SATWithin M δ →
          Decides3SATWithin M δ)

include counting_implies_deciding

theorem exactCounting_implies_subexpDecision
    (h :
      ∀ δ : ℝ,
        0 < δ →
          ∃ M : Machine,
            Counts3SATWithin M δ) :
    ∀ δ : ℝ,
      0 < δ →
        ∃ M : Machine,
          Decides3SATWithin M δ := by

  intro δ hδ

  rcases h δ hδ with
    ⟨M, hM⟩

  exact
    ⟨M,
      counting_implies_deciding
        M
        δ
        hM⟩

end ETHCountingToDecisionBridge
