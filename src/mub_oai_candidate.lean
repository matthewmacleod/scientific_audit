import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate

abbrev CandCoord := Fin 6
abbrev CandSpace := EuclideanSpace ℂ CandCoord
abbrev CandBasis := OrthonormalBasis CandCoord ℂ CandSpace

def CandIsMUBFamily {n : ℕ} (B : Fin n → CandBasis) : Prop :=
  ∀ r s, r ≠ s → ∀ i j,
    Complex.normSq (inner ℂ (B r i) (B s j)) = (1 : ℝ) / 6

def CandAttainable (n : ℕ) : Prop :=
  ∃ B : Fin n → CandBasis, CandIsMUBFamily B

-- What the OAI Lean family-bound conjunct actually proves.
theorem oai_at_most_five :
    ∀ n : ℕ, CandAttainable n → n ≤ 5 := by
  sorry
