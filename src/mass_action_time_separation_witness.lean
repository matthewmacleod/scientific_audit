import Mathlib

namespace MassActionTimeSeparation

def BoundAtTime (t : ℝ) : Prop :=
  1 ≤ t

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

theorem eventual_statement_true :
    EventualStatement := by
  refine ⟨1, by norm_num, ?_⟩
  intro t ht
  exact ht

theorem all_time_statement_false :
    ¬ AllTimeStatement := by
  intro hall
  have h := hall 0 (by norm_num)
  change (1 : ℝ) ≤ 0 at h
  norm_num at h

theorem separation :
    EventualStatement ∧ ¬ AllTimeStatement := by
  exact ⟨eventual_statement_true, all_time_statement_false⟩

theorem reverse_implication_fails :
    ¬ (EventualStatement → AllTimeStatement) := by
  intro h
  exact all_time_statement_false
    (h eventual_statement_true)

end MassActionTimeSeparation
