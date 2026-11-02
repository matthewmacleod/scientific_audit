import Mathlib

namespace WeakMixingBridge

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

/--
For the nonempty Bool state space, ergodicity of the product
implies ergodicity of the original transformation.
-/
theorem weakMixing_implies_ergodic
    (T : Bool → Bool) :
    WeakMixing T →
      Ergodic T := by
  intro hwm A hA

  let B : Set (Bool × Bool) :=
    {p | p.1 ∈ A}

  have hBinv :
      Invariant (productMap T) B := by
    intro p
    change p.1 ∈ A ↔ T p.1 ∈ A
    exact hA p.1

  rcases hwm B hBinv with
    hBempty | hBuniv

  · left

    ext x
    constructor

    · intro hx

      have hp :
          (x, false) ∈ B := by
        exact hx

      rw [hBempty] at hp
      simp at hp

    · intro hx
      simp at hx

  · right

    apply Set.eq_univ_iff_forall.mpr
    intro x

    have hp :
        (x, false) ∈ B := by
      rw [hBuniv]
      simp

    exact hp

end WeakMixingBridge
