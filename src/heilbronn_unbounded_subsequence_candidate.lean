import Mathlib

namespace HeilbronnScope

def UnboundedSubsequence (Good : ℕ → Prop) : Prop :=
  ∃ n : ℕ → ℕ,
    Filter.Tendsto n Filter.atTop Filter.atTop ∧
      ∀ j : ℕ, Good (n j)

opaque Good : ℕ → Prop

theorem heilbronn_unbounded_subsequence_candidate :
    UnboundedSubsequence Good := by
  sorry

end HeilbronnScope
