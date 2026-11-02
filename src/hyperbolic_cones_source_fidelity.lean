import ComparatorChallenges.HyperbolicCones

namespace HyperbolicConesSourceFidelity

open OAI.Paper256

/--
A direct spectrahedral representation in the original ambient
coordinates is a PSD region of some linear matrix pencil.
-/
def HasDirectSpectrahedralRepresentation : Prop :=
  ∃ N : ℕ,
    0 < N ∧
      ∃ L : Ambient →ₗ[ℝ] Sym N,
        cone =
          {x | (L x : Mat N ℝ).PosSemidef}

/--
The exact negated representation statement appearing in the
pinned OpenAI comparator.
-/
def NoDirectSpectrahedralRepresentation : Prop :=
  ∀ (N : ℕ),
    0 < N →
      ∀ L : Ambient →ₗ[ℝ] Sym N,
        cone ≠
          {x | (L x : Mat N ℝ).PosSemidef}

/--
The final conjunct of OpenAI's pinned `main_result` is exactly the
absence of a direct spectrahedral representation.
-/
theorem pinned_main_result_has_no_direct_representation :
    NoDirectSpectrahedralRepresentation := by
  exact main_result.2.2.2.2.2

/--
Consequently the particular pinned cone is nonspectrahedral in
its original coordinates.
-/
theorem pinned_main_result_is_nonspectrahedral :
    ¬ HasDirectSpectrahedralRepresentation := by
  rintro ⟨N, hN, L, hL⟩

  exact
    pinned_main_result_has_no_direct_representation
      N hN L hL

end HyperbolicConesSourceFidelity
