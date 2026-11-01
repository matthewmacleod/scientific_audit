import Mathlib

noncomputable section

namespace BorsukTraceZeroDimension

abbrev Matrix4 :=
  EuclideanSpace ℝ (Fin 4 × Fin 4)

abbrev Constraint7 :=
  EuclideanSpace ℝ (Fin 7)

/--
The seven independent linear constraints defining the direction space
of trace-one symmetric 4x4 matrices:

six symmetry equations and one trace-zero equation.
-/
def constraintVec (A : Matrix4) : Constraint7 :=
  WithLp.toLp 2 ![
    A (0, 1) - A (1, 0),
    A (0, 2) - A (2, 0),
    A (0, 3) - A (3, 0),
    A (1, 2) - A (2, 1),
    A (1, 3) - A (3, 1),
    A (2, 3) - A (3, 2),
    A (0, 0) + A (1, 1) + A (2, 2) + A (3, 3)
  ]

def constraints : Matrix4 →ₗ[ℝ] Constraint7 where
  toFun := constraintVec

  map_add' := by
    intro A B
    ext k
    fin_cases k <;>
      simp [constraintVec] <;>
      ring

  map_smul' := by
    intro c A
    ext k
    fin_cases k <;>
      simp [constraintVec] <;>
      ring


/-- Standard coordinate matrix unit in the ambient Euclidean matrix space. -/
def unit (i j : Fin 4) : Matrix4 :=
  WithLp.toLp 2 (Pi.single (i, j) (1 : ℝ))


/--
A right inverse for the seven-constraint map.

The first six coordinates are placed in one orientation of each
off-diagonal pair; the seventh coordinate is placed in A₀₀.
-/
def liftConstraints (y : Constraint7) : Matrix4 :=
    y 0 • unit 0 1
  + y 1 • unit 0 2
  + y 2 • unit 0 3
  + y 3 • unit 1 2
  + y 4 • unit 1 3
  + y 5 • unit 2 3
  + y 6 • unit 0 0


set_option maxHeartbeats 2000000 in
lemma constraints_lift (y : Constraint7) :
    constraints (liftConstraints y) = y := by
  ext k
  fin_cases k <;>
    simp [constraints, constraintVec, liftConstraints, unit]

theorem constraints_surjective :
    Function.Surjective constraints := by
  intro y
  exact ⟨liftConstraints y, constraints_lift y⟩


/--
The linear direction space of the affine trace-one symmetric slice.
-/
abbrev TraceZeroSymmetric :=
  ↥constraints.ker


/--
E6-C1: the symmetric trace-zero direction space has dimension 9.
-/
theorem traceZero_finrank :
    Module.finrank ℝ TraceZeroSymmetric = 9 := by

  have hRN :=
    LinearMap.finrank_range_add_finrank_ker constraints

  have hrange :
      constraints.range = ⊤ :=
    LinearMap.range_eq_top.mpr constraints_surjective

  rw [hrange] at hRN

  have hRN' :
      7 + Module.finrank ℝ TraceZeroSymmetric = 16 := by
    simpa [TraceZeroSymmetric, Matrix4, Constraint7] using hRN

  omega


/--
E6-C2: any finite-dimensional real inner-product space of dimension 9
has an orthonormal coordinate representation in Euclidean R^9.

`stdOrthonormalBasis` supplies the isometry; E6-C1 supplies the index
identification with Fin 9.
-/
noncomputable def traceZeroToR9 :
    TraceZeroSymmetric ≃ₗᵢ[ℝ]
      EuclideanSpace ℝ (Fin 9) :=
  ((stdOrthonormalBasis ℝ TraceZeroSymmetric).reindex
    (finCongr traceZero_finrank)).repr


theorem traceZero_isometric_to_R9 :
    Nonempty
      (TraceZeroSymmetric ≃ₗᵢ[ℝ]
        EuclideanSpace ℝ (Fin 9)) := by
  exact ⟨traceZeroToR9⟩



/-! ## E6-C3: trace-one affine slice -/

/--
The constraint vector corresponding to symmetry plus trace = 1.
-/
def traceOneTarget : Constraint7 :=
  WithLp.toLp 2 ![
    (0 : ℝ),
    0,
    0,
    0,
    0,
    0,
    1
  ]

/--
The trace-one symmetric affine slice, written using the seven
constraint coordinates from E6-C1.
-/
def TraceOneAffineSet : Set Matrix4 :=
  {A | constraints A = traceOneTarget}

abbrev TraceOneAffine :=
  ↥TraceOneAffineSet

/--
A fixed point in the affine slice.

Using `liftConstraints` avoids introducing any unnecessary matrix
algebra: by construction its first six symmetry constraints vanish
and its trace coordinate is one.
-/
def traceOneBasepoint : Matrix4 :=
  liftConstraints traceOneTarget

lemma constraints_traceOneBasepoint :
    constraints traceOneBasepoint = traceOneTarget := by
  exact constraints_lift traceOneTarget


/-!
Translation between the trace-one affine slice and its trace-zero
direction space.
-/

def toTraceZero
    (A : TraceOneAffine) :
    TraceZeroSymmetric := by
  refine ⟨A.1 - traceOneBasepoint, ?_⟩

  rw [LinearMap.mem_ker]

  change
    constraints (A.1 - traceOneBasepoint) = 0

  rw [map_sub, constraints_traceOneBasepoint]

  have hA :
      constraints A.1 = traceOneTarget := by
    exact A.2

  rw [hA]

  simp


def fromTraceZero
    (v : TraceZeroSymmetric) :
    TraceOneAffine := by
  refine ⟨v.1 + traceOneBasepoint, ?_⟩

  change
    constraints (v.1 + traceOneBasepoint) =
      traceOneTarget

  rw [map_add, constraints_traceOneBasepoint]

  have hv :
      constraints v.1 = 0 :=
    LinearMap.mem_ker.mp v.2

  rw [hv]

  simp


lemma toTraceZero_fromTraceZero
    (v : TraceZeroSymmetric) :
    toTraceZero (fromTraceZero v) = v := by
  apply Subtype.ext
  simp [toTraceZero, fromTraceZero]


lemma fromTraceZero_toTraceZero
    (A : TraceOneAffine) :
    fromTraceZero (toTraceZero A) = A := by
  apply Subtype.ext
  simp [toTraceZero, fromTraceZero]


lemma toTraceZero_isometry :
    Isometry toTraceZero := by
  rw [isometry_iff_dist_eq]
  intro A B

  change
    dist
        (A.1 - traceOneBasepoint)
        (B.1 - traceOneBasepoint)
      =
    dist A.1 B.1

  exact dist_sub_right A.1 B.1 traceOneBasepoint


/--
The affine trace-one slice is isometric to the trace-zero
direction space.
-/
noncomputable def traceOneToTraceZero :
    TraceOneAffine ≃ᵢ TraceZeroSymmetric :=
  IsometryEquiv.mk'
    toTraceZero
    fromTraceZero
    toTraceZero_fromTraceZero
    toTraceZero_isometry


/--
Compose the affine translation with E6-C2.

Thus the trace-one affine slice is genuinely isometric to ordinary
nine-dimensional Euclidean space.
-/
noncomputable def traceOneAffineToR9 :
    TraceOneAffine ≃ᵢ
      EuclideanSpace ℝ (Fin 9) :=
  traceOneToTraceZero.trans
    traceZeroToR9.toIsometryEquiv


/-! ## Identification with OpenAI's source-level definition -/

/--
The source-level definition used in `BorsukNine.lean`.
-/
def SourceTraceOneSymmetric : Set Matrix4 :=
  {A |
    (∀ i j : Fin 4,
      A (i, j) = A (j, i)) ∧
    ∑ i : Fin 4, A (i, i) = 1}


/--
The seven-coordinate affine description is exactly the ordinary
"trace-one symmetric matrix" description.
-/
theorem sourceTraceOneSymmetric_eq_affine :
    SourceTraceOneSymmetric =
      TraceOneAffineSet := by

  ext A
  constructor

  · rintro ⟨hsym, htrace⟩

    change constraints A = traceOneTarget

    have h01 : A (0, 1) = A (1, 0) :=
      hsym 0 1

    have h02 : A (0, 2) = A (2, 0) :=
      hsym 0 2

    have h03 : A (0, 3) = A (3, 0) :=
      hsym 0 3

    have h12 : A (1, 2) = A (2, 1) :=
      hsym 1 2

    have h13 : A (1, 3) = A (3, 1) :=
      hsym 1 3

    have h23 : A (2, 3) = A (3, 2) :=
      hsym 2 3

    ext k
    fin_cases k

    · simp [constraints, constraintVec, traceOneTarget, h01]

    · simp [constraints, constraintVec, traceOneTarget, h02]

    · simp [constraints, constraintVec, traceOneTarget, h03]

    · simp [constraints, constraintVec, traceOneTarget, h12]

    · simp [constraints, constraintVec, traceOneTarget, h13]

    · simp [constraints, constraintVec, traceOneTarget, h23]

    · simpa
        [constraints, constraintVec, traceOneTarget,
         Fin.sum_univ_succ, add_assoc]
        using htrace


  · intro h

    change constraints A = traceOneTarget at h

    have h0 :=
      congrArg (fun z : Constraint7 => z 0) h

    have h1 :=
      congrArg (fun z : Constraint7 => z 1) h

    have h2 :=
      congrArg (fun z : Constraint7 => z 2) h

    have h3 :=
      congrArg (fun z : Constraint7 => z 3) h

    have h4 :=
      congrArg (fun z : Constraint7 => z 4) h

    have h5 :=
      congrArg (fun z : Constraint7 => z 5) h

    have h6 :=
      congrArg (fun z : Constraint7 => z 6) h

    have h01 :
        A (0, 1) = A (1, 0) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h0
      linarith

    have h02 :
        A (0, 2) = A (2, 0) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h1
      linarith

    have h03 :
        A (0, 3) = A (3, 0) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h2
      linarith

    have h12 :
        A (1, 2) = A (2, 1) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h3
      linarith

    have h13 :
        A (1, 3) = A (3, 1) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h4
      linarith

    have h23 :
        A (2, 3) = A (3, 2) := by
      simp
        [constraints, constraintVec, traceOneTarget]
        at h5
      linarith

    have htraceExplicit :
        A (0, 0) +
        A (1, 1) +
        A (2, 2) +
        A (3, 3) = 1 := by
      simpa
        [constraints, constraintVec, traceOneTarget]
        using h6

    constructor

    · intro i j

      fin_cases i <;>
      fin_cases j <;>
      simp [h01, h02, h03, h12, h13, h23]

    · simpa [Fin.sum_univ_succ, add_assoc]
        using htraceExplicit


/-!
Consequently the source-level trace-one symmetric matrix space is
isometric to R^9.
-/

abbrev SourceTraceOne :=
  ↥SourceTraceOneSymmetric


def sourceToAffine
    (A : SourceTraceOne) :
    TraceOneAffine := by
  refine ⟨A.1, ?_⟩

  rw [← sourceTraceOneSymmetric_eq_affine]

  exact A.2


def affineToSource
    (A : TraceOneAffine) :
    SourceTraceOne := by
  refine ⟨A.1, ?_⟩

  rw [sourceTraceOneSymmetric_eq_affine]

  exact A.2


lemma sourceToAffine_affineToSource
    (A : TraceOneAffine) :
    sourceToAffine (affineToSource A) = A := by
  apply Subtype.ext
  rfl


lemma affineToSource_sourceToAffine
    (A : SourceTraceOne) :
    affineToSource (sourceToAffine A) = A := by
  apply Subtype.ext
  rfl


lemma sourceToAffine_isometry :
    Isometry sourceToAffine := by
  intro A B
  rfl


noncomputable def sourceTraceOneToAffine :
    SourceTraceOne ≃ᵢ TraceOneAffine :=
  IsometryEquiv.mk'
    sourceToAffine
    affineToSource
    sourceToAffine_affineToSource
    sourceToAffine_isometry


/--
E6-C3 final result:

OpenAI's source-level trace-one symmetric 4x4 matrix space is
isometric to Euclidean R^9.
-/
noncomputable def sourceTraceOneToR9 :
    SourceTraceOne ≃ᵢ
      EuclideanSpace ℝ (Fin 9) :=
  sourceTraceOneToAffine.trans
    traceOneAffineToR9


theorem source_traceOne_isometric_to_R9 :
    Nonempty
      (SourceTraceOne ≃ᵢ
        EuclideanSpace ℝ (Fin 9)) := by
  exact ⟨sourceTraceOneToR9⟩



/-! ## E6-D: transport OpenAI's projector witness into R^9 -/

abbrev R9 :=
  EuclideanSpace ℝ (Fin 9)

abbrev Vector4 :=
  EuclideanSpace ℝ (Fin 4)


/-! ### Generic Borsuk obstruction -/

def HasTenSmallCover {α : Type*}
    [MetricSpace α]
    (S : Set α)
    (r : ℝ) : Prop :=
  ∃ C : Fin 10 → Set α,
    (∀ i, C i ⊆ S) ∧
    S ⊆ ⋃ i, C i ∧
    ∀ i, Metric.diam (C i) < r


def BorsukObstruction {α : Type*}
    [MetricSpace α]
    (S : Set α)
    (r : ℝ) : Prop :=
  IsCompact S ∧
  Metric.diam S = r ∧
  ¬ HasTenSmallCover S r


/--
A small-diameter cover pushes forward through any isometry.
Surjectivity is not needed in this direction.
-/
lemma hasTenSmallCover_image_isometry
    {α β : Type*}
    [MetricSpace α]
    [MetricSpace β]
    {f : α → β}
    (hf : Isometry f)
    (S : Set α)
    (r : ℝ)
    (h : HasTenSmallCover S r) :
    HasTenSmallCover (f '' S) r := by

  rcases h with
    ⟨C, hsub, hcover, hdiam⟩

  refine ⟨fun i => f '' C i, ?_, ?_, ?_⟩

  · intro i
    exact Set.image_mono (hsub i)

  · intro y hy

    rcases hy with ⟨x, hx, rfl⟩

    have hxU := hcover hx

    simp only [Set.mem_iUnion] at hxU ⊢

    rcases hxU with ⟨i, hxi⟩

    exact ⟨i, ⟨x, hxi, rfl⟩⟩

  · intro i

    rw [hf.diam_image]

    exact hdiam i


lemma symm_image_image_eq
    {α β : Type*}
    [MetricSpace α]
    [MetricSpace β]
    (e : α ≃ᵢ β)
    (S : Set α) :
    e.symm '' (e '' S) = S := by

  apply Set.Subset.antisymm

  · rintro x ⟨y, ⟨z, hz, rfl⟩, hyx⟩

    have hzx : z = x := by
      simpa using hyx

    simpa [hzx] using hz

  · intro x hx

    exact
      ⟨e x,
        ⟨x, hx, rfl⟩,
        by simp⟩


lemma hasTenSmallCover_image_iff
    {α β : Type*}
    [MetricSpace α]
    [MetricSpace β]
    (e : α ≃ᵢ β)
    (S : Set α)
    (r : ℝ) :
    HasTenSmallCover (e '' S) r ↔
      HasTenSmallCover S r := by

  constructor

  · intro h

    have hp :=
      hasTenSmallCover_image_isometry
        e.symm.isometry
        (e '' S)
        r
        h

    rw [symm_image_image_eq e S] at hp

    exact hp

  · intro h

    exact
      hasTenSmallCover_image_isometry
        e.isometry
        S
        r
        h


/--
The complete Borsuk obstruction is invariant under an
isometric equivalence.
-/
theorem borsukObstruction_image_iff
    {α β : Type*}
    [MetricSpace α]
    [MetricSpace β]
    (e : α ≃ᵢ β)
    (S : Set α)
    (r : ℝ) :
    BorsukObstruction (e '' S) r ↔
      BorsukObstruction S r := by

  constructor

  · intro h

    rcases h with
      ⟨hcompact, hdiam, hncover⟩

    have hcompact' : IsCompact S := by
      have himage :=
        hcompact.image e.symm.continuous

      rw [symm_image_image_eq e S] at himage

      exact himage

    have hdiam' :
        Metric.diam S = r := by
      rw [← e.diam_image S]
      exact hdiam

    have hncover' :
        ¬ HasTenSmallCover S r := by
      intro hcover

      have himage :
          HasTenSmallCover (e '' S) r :=
        hasTenSmallCover_image_isometry
          e.isometry
          S
          r
          hcover

      exact hncover himage

    exact
      ⟨hcompact', hdiam', hncover'⟩

  · intro h

    rcases h with
      ⟨hcompact, hdiam, hncover⟩

    have hcompact' :
        IsCompact (e '' S) :=
      hcompact.image e.continuous

    have hdiam' :
        Metric.diam (e '' S) = r := by
      rw [e.diam_image]
      exact hdiam

    have hncover' :
        ¬ HasTenSmallCover (e '' S) r := by
      intro hcover

      have horiginal :
          HasTenSmallCover S r :=
        (hasTenSmallCover_image_iff e S r).mp hcover

      exact hncover horiginal

    exact
      ⟨hcompact', hdiam', hncover'⟩


/-! ### OpenAI's actual projector construction -/

def projector (u : Vector4) : Matrix4 :=
  WithLp.toLp 2
    (fun ij => u ij.1 * u ij.2)


def projectorSet : Set Matrix4 :=
  projector '' {u : Vector4 | ‖u‖ = 1}


/--
The projector witness, lifted from the ambient 16-dimensional
matrix space into the trace-one symmetric subtype.

The proof argument `hsub` is exactly the containment supplied by
OpenAI's theorem.
-/
def liftedProjectorSet :
    Set SourceTraceOne :=
  {A : SourceTraceOne |
    A.1 ∈ projectorSet}


/--
The coercion image of the lifted projector set is exactly the
original ambient projector set.
-/
lemma coe_liftedProjectorSet
    (hsub :
      projectorSet ⊆ SourceTraceOneSymmetric) :
    Subtype.val '' liftedProjectorSet =
      projectorSet := by

  simpa [liftedProjectorSet] using
    (Subtype.coe_image_of_subset hsub)


/--
OpenAI's ambient projector theorem induces exactly the same
Borsuk obstruction on the trace-one subtype.
-/
theorem ambient_projector_obstruction_lifts
    (hcompact :
      IsCompact projectorSet)
    (hsub :
      projectorSet ⊆ SourceTraceOneSymmetric)
    (hdiam :
      Metric.diam projectorSet =
        Real.sqrt 2)
    (hncover :
      ¬ HasTenSmallCover
        projectorSet
        (Real.sqrt 2)) :
    BorsukObstruction
      (liftedProjectorSet)
      (Real.sqrt 2) := by

  have hcoe :
      Subtype.val '' liftedProjectorSet =
        projectorSet :=
    coe_liftedProjectorSet hsub

  have hcompactLift :
      IsCompact (liftedProjectorSet) := by

    rw [Subtype.isCompact_iff]

    rw [hcoe]

    exact hcompact

  have hdiamCoe :=
    isometry_subtype_coe.diam_image
      (liftedProjectorSet)

  have hdiamLift :
      Metric.diam (liftedProjectorSet) =
        Real.sqrt 2 := by

    calc
      Metric.diam (liftedProjectorSet)
          =
        Metric.diam
          (Subtype.val ''
            liftedProjectorSet) := by
              exact hdiamCoe.symm

      _ = Metric.diam projectorSet := by
            rw [hcoe]

      _ = Real.sqrt 2 :=
            hdiam

  have hncoverLift :
      ¬ HasTenSmallCover
          (liftedProjectorSet)
          (Real.sqrt 2) := by

    intro hcover

    have himage :
        HasTenSmallCover
          (Subtype.val ''
            liftedProjectorSet)
          (Real.sqrt 2) :=

      hasTenSmallCover_image_isometry
        isometry_subtype_coe
        (liftedProjectorSet)
        (Real.sqrt 2)
        hcover

    rw [hcoe] at himage

    exact hncover himage

  exact
    ⟨hcompactLift,
      hdiamLift,
      hncoverLift⟩


/--
E6-D final bridge.

The substantive hypotheses are exactly the four pieces supplied by
OpenAI's Borsuk projector theorem.  The conclusion is an actual compact
Borsuk obstruction in ordinary Euclidean R^9.
-/
theorem projector_witness_gives_R9_counterexample
    (hcompact :
      IsCompact projectorSet)
    (hsub :
      projectorSet ⊆ SourceTraceOneSymmetric)
    (hdiam :
      Metric.diam projectorSet =
        Real.sqrt 2)
    (hncover :
      ¬ HasTenSmallCover
        projectorSet
        (Real.sqrt 2)) :
    ∃ S : Set R9,
      BorsukObstruction
        S
        (Real.sqrt 2) := by

  let S0 : Set SourceTraceOne :=
    liftedProjectorSet

  have hobs0 :
      BorsukObstruction
        S0
        (Real.sqrt 2) := by

    dsimp [S0]

    exact
      ambient_projector_obstruction_lifts
        hcompact
        hsub
        hdiam
        hncover

  let S9 : Set R9 :=
    sourceTraceOneToR9 '' S0

  refine ⟨S9, ?_⟩

  dsimp [S9]

  exact
    (borsukObstruction_image_iff
      sourceTraceOneToR9
      S0
      (Real.sqrt 2)).mpr
        hobs0

end BorsukTraceZeroDimension
