import OAI.NumberTheory.PiExponent.Statement

namespace PiSourceStatementFidelity

open OAI PiExponent

def ComparatorStatement : Prop :=
  (∀ ν : ℝ, 2 < ν →
    ∃ Q : ℤ, 2 ≤ Q ∧
      ∀ p q : ℤ, Q ≤ q →
        (q : ℝ) ^ (-ν) ≤
          |Real.pi - (p : ℝ) / (q : ℝ)|) ∧
  sSup
    {ν : ℝ |
      0 < ν ∧
      Set.Infinite
        {r : ℚ |
          2 ≤ r.den ∧
          0 < |Real.pi - (r : ℝ)| ∧
          |Real.pi - (r : ℝ)| <
            (r.den : ℝ) ^ (-ν)}} =
    2

/--
The expanded comparator statement is definitionally identical to
the conjunction of OpenAI's named source predicates.
-/
theorem comparatorStatement_iff_named :
    ComparatorStatement ↔
      IntegerEventualLowerBound Real.pi ∧
      irrationalityExponent Real.pi = 2 := by
  rfl

end PiSourceStatementFidelity
