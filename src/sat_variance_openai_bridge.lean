import OAI.Probability.SATVariance.Main

namespace ScientificAudit
namespace E18C

open OAI.RandomKSAT
open MeasureTheory ProbabilityTheory

/--
The portion of the selected formal theorem relevant to the current
k = 3 hitting-time variance audit.

It gives:
  * an O(n log n) upper bound;
  * an eventual positive linear lower bound.
-/
def SelectedK3Statement : Prop :=
  (∃ C : ℝ, 0 ≤ C ∧
    ∀ n : ℕ, 3 ≤ n →
      variance (H : Stream n 3 → ℝ) (streamLaw n 3)
        ≤ C * n * ell 3 n) ∧
  (∃ c : ℝ, 0 < c ∧
    ∃ N : ℕ, ∀ n : ℕ, N ≤ n → 3 ≤ n →
      c * n
        ≤ variance (H : Stream n 3 → ℝ) (streamLaw n 3))

/--
Same selected k = 3 statement with the logarithmic factor written
explicitly rather than through `ell`.
-/
def ExplicitK3Statement : Prop :=
  (∃ C : ℝ, 0 ≤ C ∧
    ∀ n : ℕ, 3 ≤ n →
      variance (H : Stream n 3 → ℝ) (streamLaw n 3)
        ≤ C * n * Real.log (Real.exp 1 * n)) ∧
  (∃ c : ℝ, 0 < c ∧
    ∃ N : ℕ, ∀ n : ℕ, N ≤ n → 3 ≤ n →
      c * n
        ≤ variance (H : Stream n 3 → ℝ) (streamLaw n 3))

theorem actual_implementation_implies_selected_k3 :
    SelectedK3Statement := by
  have h :=
    OAI.RandomKSAT.variance_main 3 (by norm_num)

  rcases h with ⟨hUpper, _hCappedUpper, hLower⟩
  rcases hLower with
    ⟨c, hc, hUncappedLower, _hCappedLower⟩

  exact ⟨hUpper, ⟨c, hc, hUncappedLower⟩⟩

theorem actual_implementation_implies_explicit_k3 :
    ExplicitK3Statement := by
  have h :
      SelectedK3Statement :=
    actual_implementation_implies_selected_k3

  rcases h with
    ⟨⟨C, hC, hUpper⟩,
     ⟨c, hc, N, hLower⟩⟩

  refine ⟨?_, ⟨c, hc, N, hLower⟩⟩
  refine ⟨C, hC, ?_⟩

  intro n hn

  have hBound := hUpper n hn

  simpa [ell] using hBound

#print axioms OAI.RandomKSAT.variance_main
#print axioms ScientificAudit.E18C.actual_implementation_implies_selected_k3
#print axioms ScientificAudit.E18C.actual_implementation_implies_explicit_k3

end E18C
end ScientificAudit
