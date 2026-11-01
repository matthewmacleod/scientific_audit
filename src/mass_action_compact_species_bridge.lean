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



/-! ## Finite-species lift -/

abbrev State (d : ℕ) :=
  Fin d → ℝ

def SpeciesBoxBound {d : ℕ}
    (ε : ℝ)
    (x : State d) : Prop :=
  ∀ i : Fin d,
    BoxBound ε (x i)

/--
A compact set of strictly positive finite-species concentration vectors
lies in one common reciprocal box.

This is the finite-dimensional geometric bridge from a compact subset
of the positive orthant to the epsilon-style bounds used by the
mass-action comparator.
-/
theorem compact_positive_state_set_has_reciprocal_box
    {d : ℕ}
    (hd : 0 < d)
    (K : Set (State d))
    (hK : IsCompact K)
    (hpos :
      ∀ x : State d,
        x ∈ K →
          ∀ i : Fin d,
            0 < x i) :
    ∃ ε : ℝ,
      GoodEpsilon ε ∧
        ∀ x : State d,
          x ∈ K →
            SpeciesBoxBound ε x := by

  classical

  /-
  Project K onto each species coordinate. Each coordinate image is
  compact and strictly positive, so E5-E1 supplies a reciprocal box
  for that coordinate.
  -/
  have hcoord :
      ∀ i : Fin d,
        ∃ εi : ℝ,
          GoodEpsilon εi ∧
            ∀ x : State d,
              x ∈ K →
                BoxBound εi (x i) := by
    intro i

    let Ki : Set ℝ :=
      (fun x : State d => x i) '' K

    have hKi : IsCompact Ki := by
      dsimp [Ki]
      exact hK.image (continuous_apply i)

    have hposKi :
        ∀ y : ℝ,
          y ∈ Ki →
            0 < y := by
      intro y hy
      rcases hy with ⟨x, hx, rfl⟩
      exact hpos x hx i

    obtain ⟨εi, hεi, hbox⟩ :=
      compact_positive_set_has_reciprocal_box
        Ki
        hKi
        hposKi

    refine ⟨εi, hεi, ?_⟩

    intro x hx

    exact hbox
      (x i)
      ⟨x, hx, rfl⟩

  choose εi hεi using hcoord

  /-
  Because the species set is finite and nonempty, choose the smallest
  coordinatewise epsilon.
  -/
  let epsilons : Finset ℝ :=
    Finset.univ.image εi

  have hepsilons : epsilons.Nonempty := by
    refine ⟨εi ⟨0, hd⟩, ?_⟩
    simp [epsilons]

  let ε : ℝ :=
    epsilons.min' hepsilons

  have hεmem : ε ∈ epsilons := by
    dsimp [ε]
    exact Finset.min'_mem epsilons hepsilons

  rcases Finset.mem_image.mp hεmem with
    ⟨i0, hi0, hεeq⟩

  have hεpos : 0 < ε := by
    rw [← hεeq]
    exact (hεi i0).1.1

  have hεlt : ε < 1 := by
    rw [← hεeq]
    exact (hεi i0).1.2

  refine ⟨ε, ⟨hεpos, hεlt⟩, ?_⟩

  intro x hx i

  have hε_le_i : ε ≤ εi i := by
    dsimp [ε]
    exact Finset.min'_le
      epsilons
      (εi i)
      (by
        simp [epsilons])

  have hi :
      BoxBound (εi i) (x i) :=
    (hεi i).2 x hx

  have hinv :
      (εi i)⁻¹ ≤ ε⁻¹ := by
    rw [inv_le_inv₀ (hεi i).1.1 hεpos]
    exact hε_le_i

  constructor
  · exact hε_le_i.trans hi.1
  · exact hi.2.trans hinv

end MassActionCompactScalarBridge
