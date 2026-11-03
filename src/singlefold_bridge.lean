import Mathlib

namespace SingleFoldAuditBridge

axiom Input : Type
axiom Witness : Type

axiom Member : Input → Prop
axiom Solves : Input → Witness → Prop

def RefStatement : Prop :=
  ∀ a : Input,
    (Member a ↔ ∃ w, Solves a w) ∧
    ∀ w v, Solves a w → Solves a v → w = v

def CandidateStatement : Prop :=
  ∀ a : Input,
    (Member a → ∃! w, Solves a w) ∧
    (¬ Member a → ¬ ∃ w, Solves a w)

theorem ref_implies_candidate :
    RefStatement → CandidateStatement := by
  intro hRef a
  rcases hRef a with ⟨hMem, hUnique⟩
  constructor

  · intro ha
    rcases hMem.mp ha with ⟨w, hw⟩
    refine ⟨w, hw, ?_⟩
    intro y hy
    exact hUnique y w hy hw

  · intro hna hex
    exact hna (hMem.mpr hex)

theorem candidate_implies_ref :
    CandidateStatement → RefStatement := by
  classical
  intro hCand a
  rcases hCand a with ⟨hExistsUnique, hNone⟩
  constructor

  · constructor
    · intro ha
      rcases hExistsUnique ha with ⟨w, hw, hUnique⟩
      exact ⟨w, hw⟩

    · intro hex
      by_contra hna
      exact (hNone hna) hex

  · intro w v hw hv
    by_cases ha : Member a
    · rcases hExistsUnique ha with ⟨u, hu, hUnique⟩
      have hwu : w = u := hUnique w hw
      have hvu : v = u := hUnique v hv
      exact hwu.trans hvu.symm

    · exact ((hNone ha) ⟨w, hw⟩).elim

theorem equivalent :
    RefStatement ↔ CandidateStatement :=
  ⟨ref_implies_candidate, candidate_implies_ref⟩

#print axioms SingleFoldAuditBridge.equivalent

end SingleFoldAuditBridge
