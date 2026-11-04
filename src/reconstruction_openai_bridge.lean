import OAI.Probability.ThreeState.Main

namespace ScientificAudit
namespace E19C

open OAI.ThreeState

/--
The selected regular-tree formal strength:
reconstruction above the Kesten-Stigum threshold.
-/
def RegularSelectedStatement : Prop :=
  ∀ (b : ℕ) (hb : 2 ≤ b)
    (lam : ℝ) (h : Admissible lam),
    1 < (b : ℝ) * lam ^ 2 →
      Reconstructs (regularAdvantage b lam h)

/--
The selected Poisson-tree formal strength:
reconstruction above the Kesten-Stigum threshold.
-/
def PoissonSelectedStatement : Prop :=
  ∀ (d : ℝ) (hd : 1 < d)
    (lam : ℝ) (h : Admissible lam),
    1 < d * lam ^ 2 →
      Reconstructs (poissonAdvantage d hd lam h)

theorem actual_implementation_implies_regular_selected :
    RegularSelectedStatement := by
  intro b hb lam h hcrit
  exact OAI.ThreeState.regular_supercritical
    b hb lam h hcrit

theorem actual_implementation_implies_poisson_selected :
    PoissonSelectedStatement := by
  intro d hd lam h hcrit
  exact OAI.ThreeState.poisson_supercritical
    d hd lam h hcrit

/--
Bundle the two selected comparator-level claims together.
-/
def SelectedThreeStateStatement : Prop :=
  RegularSelectedStatement ∧
  PoissonSelectedStatement

theorem actual_implementation_implies_selected :
    SelectedThreeStateStatement := by
  exact ⟨
    actual_implementation_implies_regular_selected,
    actual_implementation_implies_poisson_selected
  ⟩

#print axioms OAI.ThreeState.regular_supercritical
#print axioms OAI.ThreeState.poisson_supercritical

#print axioms ScientificAudit.E19C.actual_implementation_implies_regular_selected
#print axioms ScientificAudit.E19C.actual_implementation_implies_poisson_selected
#print axioms ScientificAudit.E19C.actual_implementation_implies_selected

end E19C
end ScientificAudit
