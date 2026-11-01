import Mathlib

namespace MassActionCompactScalarBridge

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def BoxBound (ε x : ℝ) : Prop :=
  ε ≤ x ∧ x ≤ ε⁻¹

/--
A compact subset of the positive real line lies in some reciprocal box.

This is the scalar geometric bridge from "compact absorbing set in the
positive orthant" to the epsilon-style bounds used by the mass-action
comparator.
-/
theorem compact_positive_set_has_reciprocal_box
    (K : Set ℝ)
    (hK : IsCompact K)
    (hpos : ∀ x : ℝ, x ∈ K → 0 < x) :
    ∃ ε : ℝ,
      GoodEpsilon ε ∧
        ∀ x : ℝ,
          x ∈ K →
            BoxBound ε x := by

  have hid :
      ContinuousOn (fun x : ℝ => x) K :=
    continuous_id.continuousOn

  /-
  Compactness + strict positivity gives a uniform positive
  lower bound m on K.
  -/
  obtain ⟨m, hmpos, hm⟩ :=
    hK.exists_forall_le'
      hid
      (a := (0 : ℝ))
      (by
        intro x hx
        exact hpos x hx)

  /-
  Compactness also gives some finite upper bound M.
  -/
  rcases hK.bddAbove with ⟨M, hM⟩

  /-
  Replace M by a strictly positive upper bound U so that its
  reciprocal can safely be used in the epsilon construction.
  -/
  let U : ℝ := max M 0 + 1

  have hUpos : 0 < U := by
    dsimp [U]
    linarith [le_max_right M 0]

  have hupper :
      ∀ x : ℝ,
        x ∈ K →
          x ≤ U := by
    intro x hx
    have hxM : x ≤ M :=
      hM hx
    dsimp [U]
    have hMU : M ≤ max M 0 + 1 := by
      linarith [le_max_left M 0]
    exact hxM.trans hMU

  let u : ℝ := U⁻¹

  have hupos : 0 < u := by
    dsimp [u]
    exact inv_pos.mpr hUpos

  /-
  Choose epsilon below:
    * 1/2, to ensure epsilon < 1;
    * the positive lower bound m;
    * U^{-1}, to ensure U ≤ epsilon^{-1}.
  -/
  let ε : ℝ :=
    min (1 / 2 : ℝ) (min m u)

  have hεpos : 0 < ε := by
    dsimp [ε]
    exact lt_min (by norm_num) (lt_min hmpos hupos)

  have hεlt : ε < 1 := by
    have hεhalf : ε ≤ (1 / 2 : ℝ) := by
      dsimp [ε]
      exact min_le_left _ _
    linarith

  have hε_le_m : ε ≤ m := by
    dsimp [ε]
    exact le_trans
      (min_le_right (1 / 2 : ℝ) (min m u))
      (min_le_left m u)

  have hε_le_u : ε ≤ u := by
    dsimp [ε]
    exact le_trans
      (min_le_right (1 / 2 : ℝ) (min m u))
      (min_le_right m u)

  have huinv_le_εinv :
      u⁻¹ ≤ ε⁻¹ := by
    rw [inv_le_inv₀ hupos hεpos]
    exact hε_le_u

  refine ⟨ε, ⟨hεpos, hεlt⟩, ?_⟩

  intro x hx

  have hmx : m ≤ x :=
    hm x hx

  have hxU : x ≤ U :=
    hupper x hx

  constructor

  · exact hε_le_m.trans hmx

  · have hU_le_εinv : U ≤ ε⁻¹ := by
      have : u⁻¹ ≤ ε⁻¹ :=
        huinv_le_εinv
      simpa [u] using this

    exact hxU.trans hU_le_εinv

end MassActionCompactScalarBridge
