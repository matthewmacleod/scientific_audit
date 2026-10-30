import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate

namespace ElliottDistanceCandidate

/-- Source-side prime range, transcribed from OpenAI's
    `OrdinaryTwoPointCorrelations.lean` at commit
    fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb. -/
def primesUpTo (N : ℕ) : Finset ℕ :=
  (Finset.range (N + 1)).filter Nat.Prime

/-- Source-side squared distance. -/
def squaredDistance (f g : ℕ → ℂ) (N : ℕ) : ℝ :=
  ∑ p ∈ primesUpTo N, (1 - (f p * conj (g p)).re) / (p : ℝ)

/-- Source-side character twist. -/
def characterTwist {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (n : ℕ) : ℂ :=
  χ (n : ZMod q) *
    Complex.exp (((t * Real.log (n : ℝ) : ℝ) : ℂ) * Complex.I)

/-- The same source-neutral normalization target used by the reference side. -/
def canonicalSquaredDistance (f : ℕ → ℂ) {q : ℕ}
    (χ : DirichletCharacter ℂ q) (t : ℝ) (N : ℕ) : ℝ :=
  ∑ p ∈ (Finset.Icc 2 N).filter Nat.Prime,
    (1 - (f p * conj (χ (p : ZMod q) *
      Complex.exp (((t * Real.log (p : ℝ) : ℝ) : ℂ) * Complex.I))).re) / (p : ℝ)

/-- E3-B candidate statement: the `OrdinaryTwoPointCorrelations` squared
    distance agrees with the same canonical representation. -/
theorem elliott_distance_candidate
    (f : ℕ → ℂ) {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (N : ℕ) :
    squaredDistance f (characterTwist χ t) N =
      canonicalSquaredDistance f χ t N := by
  sorry

end ElliottDistanceCandidate
