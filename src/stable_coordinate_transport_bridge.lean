import Mathlib

namespace StableCoordinateTransportBridge

axiom A : Type
axiom B : Type

axiom e : A ≃ B

axiom sourceA : A
axiom targetA : A

axiom sourceB : B
axiom targetB : B


def RefPresentation : Prop :=
  e sourceA = sourceB →
    e targetA = targetB →
      ∃ φ : A ≃ A,
        φ sourceA = targetA


def CandPresentation : Prop :=
  e sourceA = sourceB →
    e targetA = targetB →
      ∃ ψ : B ≃ B,
        ψ sourceB = targetB


/--
Existence of an automorphism taking source to target is invariant
under transport through an equivalence of the ambient types.
-/
theorem transport_presentations_iff :
    RefPresentation ↔
      CandPresentation := by

  constructor

  · intro href hs ht

    rcases href hs ht with
      ⟨φ, hφ⟩

    refine
      ⟨e.symm.trans (φ.trans e), ?_⟩

    change
      e (φ (e.symm sourceB)) =
        targetB

    rw [← hs,
        e.symm_apply_apply,
        hφ,
        ht]

  · intro hcand hs ht

    rcases hcand hs ht with
      ⟨ψ, hψ⟩

    refine
      ⟨e.trans (ψ.trans e.symm), ?_⟩

    change
      e.symm (ψ (e sourceA)) =
        targetA

    rw [hs,
        hψ,
        ← ht,
        e.symm_apply_apply]

end StableCoordinateTransportBridge
