import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate
open Filter

namespace ElliottThresholdCandidate

/-- Transcribed from OpenAI's `OrdinaryTwoPointCorrelations.lean` at commit
    fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb. -/
def primesUpTo (N : ℕ) : Finset ℕ :=
  (Finset.range (N + 1)).filter Nat.Prime

def squaredDistance (f g : ℕ → ℂ) (N : ℕ) : ℝ :=
  ∑ p ∈ primesUpTo N, (1 - (f p * conj (g p)).re) / (p : ℝ)

def characterTwist {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (n : ℕ) : ℂ :=
  χ (n : ZMod q) *
    Complex.exp (((t * Real.log (n : ℝ) : ℝ) : ℂ) * Complex.I)

def UniformlyNonpretentious (f : ℕ → ℂ) : Prop :=
  ∀ (q : ℕ), 0 < q → ∀ (χ : DirichletCharacter ℂ q) (K : ℝ),
    ∀ᶠ N : ℕ in atTop, ∀ t : ℝ, |t| ≤ (N : ℝ) →
      K ≤ squaredDistance f (characterTwist χ t) N

/-- E3 candidate: OpenAI's eventual-threshold encoding. -/
theorem elliott_threshold_form (f : ℕ → ℂ) :
    UniformlyNonpretentious f := by
  sorry

end ElliottThresholdCandidate
