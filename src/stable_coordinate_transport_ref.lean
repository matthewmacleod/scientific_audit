import Mathlib

namespace StableCoordinateTransport

axiom A : Type
axiom B : Type

axiom e : A ≃ B

axiom sourceA : A
axiom targetA : A

axiom sourceB : B
axiom targetB : B

theorem stable_coordinate_transport_ref :
    e sourceA = sourceB →
      e targetA = targetB →
        ∃ φ : A ≃ A,
          φ sourceA = targetA := by
  sorry

end StableCoordinateTransport
