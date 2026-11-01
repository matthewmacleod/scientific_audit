import Mathlib

namespace MassActionTransientBridge

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def BoxBound (ε y : ℝ) : Prop :=
  ε ≤ y ∧ y ≤ ε⁻¹

/--
A positive continuous trajectory that eventually remains in a reciprocal
box admits some trajectory-specific reciprocal box valid from time zero.

This is the finite-transient bridge missing from the opaque E5-D reduction.
-/
theorem positive_continuous_eventual_box_implies_all_time_box
    (x : ℝ → ℝ)
    (hxcont : Continuous x)
    (hxpos : ∀ t : ℝ, 0 ≤ t → 0 < x t)
    (ε T : ℝ)
    (hε : GoodEpsilon ε)
    (hT : 0 ≤ T)
    (hevent :
      ∀ t : ℝ,
        T ≤ t →
          BoxBound ε (x t)) :
    ∃ δ : ℝ,
      GoodEpsilon δ ∧
        ∀ t : ℝ,
          0 ≤ t →
            BoxBound δ (x t) := by

  have hIcc :
      (Set.Icc (0 : ℝ) T).Nonempty :=
    Set.nonempty_Icc.mpr hT

  obtain ⟨tmin, htmin, hmin⟩ :=
    isCompact_Icc.exists_isMinOn
      hIcc
      hxcont.continuousOn

  obtain ⟨tmax, htmax, hmax⟩ :=
    isCompact_Icc.exists_isMaxOn
      hIcc
      hxcont.continuousOn

  let m : ℝ := x tmin
  let M : ℝ := x tmax

  have hmpos : 0 < m := by
    dsimp [m]
    exact hxpos tmin htmin.1

  have hMpos : 0 < M := by
    dsimp [M]
    exact hxpos tmax htmax.1

  /-
  The extra upper-control term ensures that choosing δ small enough
  also gives M ≤ δ⁻¹.
  -/
  let u : ℝ := (M + 1)⁻¹

  have hupos : 0 < u := by
    dsimp [u]
    exact inv_pos.mpr (by linarith)

  let δ : ℝ := min ε (min m u)

  have hδpos : 0 < δ := by
    dsimp [δ]
    exact lt_min hε.1 (lt_min hmpos hupos)

  have hδ_le_ε : δ ≤ ε := by
    dsimp [δ]
    exact min_le_left _ _

  have hδ_le_m : δ ≤ m := by
    dsimp [δ]
    exact le_trans
      (min_le_right ε (min m u))
      (min_le_left m u)

  have hδ_le_u : δ ≤ u := by
    dsimp [δ]
    exact le_trans
      (min_le_right ε (min m u))
      (min_le_right m u)

  have hδlt : δ < 1 :=
    lt_of_le_of_lt hδ_le_ε hε.2

  refine ⟨δ, ⟨hδpos, hδlt⟩, ?_⟩

  intro t ht0

  rcases le_total t T with htT | hTt

  · -- Finite transient: 0 ≤ t ≤ T.
    have htmem : t ∈ Set.Icc (0 : ℝ) T :=
      ⟨ht0, htT⟩

    have hmt : m ≤ x t := by
      dsimp [m]
      exact hmin htmem

    have htM : x t ≤ M := by
      dsimp [M]
      exact hmax htmem

    have hM_le_uinv : M ≤ u⁻¹ := by
      dsimp [u]
      rw [inv_inv]
      linarith

    have huinv_le_δinv : u⁻¹ ≤ δ⁻¹ := by
      rw [inv_le_inv₀ hupos hδpos]
      exact hδ_le_u

    constructor
    · exact hδ_le_m.trans hmt
    · exact htM.trans (hM_le_uinv.trans huinv_le_δinv)

  · -- Eventual region: reuse the original common box.
    have hev := hevent t hTt

    have hεinv_le_δinv : ε⁻¹ ≤ δ⁻¹ := by
      rw [inv_le_inv₀ hε.1 hδpos]
      exact hδ_le_ε

    constructor
    · exact hδ_le_ε.trans hev.1
    · exact hev.2.trans hεinv_le_δinv

end MassActionTransientBridge
