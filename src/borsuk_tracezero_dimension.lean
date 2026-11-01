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

end BorsukTraceZeroDimension
