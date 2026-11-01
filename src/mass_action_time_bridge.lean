import Mathlib

namespace MassActionTimeBridge

opaque BoundAtTime : ℝ → Prop

def EventualStatement : Prop :=
  ∃ T : ℝ,
    0 ≤ T ∧
      ∀ t : ℝ,
        T ≤ t →
          BoundAtTime t

def AllTimeStatement : Prop :=
  ∀ t : ℝ,
    0 ≤ t →
      BoundAtTime t

/-- A bound valid from time zero is necessarily an eventual bound:
    choose entry time T = 0. -/
theorem all_time_implies_eventual :
    AllTimeStatement → EventualStatement := by
  intro hall
  unfold AllTimeStatement at hall
  unfold EventualStatement
  refine ⟨0, le_rfl, ?_⟩
  intro t ht
  exact hall t ht

end MassActionTimeBridge
