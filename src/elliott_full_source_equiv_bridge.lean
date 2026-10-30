import Mathlib

noncomputable section

open scoped BigOperators ComplexConjugate
open Filter

namespace ElliottFullSourceBridge

namespace Ref

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
    Tendsto
      (fun N : ℕ =>
        sInf ((fun t : ℝ => distance f χ t (N : ℝ)) ''
          Set.Icc (-(N : ℝ)) (N : ℝ)))
      atTop atTop

end Ref

namespace Cand

def primesUpTo (N : ℕ) : Finset ℕ :=
  (Finset.range (N + 1)).filter Nat.Prime

def squaredDistance (f g : ℕ → ℂ) (N : ℕ) : ℝ :=
  ∑ p ∈ primesUpTo N,
    (1 - (f p * conj (g p)).re) / (p : ℝ)

def characterTwist {q : ℕ} (χ : DirichletCharacter ℂ q)
    (t : ℝ) (n : ℕ) : ℂ :=
  χ (n : ZMod q) *
    Complex.exp (((t * Real.log (n : ℝ) : ℝ) : ℂ) * Complex.I)

def UniformlyNonpretentious (f : ℕ → ℂ) : Prop :=
  ∀ (q : ℕ), 0 < q → ∀ (χ : DirichletCharacter ℂ q) (K : ℝ),
    ∀ᶠ N : ℕ in atTop,
      ∀ t : ℝ,
        |t| ≤ (N : ℝ) →
          K ≤ squaredDistance f (characterTwist χ t) N

end Cand


/-! ## Source-level representation bridges -/

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


lemma distanceSq_eq
    (f : ℕ → ℂ)
    {q : ℕ}
    (χ : DirichletCharacter ℂ q)
    (t : ℝ)
    (N : ℕ) :
    Ref.distanceSq f χ t (N : ℝ) =
      Cand.squaredDistance f (Cand.characterTwist χ t) N := by
  unfold Ref.distanceSq Cand.squaredDistance Cand.primesUpTo
    Cand.characterTwist
  simp only [Nat.floor_natCast]
  rw [prime_range_eq N]
  rfl


lemma distance_eq
    (f : ℕ → ℂ)
    {q : ℕ}
    (χ : DirichletCharacter ℂ q)
    (t : ℝ)
    (N : ℕ) :
    Ref.distance f χ t (N : ℝ) =
      Real.sqrt
        (Cand.squaredDistance f (Cand.characterTwist χ t) N) := by
  unfold Ref.distance
  rw [distanceSq_eq]


/-! ## Analytic bridge -/

def analyticWindowSqrtSet
    (d : ℕ → ℝ → ℝ)
    (N : ℕ) : Set ℝ :=
  (fun t : ℝ => Real.sqrt (d N t)) ''
    Set.Icc (-(N : ℝ)) (N : ℝ)


lemma analyticWindowSqrtSet_nonempty
    (d : ℕ → ℝ → ℝ)
    (N : ℕ) :
    (analyticWindowSqrtSet d N).Nonempty := by
  refine ⟨Real.sqrt (d N 0), ?_⟩
  refine ⟨0, ?_, rfl⟩
  constructor
  · exact neg_nonpos.mpr (Nat.cast_nonneg N)
  · exact Nat.cast_nonneg N


lemma analyticWindowSqrtSet_bddBelow
    (d : ℕ → ℝ → ℝ)
    (N : ℕ) :
    BddBelow (analyticWindowSqrtSet d N) := by
  refine ⟨0, ?_⟩
  rintro y ⟨t, ht, rfl⟩
  exact Real.sqrt_nonneg _


theorem analytic_equiv
    (d : ℕ → ℝ → ℝ) :
    Tendsto
        (fun N : ℕ =>
          sInf (analyticWindowSqrtSet d N))
        atTop atTop
      ↔
    ∀ K : ℝ,
      ∀ᶠ N : ℕ in atTop,
        ∀ t : ℝ,
          t ∈ Set.Icc (-(N : ℝ)) (N : ℝ) →
            K ≤ d N t := by
  constructor

  · intro href
    rw [Filter.tendsto_atTop] at href
    intro K

    have hEventually := href (max K 1)

    filter_upwards [hEventually] with N hN
    intro t ht

    have hmem :
        Real.sqrt (d N t) ∈ analyticWindowSqrtSet d N := by
      exact ⟨t, ht, rfl⟩

    have hsInf :
        sInf (analyticWindowSqrtSet d N) ≤ Real.sqrt (d N t) := by
      exact csInf_le
        (analyticWindowSqrtSet_bddBelow d N)
        hmem

    have hr_sqrt :
        max K 1 ≤ Real.sqrt (d N t) :=
      le_trans hN hsInf

    have hr_pos : 0 < max K 1 := by
      exact lt_of_lt_of_le zero_lt_one (le_max_right K 1)

    have hsqrt_pos : 0 < Real.sqrt (d N t) :=
      lt_of_lt_of_le hr_pos hr_sqrt

    have hd_pos : 0 < d N t :=
      (Real.sqrt_pos).mp hsqrt_pos

    have hd_nonneg : 0 ≤ d N t :=
      le_of_lt hd_pos

    have hr_nonneg : 0 ≤ max K 1 :=
      le_of_lt hr_pos

    have hsq :
        (max K 1) ^ 2 ≤ d N t :=
      (Real.le_sqrt hr_nonneg hd_nonneg).mp hr_sqrt

    have hK : K ≤ max K 1 :=
      le_max_left K 1

    have hr_one : 1 ≤ max K 1 :=
      le_max_right K 1

    have hr_sq :
        max K 1 ≤ (max K 1) ^ 2 := by
      nlinarith

    exact hK.trans (hr_sq.trans hsq)

  · intro hcand
    rw [Filter.tendsto_atTop]
    intro R

    have hEventually := hcand ((max R 0) ^ 2)

    filter_upwards [hEventually] with N hN

    apply le_csInf (analyticWindowSqrtSet_nonempty d N)

    rintro y ⟨t, ht, rfl⟩

    have hsq :
        (max R 0) ^ 2 ≤ d N t :=
      hN t ht

    have hr_nonneg : 0 ≤ max R 0 :=
      le_max_right R 0

    have hd_nonneg : 0 ≤ d N t := by
      exact (sq_nonneg (max R 0)).trans hsq

    have hr_sqrt :
        max R 0 ≤ Real.sqrt (d N t) :=
      (Real.le_sqrt hr_nonneg hd_nonneg).mpr hsq

    exact (le_max_left R 0).trans hr_sqrt


/-! ## Identification of the actual reference window -/

lemma referenceWindow_eq
    (f : ℕ → ℂ)
    {q : ℕ}
    (χ : DirichletCharacter ℂ q)
    (N : ℕ) :
    ((fun t : ℝ => Ref.distance f χ t (N : ℝ)) ''
      Set.Icc (-(N : ℝ)) (N : ℝ))
      =
    analyticWindowSqrtSet
      (fun M t =>
        Cand.squaredDistance f (Cand.characterTwist χ t) M)
      N := by
  ext y
  constructor
  · rintro ⟨t, ht, rfl⟩
    refine ⟨t, ht, ?_⟩
    exact (distance_eq f χ t N).symm
  · rintro ⟨t, ht, rfl⟩
    refine ⟨t, ht, ?_⟩
    exact distance_eq f χ t N


/-! ## Full source-level equivalence -/

theorem uniformlyNonpretentious_equiv
    (f : ℕ → ℂ) :
    Ref.UniformlyNonpretentious f ↔
      Cand.UniformlyNonpretentious f := by
  constructor

  · intro href q hq χ K

    have hrefq := href q hq χ

    have hanalytic :
        Tendsto
          (fun N : ℕ =>
            sInf
              (analyticWindowSqrtSet
                (fun M t =>
                  Cand.squaredDistance
                    f (Cand.characterTwist χ t) M)
                N))
          atTop atTop := by
      simpa only [referenceWindow_eq] using hrefq

    have hthreshold :=
      (analytic_equiv
        (fun M t =>
          Cand.squaredDistance
            f (Cand.characterTwist χ t) M)).mp hanalytic

    have hEventually := hthreshold K

    filter_upwards [hEventually] with N hN

    intro t ht

    apply hN t

    exact (abs_le.mp ht)


  · intro hcand q hq χ

    have hthreshold :
        ∀ K : ℝ,
          ∀ᶠ N : ℕ in atTop,
            ∀ t : ℝ,
              t ∈ Set.Icc (-(N : ℝ)) (N : ℝ) →
                K ≤
                  Cand.squaredDistance
                    f (Cand.characterTwist χ t) N := by
      intro K

      have hEventually := hcand q hq χ K

      filter_upwards [hEventually] with N hN

      intro t ht

      apply hN t

      exact abs_le.mpr ht

    have hanalytic :=
      (analytic_equiv
        (fun M t =>
          Cand.squaredDistance
            f (Cand.characterTwist χ t) M)).mpr hthreshold

    simpa only [referenceWindow_eq] using hanalytic

end ElliottFullSourceBridge
