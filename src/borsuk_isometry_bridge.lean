import Mathlib

noncomputable section

namespace BorsukIsometryBridge

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

/-!
A small-diameter ten-set cover can be transported through
an isometric equivalence.
-/
lemma hasTenSmallCover_image
    {α β : Type*}
    [MetricSpace α]
    [MetricSpace β]
    (e : α ≃ᵢ β)
    (S : Set α)
    (r : ℝ)
    (h : HasTenSmallCover S r) :
    HasTenSmallCover (e '' S) r := by

  rcases h with
    ⟨C, hsub, hcover, hdiam⟩

  refine ⟨fun i => e '' C i, ?_, ?_, ?_⟩

  · intro i
    exact Set.image_mono (hsub i)

  · intro y hy

    rcases hy with ⟨x, hx, rfl⟩

    have hxU := hcover hx

    simp only [Set.mem_iUnion] at hxU ⊢

    rcases hxU with ⟨i, hxi⟩

    exact ⟨i, ⟨x, hxi, rfl⟩⟩

  · intro i

    rw [e.diam_image]

    exact hdiam i


/-!
Because e is an equivalence, the cover relationship goes
both ways.
-/
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
      hasTenSmallCover_image
        e.symm
        (e '' S)
        r
        h

    rw [symm_image_image_eq e S] at hp
    exact hp

  · intro h

    exact
      hasTenSmallCover_image
        e
        S
        r
        h


/-!
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
        hasTenSmallCover_image e S r hcover

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

end BorsukIsometryBridge
