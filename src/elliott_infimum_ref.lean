import Mathlib

noncomputable section
open scoped BigOperators
open Filter

namespace ElliottInfimumRef

/-- Transcribed from OpenAI's `OrdinaryElliott.lean` at commit
    fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb. -/
def distanceSq (f : ℕ → ℂ) {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t X : ℝ) : ℝ :=
  ∑ p ∈ (Finset.Icc 2 ⌊X⌋₊).filter Nat.Prime,
    (1 - (f p * star (χ (p : ZMod q) *
      Complex.exp ((t * Real.log (p : ℝ) : ℝ) * Complex.I))).re) / (p : ℝ)

def distance (f : ℕ → ℂ) {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t X : ℝ) : ℝ :=
  Real.sqrt (distanceSq f χ t X)

def UniformlyNonpretentious (f : ℕ → ℂ) : Prop :=
  ∀ (q : ℕ), 0 < q → ∀ χ : DirichletCharacter ℂ q,
    Tendsto (fun N : ℕ => sInf ((fun t : ℝ => distance f χ t (N : ℝ)) ''
      Set.Icc (-(N : ℝ)) (N : ℝ))) atTop atTop

/-- E3 reference: OpenAI's infimum/Tendsto encoding. -/
theorem elliott_infimum_form (f : ℕ → ℂ) :
    UniformlyNonpretentious f := by
  sorry

end ElliottInfimumRef
