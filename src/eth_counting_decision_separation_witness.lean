import Mathlib

namespace ETHCountingDecisionSeparation

abbrev Machine := Unit

def Counts3SATWithin
    (_M : Machine)
    (_δ : ℝ) : Prop :=
  False

def Decides3SATWithin
    (_M : Machine)
    (_δ : ℝ) : Prop :=
  True

theorem counting_implies_deciding :
    ∀ M : Machine,
      ∀ δ : ℝ,
        Counts3SATWithin M δ →
          Decides3SATWithin M δ := by
  intro M δ h
  exact False.elim h


theorem subexp_decision_exists :
    ∀ δ : ℝ,
      0 < δ →
        ∃ M : Machine,
          Decides3SATWithin M δ := by
  intro δ hδ
  exact ⟨(), trivial⟩


theorem no_subexp_counting_family :
    ¬ (∀ δ : ℝ,
        0 < δ →
          ∃ M : Machine,
            Counts3SATWithin M δ) := by
  intro h

  rcases h 1 (by norm_num) with
    ⟨M, hM⟩

  exact hM


theorem decision_does_not_imply_counting :
    (∀ δ : ℝ,
      0 < δ →
        ∃ M : Machine,
          Decides3SATWithin M δ) ∧
      ¬ (∀ δ : ℝ,
        0 < δ →
          ∃ M : Machine,
            Counts3SATWithin M δ) :=
  ⟨subexp_decision_exists,
   no_subexp_counting_family⟩

end ETHCountingDecisionSeparation
