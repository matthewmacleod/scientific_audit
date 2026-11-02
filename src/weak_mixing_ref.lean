import Mathlib

namespace WeakMixingAudit

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

opaque T : Bool → Bool

theorem weak_mixing_ref :
    WeakMixing T := by
  sorry

end WeakMixingAudit
