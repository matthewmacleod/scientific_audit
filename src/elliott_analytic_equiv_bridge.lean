import Mathlib

noncomputable section

open Filter

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

theorem elliott_analytic_equiv
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
        sInf (analyticWindowSqrtSet d N) ≤
          Real.sqrt (d N t) := by
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
