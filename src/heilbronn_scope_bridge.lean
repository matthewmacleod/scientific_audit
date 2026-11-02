import Mathlib

namespace HeilbronnScopeBridge

def EventuallyAllSizes (Good : ℕ → Prop) : Prop :=
  ∃ N : ℕ,
    ∀ n : ℕ,
      N ≤ n →
        Good n

def UnboundedSubsequence (Good : ℕ → Prop) : Prop :=
  ∃ n : ℕ → ℕ,
    Filter.Tendsto n Filter.atTop Filter.atTop ∧
      ∀ j : ℕ, Good (n j)

theorem eventuallyAllSizes_implies_unboundedSubsequence
    {Good : ℕ → Prop} :
    EventuallyAllSizes Good →
      UnboundedSubsequence Good := by
  rintro ⟨N, hN⟩

  refine ⟨fun j => N + j, ?_, ?_⟩

  · refine Filter.tendsto_atTop.2 ?_
    intro b

    filter_upwards
      [Filter.eventually_ge_atTop b]
      with j hj

    omega

  · intro j

    exact hN (N + j) (by omega)

end HeilbronnScopeBridge
