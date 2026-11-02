import Mathlib

namespace HeilbronnScope

def EventuallyAllSizes (Good : ℕ → Prop) : Prop :=
  ∃ N : ℕ,
    ∀ n : ℕ,
      N ≤ n →
        Good n

opaque Good : ℕ → Prop

theorem heilbronn_eventual_all_ref :
    EventuallyAllSizes Good := by
  sorry

end HeilbronnScope
