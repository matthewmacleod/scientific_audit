import Mathlib

noncomputable section
open scoped BigOperators ComplexConjugate


/-- Common Elliott summand.  The ProofAudit isolates only the finite
    prime-index-set representation. -/
def elliottSummand (f : ℕ → ℂ) {q : ℕ}
    (χ : DirichletCharacter ℂ q) (t : ℝ) (p : ℕ) : ℝ :=
  (1 - (f p * conj (χ (p : ZMod q) *
    Complex.exp (((t * Real.log (p : ℝ) : ℝ) : ℂ) * Complex.I))).re) / (p : ℝ)

/-- Reference representation from `OrdinaryElliott.lean`. -/
def refPrimeSum (f : ℕ → ℂ) {q : ℕ}
    (χ : DirichletCharacter ℂ q) (t : ℝ) (N : ℕ) : ℝ :=
  ∑ p ∈ (Finset.Icc 2 N).filter Nat.Prime,
    elliottSummand f χ t p

/-- Candidate representation from `OrdinaryTwoPointCorrelations.lean`. -/
def candidatePrimeSum (f : ℕ → ℂ) {q : ℕ}
    (χ : DirichletCharacter ℂ q) (t : ℝ) (N : ℕ) : ℝ :=
  ∑ p ∈ (Finset.range (N + 1)).filter Nat.Prime,
    elliottSummand f χ t p

/-- Neutral comparison target shared by the E3-B2 Eval fixtures. -/
def canonicalPrimeSum (f : ℕ → ℂ) {q : ℕ}
    (χ : DirichletCharacter ℂ q) (t : ℝ) (N : ℕ) : ℝ :=
  ∑ p ∈ (Finset.Icc 0 N).filter Nat.Prime,
    elliottSummand f χ t p

/-- Kernel-checked bridge: the two finite sets enumerate exactly the same primes. -/
lemma prime_range_eq (N : ℕ) :
    (Finset.Icc 2 N).filter Nat.Prime =
      (Finset.range (N + 1)).filter Nat.Prime := by
  ext p
  simp only [Finset.mem_filter, Finset.mem_Icc, Finset.mem_range]
  constructor
  · rintro ⟨⟨hp2, hpN⟩, hpPrime⟩
    exact ⟨Nat.lt_succ_of_le hpN, hpPrime⟩
  · rintro ⟨hpN, hpPrime⟩
    exact ⟨⟨hpPrime.two_le, Nat.le_of_lt_succ hpN⟩, hpPrime⟩

/-- E3-B2 candidate statement, assumed as the antecedent to audit. -/
theorem candidate_assumed
    (f : ℕ → ℂ) {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (N : ℕ) :
    candidatePrimeSum f χ t N = canonicalPrimeSum f χ t N := by
  sorry

/-- Reference statement derived only through the explicit prime-range bridge. -/
theorem reference_from_candidate
    (f : ℕ → ℂ) {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (N : ℕ) :
    refPrimeSum f χ t N = canonicalPrimeSum f χ t N := by
  have hsums : refPrimeSum f χ t N = candidatePrimeSum f χ t N := by
    simp only [refPrimeSum, candidatePrimeSum]
    rw [prime_range_eq N]
  calc
    refPrimeSum f χ t N = candidatePrimeSum f χ t N := hsums
    _ = canonicalPrimeSum f χ t N := candidate_assumed f χ t N

