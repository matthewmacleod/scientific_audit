import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate

abbrev RefCoord := Fin 6
abbrev RefSpace := EuclideanSpace ℂ RefCoord
abbrev RefBasis := OrthonormalBasis RefCoord ℂ RefSpace

def RefIsMUBFamily {n : ℕ} (B : Fin n → RefBasis) : Prop :=
  ∀ r s, r ≠ s → ∀ i j,
    Complex.normSq (inner ℂ (B r i) (B s j)) = (1 : ℝ) / 6

def RefAttainable (n : ℕ) : Prop :=
  ∃ B : Fin n → RefBasis, RefIsMUBFamily B

-- Paper/headline claim: at most three MUBs in C^6.
theorem headline_at_most_three :
    ∀ n : ℕ, RefAttainable n → n ≤ 3 := by
  sorry
