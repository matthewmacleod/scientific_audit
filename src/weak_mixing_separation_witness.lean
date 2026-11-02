import Mathlib

namespace WeakMixingSeparation

def Invariant {α : Type*}
    (T : α → α)
    (A : Set α) : Prop :=
  ∀ x, x ∈ A ↔ T x ∈ A

def Ergodic {α : Type*}
    (T : α → α) : Prop :=
  ∀ A : Set α,
    Invariant T A →
      A = ∅ ∨ A = Set.univ

def productMap {α : Type*}
    (T : α → α) :
    α × α → α × α :=
  fun p => (T p.1, T p.2)

def WeakMixing {α : Type*}
    (T : α → α) : Prop :=
  Ergodic (productMap T)

def flip : Bool → Bool
  | false => true
  | true => false


/--
The two-point flip is ergodic.
-/
theorem flip_ergodic :
    Ergodic flip := by
  intro A hA

  by_cases hf :
      false ∈ A

  · right

    apply Set.eq_univ_iff_forall.mpr
    intro x

    cases x with

    | false =>
        exact hf

    | true =>
        have ht :=
          (hA false).mp hf

        simpa [flip] using ht

  · left

    ext x
    constructor

    · intro hx

      cases x with

      | false =>
          simpa using hf hx

      | true =>
          have hfalse :=
            (hA true).mp hx

          have hcontra :
              False :=
            hf
              (by
                simpa [flip] using hfalse)

          simp at hcontra

    · intro hx
      simp at hx


/--
The product flip is not ergodic: the diagonal is a nontrivial
invariant subset.
-/
theorem flip_not_weakMixing :
    ¬ WeakMixing flip := by
  intro hwm

  let D : Set (Bool × Bool) :=
    {p | p.1 = p.2}

  have hDinv :
      Invariant (productMap flip) D := by
    intro p

    rcases p with ⟨a, b⟩

    cases a <;>
      cases b <;>
      simp [D, productMap, flip]

  have hdiag :
      (false, false) ∈ D := by
    simp [D]

  have hoff :
      (false, true) ∉ D := by
    simp [D]

  rcases hwm D hDinv with
    hEmpty | hUniv

  · rw [hEmpty] at hdiag
    simp at hdiag

  · have hmem :
        (false, true) ∈ D := by
      rw [hUniv]
      simp

    exact hoff hmem


theorem ergodic_not_implies_weakMixing :
    Ergodic flip ∧
      ¬ WeakMixing flip :=
  ⟨flip_ergodic,
   flip_not_weakMixing⟩

end WeakMixingSeparation
