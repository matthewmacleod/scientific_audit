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


namespace MassActionFinalComposition

abbrev State (d : ℕ) :=
  Fin d → ℝ

opaque System (d : ℕ) : Type
opaque CompatibilityClass (d : ℕ) : Type

opaque ClassOf {d : ℕ} :
  System d → CompatibilityClass d → Prop

opaque InClass {d : ℕ} :
  CompatibilityClass d → State d → Prop

opaque IsGlobalForwardSolution {d : ℕ}
    (S : System d)
    (x0 : State d)
    (x : ℝ → State d) :
    Prop

opaque ForwardInvariant {d : ℕ}
    (S : System d)
    (K : Set (State d)) :
    Prop

def PositiveState {d : ℕ}
    (x : State d) : Prop :=
  ∀ i : Fin d, 0 < x i

/--
Background properties of genuine forward dynamics.

These are not the permanence conclusion itself.  They record the
regularity needed to pass from an eventual absorbing set to the
all-time, trajectory-specific bound used by the comparator.
-/
structure ForwardRegularity {d : ℕ}
    (S : System d) : Prop where

  continuousOn :
    ∀ (x0 : State d)
      (x : ℝ → State d),
      IsGlobalForwardSolution S x0 x →
        ContinuousOn x (Set.Ici 0)

  positive :
    ∀ (x0 : State d)
      (x : ℝ → State d),
      PositiveState x0 →
        IsGlobalForwardSolution S x0 x →
          ∀ t : ℝ,
            0 ≤ t →
              PositiveState (x t)

  forward_unique :
    ∀ (x0 : State d)
      (x y : ℝ → State d),
      IsGlobalForwardSolution S x0 x →
        IsGlobalForwardSolution S x0 y →
          ∀ t : ℝ,
            0 ≤ t →
              x t = y t

/--
Headline-style permanence.

For every compatibility class there is one common compact, convex,
forward-invariant positive absorbing set.  Every positive initial state
in that class admits a global forward solution, and every such solution
eventually enters the common set.
-/
def HeadlinePermanence {d : ℕ}
    (S : System d) : Prop :=
  ∀ C : CompatibilityClass d,
    ClassOf S C →
      ∃ K : Set (State d),
        IsCompact K ∧
        Convex ℝ K ∧
        (∀ y : State d,
          y ∈ K →
            PositiveState y) ∧
        ForwardInvariant S K ∧
        ∀ x0 : State d,
          PositiveState x0 →
            InClass C x0 →
              (∃ x : ℝ → State d,
                IsGlobalForwardSolution S x0 x) ∧
              ∀ x : ℝ → State d,
                IsGlobalForwardSolution S x0 x →
                  ∃ T : ℝ,
                    0 ≤ T ∧
                    ∀ t : ℝ,
                      T ≤ t →
                        x t ∈ K

/--
Reduced form of OpenAI's comparator conclusion.

For each positive initial state, one epsilon may depend on x0, but the
same epsilon bounds every global forward solution from that x0 at every
nonnegative time and for every species.
-/
def ComparatorStyleBound {d : ℕ}
    (S : System d) : Prop :=
  ∀ x0 : State d,
    PositiveState x0 →
      ∃ ε : ℝ,
        0 < ε ∧
        ε < 1 ∧
        (∃ x : ℝ → State d,
          IsGlobalForwardSolution S x0 x) ∧
        ∀ x : ℝ → State d,
          IsGlobalForwardSolution S x0 x →
            ∀ t : ℝ,
              0 ≤ t →
                ∀ i : Fin d,
                  ε ≤ x t i ∧
                  x t i ≤ ε⁻¹

/--
E5-F.

Under the ordinary forward regularity of the dynamics and the fact that
every positive state belongs to its compatibility class, headline-style
classwise permanence implies the OpenAI-style pointwise all-time bound.
-/
theorem headline_permanence_implies_comparator
    {d : ℕ}
    (hd : 0 < d)
    (S : System d)
    (hreg : ForwardRegularity S)
    (hclass :
      ∀ x0 : State d,
        PositiveState x0 →
          ∃ C : CompatibilityClass d,
            ClassOf S C ∧
              InClass C x0) :
    HeadlinePermanence S →
      ComparatorStyleBound S := by

  intro hperm x0 hx0

  rcases hclass x0 hx0 with
    ⟨C, hC, hxC⟩

  rcases hperm C hC with
    ⟨K, hKcompact, _hKconvex, hKpositive,
      _hKforward, habsorb⟩

  rcases habsorb x0 hx0 hxC with
    ⟨hexists, hall_absorb⟩

  rcases hexists with
    ⟨x, hxsol⟩

  rcases hall_absorb x hxsol with
    ⟨T, hT, hentry⟩

  /-
  E5-E2:
  compactness and positivity of the common absorbing set give one
  reciprocal box shared by the entire set and every species.
  -/
  obtain ⟨εK, hεK, hKbox⟩ :=
    MassActionCompactScalarBridge.compact_positive_state_set_has_reciprocal_box
        hd
        K
        hKcompact
        (by
          intro y hy i
          exact hKpositive y hy i)

  /-
  The finite transient x([0,T]) is itself compact.
  Forward continuity is all that is needed; nothing is assumed about
  the arbitrary negative-time part of the function.
  -/
  have hxcontIcc :
      ContinuousOn x (Set.Icc (0 : ℝ) T) := by
    exact
      (hreg.continuousOn x0 x hxsol).mono
        (by
          intro t ht
          exact ht.1)

  let K0 : Set (State d) :=
    x '' Set.Icc (0 : ℝ) T

  have hK0compact :
      IsCompact K0 := by
    dsimp [K0]
    exact
      isCompact_Icc.image_of_continuousOn
        hxcontIcc

  have hK0positive :
      ∀ y : State d,
        y ∈ K0 →
          ∀ i : Fin d,
            0 < y i := by
    intro y hy i
    rcases hy with ⟨t, ht, rfl⟩
    exact
      hreg.positive x0 x hx0 hxsol
        t ht.1 i

  /-
  Apply E5-E2 again to the compact transient image.  This gives a
  trajectory-specific reciprocal box for the finite initial segment.
  -/
  obtain ⟨ε0, hε0, hK0box⟩ :=
    MassActionCompactScalarBridge.compact_positive_state_set_has_reciprocal_box
        hd
        K0
        hK0compact
        hK0positive

  /-
  Choose one epsilon small enough for both the transient box and the
  eventual common absorbing-set box.
  -/
  let δ : ℝ :=
    min εK ε0

  have hδpos : 0 < δ := by
    dsimp [δ]
    exact lt_min hεK.1 hε0.1

  have hδlt : δ < 1 := by
    have hδ_le_K : δ ≤ εK := by
      dsimp [δ]
      exact min_le_left _ _
    exact lt_of_le_of_lt hδ_le_K hεK.2

  have hδ_le_K : δ ≤ εK := by
    dsimp [δ]
    exact min_le_left _ _

  have hδ_le_0 : δ ≤ ε0 := by
    dsimp [δ]
    exact min_le_right _ _

  have hKinv :
      εK⁻¹ ≤ δ⁻¹ := by
    rw [inv_le_inv₀ hεK.1 hδpos]
    exact hδ_le_K

  have h0inv :
      ε0⁻¹ ≤ δ⁻¹ := by
    rw [inv_le_inv₀ hε0.1 hδpos]
    exact hδ_le_0

  /-
  The chosen forward solution is bounded for all t >= 0:
  use the compact transient box before T and the common absorbing-set
  box from T onward.
  -/
  have hall_x :
      ∀ t : ℝ,
        0 ≤ t →
          ∀ i : Fin d,
            δ ≤ x t i ∧
            x t i ≤ δ⁻¹ := by
    intro t ht i

    rcases le_total t T with htT | hTt

    · have hmem0 :
          x t ∈ K0 := by
        exact ⟨t, ⟨ht, htT⟩, rfl⟩

      have hb0 :=
        hK0box (x t) hmem0 i

      change
        ε0 ≤ x t i ∧
        x t i ≤ ε0⁻¹
        at hb0

      constructor
      · exact hδ_le_0.trans hb0.1
      · exact hb0.2.trans h0inv

    · have hmemK :
          x t ∈ K :=
        hentry t hTt

      have hbK :=
        hKbox (x t) hmemK i

      change
        εK ≤ x t i ∧
        x t i ≤ εK⁻¹
        at hbK

      constructor
      · exact hδ_le_K.trans hbK.1
      · exact hbK.2.trans hKinv

  refine
    ⟨δ, hδpos, hδlt,
      ⟨x, hxsol⟩, ?_⟩

  /-
  OpenAI's comparator quantifies over every global forward solution.
  Forward uniqueness transfers the same δ from our chosen solution to
  any other solution with the same initial state.
  -/
  intro y hysol t ht i

  have hyx :
      y t = x t :=
    hreg.forward_unique
      x0 y x hysol hxsol t ht

  rw [hyx]

  exact hall_x t ht i

end MassActionFinalComposition
