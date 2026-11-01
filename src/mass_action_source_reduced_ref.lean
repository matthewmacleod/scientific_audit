import Mathlib

namespace MassActionSourceReduced

abbrev State (d : ℕ) :=
  Fin d → ℝ

opaque System (d : ℕ) : Type
opaque CompatibilityClass (d : ℕ) : Type

opaque AdmissibleSystem {d : ℕ} :
  System d → Prop

opaque ClassOf {d : ℕ} :
  System d → CompatibilityClass d → Prop

opaque InClass {d : ℕ} :
  CompatibilityClass d → State d → Prop

opaque IsGlobalForwardSolution {d : ℕ}
    (S : System d)
    (x0 : State d)
    (x : ℝ → State d) :
    Prop

def PositiveState {d : ℕ} (x : State d) : Prop :=
  ∀ i : Fin d, 0 < x i

def GoodEpsilon (ε : ℝ) : Prop :=
  0 < ε ∧ ε < 1

def BoxBound {d : ℕ}
    (ε : ℝ)
    (x : State d) : Prop :=
  ∀ i : Fin d,
    ε ≤ x i ∧ x i ≤ ε⁻¹

/-- Reduced headline-style classwise permanence.

    For each admissible system and compatibility class, one common epsilon
    works for every positive initial state in that class. Each global
    trajectory may have its own eventual entry time. -/
theorem classwise_uniform_eventual_ref :
    ∀ (d : ℕ), 0 < d →
      ∀ S : System d, AdmissibleSystem S →
        ∀ C : CompatibilityClass d, ClassOf S C →
          ∃ ε : ℝ,
            GoodEpsilon ε ∧
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
                                BoxBound ε (x t) := by
  sorry

end MassActionSourceReduced
