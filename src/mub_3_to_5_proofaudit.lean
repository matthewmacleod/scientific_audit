import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate

abbrev Coord := Fin 6
abbrev Space := EuclideanSpace ℂ Coord
abbrev Basis := OrthonormalBasis Coord ℂ Space

def IsMUBFamily {n : ℕ} (B : Fin n → Basis) : Prop :=
  ∀ r s, r ≠ s → ∀ i j,
    Complex.normSq (inner ℂ (B r i) (B s j)) = (1 : ℝ) / 6

def Attainable (n : ℕ) : Prop :=
  ∃ B : Fin n → Basis, IsMUBFamily B

theorem headline_assumed :
    ∀ n : ℕ, Attainable n → n ≤ 3 := by
  sorry

theorem oai_weaker_from_headline :
    ∀ n : ℕ, Attainable n → n ≤ 5 := by
  intro n hn
  have h3 : n ≤ 3 := headline_assumed n hn
  omega
