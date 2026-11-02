import Mathlib

namespace HeilbronnScopeSeparation

def EventuallyAllSizes (Good : ℕ → Prop) : Prop :=
  ∃ N : ℕ,
    ∀ n : ℕ,
      N ≤ n →
        Good n

def UnboundedSubsequence (Good : ℕ → Prop) : Prop :=
  ∃ n : ℕ → ℕ,
    Filter.Tendsto n Filter.atTop Filter.atTop ∧
      ∀ j : ℕ, Good (n j)

def GoodEven (n : ℕ) : Prop :=
  ∃ k : ℕ, n = 2 * k

theorem even_unboundedSubsequence :
    UnboundedSubsequence GoodEven := by

  refine ⟨fun j => 2 * j, ?_, ?_⟩

  · refine Filter.tendsto_atTop.2 ?_
    intro b

    filter_upwards
      [Filter.eventually_ge_atTop b]
      with j hj

    change b ≤ 2 * j

    calc
      b ≤ j := hj
      _ ≤ 2 * j := by omega

  · intro j
    exact ⟨j, rfl⟩


theorem even_not_eventuallyAllSizes :
    ¬ EventuallyAllSizes GoodEven := by

  rintro ⟨N, hN⟩

  have hodd :
      GoodEven (2 * N + 1) :=
    hN (2 * N + 1) (by omega)

  rcases hodd with ⟨k, hk⟩

  omega


theorem unboundedSubsequence_not_implies_eventuallyAllSizes :
    UnboundedSubsequence GoodEven ∧
      ¬ EventuallyAllSizes GoodEven :=
  ⟨even_unboundedSubsequence,
   even_not_eventuallyAllSizes⟩

end HeilbronnScopeSeparation
