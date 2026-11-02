import Mathlib

namespace PiExponentComponentsBridge

def GoodRationalApproximations (x ν : ℝ) : Set ℚ :=
  {r |
    2 ≤ r.den ∧
    0 < |x - (r : ℝ)| ∧
    |x - (r : ℝ)| < (r.den : ℝ) ^ (-ν)}

def ApproximationExponents (x : ℝ) : Set ℝ :=
  {ν |
    0 < ν ∧
    (GoodRationalApproximations x ν).Infinite}

def EventualLowerBound (x : ℝ) : Prop :=
  ∀ ν : ℝ,
    2 < ν →
      ∃ Q : ℕ,
        2 ≤ Q ∧
          ∀ (p : ℤ) (q : ℕ),
            Q ≤ q →
              (q : ℝ) ^ (-ν) ≤
                |x - (p : ℝ) / (q : ℝ)|


/-!
A finite-denominator auxiliary lemma.

For fixed x and N, there are only finitely many rationals with
denominator at most N lying within distance 1 of x.
-/
theorem finite_rat_den_le_abs_sub_lt_one
    (x : ℝ)
    (N : ℕ) :
    {r : ℚ |
      r.den ≤ N ∧
      |x - (r : ℝ)| < 1}.Finite := by

  classical

  let f : ℚ → ℤ × ℕ :=
    fun r => (r.num, r.den)

  have hinj : Function.Injective f := by
    intro a b hab
    have hp := Prod.mk.inj hab
    rw [← Rat.num_div_den a,
        ← Rat.num_div_den b,
        hp.1,
        hp.2]

  let t : Set (ℤ × ℕ) :=
    ⋃ (q : ℕ) (_ : q ∈ Set.Icc 1 N),
      Set.Icc
          ⌈(x - 1) * q⌉
          ⌊(x + 1) * q⌋
        ×ˢ {q}

  have ht : t.Finite :=
    Set.Finite.biUnion
      (Set.finite_Icc _ _)
      fun q _ =>
        Set.Finite.prod
          (Set.finite_Icc _ _)
          (Set.finite_singleton _)

  have hsub :
      f ''
          {r : ℚ |
            r.den ≤ N ∧
            |x - (r : ℝ)| < 1}
        ⊆ t := by

    rintro _ ⟨r, ⟨hrN, hr⟩, rfl⟩

    have hrden :
        (0 : ℝ) < r.den :=
      Nat.cast_pos.mpr r.pos

    have hrlow :
        x - 1 < (r : ℝ) := by
      linarith [(abs_lt.mp hr).2]

    have hrhigh :
        (r : ℝ) < x + 1 := by
      linarith [(abs_lt.mp hr).1]

    have hnlow :
        (x - 1) * r.den ≤
          (r.num : ℝ) := by
      rw [Rat.cast_def] at hrlow
      exact
        ((lt_div_iff₀ hrden).mp hrlow).le

    have hnhigh :
        (r.num : ℝ) ≤
          (x + 1) * r.den := by
      rw [Rat.cast_def] at hrhigh
      exact
        ((div_lt_iff₀ hrden).mp hrhigh).le

    simp only [t, Set.mem_iUnion]

    refine
      ⟨r.den,
       ⟨r.pos, hrN⟩,
       ?_⟩

    exact
      ⟨⟨Int.ceil_le.mpr hnlow,
         Int.le_floor.mpr hnhigh⟩,
       rfl⟩

  exact
    (ht.subset hsub).of_finite_image
      hinj.injOn


/-! ## E7-C1 -/

/--
An eventual Diophantine lower bound at exponent ν > 2 implies
that only finitely many rational approximations are ν-good.
-/
theorem finite_goodRationalApproximations_of_eventualLowerBound
    {x ν : ℝ}
    (hx : EventualLowerBound x)
    (hν : 2 < ν) :
    (GoodRationalApproximations x ν).Finite := by

  obtain ⟨Q, hQ, hb⟩ :=
    hx ν hν

  apply
    (finite_rat_den_le_abs_sub_lt_one
      x Q).subset

  intro r hr

  have hltQ :
      r.den < Q := by

    by_contra h

    have hbound :=
      hb r.num r.den (by omega)

    rw [← Rat.cast_def] at hbound

    exact
      (not_lt_of_ge hbound)
        hr.2.2

  refine
    ⟨hltQ.le,
     hr.2.2.trans_le ?_⟩

  exact
    Real.rpow_le_one_of_one_le_of_nonpos
      (by exact_mod_cast r.pos)
      (by linarith)


/-! ## E7-C2 -/

/--
Every irrational real has approximation exponent 2.
-/
theorem two_mem_approximationExponents
    {x : ℝ}
    (hx : Irrational x) :
    (2 : ℝ) ∈
      ApproximationExponents x := by

  refine
    ⟨by norm_num, ?_⟩

  have hi :=
    Real.infinite_rat_abs_sub_lt_one_div_den_sq_of_irrational
      hx

  have hf :=
    finite_rat_den_le_abs_sub_lt_one
      x 1

  have hdiff :
      ({r : ℚ |
          |x - (r : ℝ)| <
            1 / (r.den : ℝ) ^ 2} \
        {r : ℚ |
          r.den ≤ 1 ∧
          |x - (r : ℝ)| < 1}).Infinite := by

    intro hfin

    apply hi

    apply
      (hfin.union hf).subset

    intro r hr

    by_cases hsmall :
        r.den ≤ 1 ∧
          |x - (r : ℝ)| < 1

    · exact Or.inr hsmall

    · exact Or.inl ⟨hr, hsmall⟩

  apply hdiff.mono

  intro r hr

  have hrden :
      1 ≤ (r.den : ℝ) := by
    exact_mod_cast r.pos

  have hrone :
      |x - (r : ℝ)| < 1 :=
    hr.1.trans_le
      (by
        simpa only [div_one] using
          one_div_le_one_div_of_le
            (by norm_num :
              (0 : ℝ) < 1)
            (by
              nlinarith :
                (1 : ℝ) ≤
                  (r.den : ℝ) ^ 2))

  have hr2 :
      2 ≤ r.den := by

    by_contra h

    exact
      hr.2
        ⟨by omega,
         hrone⟩

  refine
    ⟨hr2,
     abs_pos.mpr
       (sub_ne_zero.mpr
         (hx.ne_rat r)),
     ?_⟩

  simpa only
      [Real.rpow_neg
         (Nat.cast_nonneg r.den),
       Real.rpow_two,
       one_div]
    using hr.1

end PiExponentComponentsBridge
