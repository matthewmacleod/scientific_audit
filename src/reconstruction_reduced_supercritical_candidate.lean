import Mathlib

namespace OAI
namespace ThreeStateReduced

def Admissible (lam : ℝ) : Prop :=
  -(1 / 2 : ℝ) ≤ lam ∧ lam ≤ 1

/-- Fixed abstraction of OpenAI's regular-tree advantage sequence.
    Its internal probability construction is irrelevant to the
    logical-strength comparison in E4-B2. -/
opaque regularAdvantage
    (b : ℕ)
    (lam : ℝ)
    (h : Admissible lam) :
    ℕ → ℝ

/-- OpenAI's actual reconstruction semantics. -/
def Reconstructs (a : ℕ → ℝ) : Prop :=
  ∃ L : ℝ,
    0 < L ∧
      Filter.Tendsto a Filter.atTop (nhds L)

/-- OpenAI's selected supercritical direction. -/
theorem regular_supercritical
    (b : ℕ)
    (hb : 2 ≤ b)
    (lam : ℝ)
    (h : Admissible lam)
    (hcrit : 1 < (b : ℝ) * lam ^ 2) :
    Reconstructs (regularAdvantage b lam h) := by
  sorry

end ThreeStateReduced
end OAI
