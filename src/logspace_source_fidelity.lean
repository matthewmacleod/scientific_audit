import ComparatorChallenges.LogspaceEquality

namespace LogspaceSourceFidelity

open OAI.ExactDerandomization

/--
The exact pinned OpenAI comparator states equality of deterministic,
one-sided randomized, and bounded-error randomized logarithmic space.
-/
theorem pinned_comparator_is_class_equality :
    L = RL ∧
      RL = BPL := by
  exact exact_logarithmic_space_derandomization

end LogspaceSourceFidelity
