import Mathlib

namespace ShelahCHScopeBridge

axiom Language : Type
axiom AEC : Language → Type

axiom CountableLanguage : Language → Prop
axiom IsAEC : {L : Language} → AEC L → Prop
axiom HasLS0 : {L : Language} → AEC L → Prop
axiom Categorical : {L : Language} → AEC L → Nat → Prop
axiom TwoModels : {L : Language} → AEC L → Nat → Prop

axiom CH : Prop

axiom hanf : Nat
axiom endpoint : Nat
axiom tailThreshold : Nat

def RefStatement : Prop :=
  CH →
    ∃ L : Language, CountableLanguage L ∧
    ∃ K : AEC L,
      IsAEC K ∧
      HasLS0 K ∧
      TwoModels K hanf ∧
      endpoint = hanf ∧
      ∀ μ, tailThreshold ≤ μ → Categorical K μ

def CandidateStatement : Prop :=
  CH →
    ∃ L : Language, CountableLanguage L ∧
    ∃ K : AEC L,
      IsAEC K ∧
      HasLS0 K ∧
      endpoint = hanf ∧
      TwoModels K endpoint ∧
      ∀ μ, tailThreshold ≤ μ → Categorical K μ

theorem ref_implies_candidate :
    RefStatement → CandidateStatement := by
  intro hRef hCH
  obtain ⟨L, hL, K, hAEC, hLS, hTwo, hEq, hTail⟩ := hRef hCH
  refine ⟨L, hL, K, hAEC, hLS, hEq, ?_, hTail⟩
  simpa [hEq] using hTwo

theorem candidate_implies_ref :
    CandidateStatement → RefStatement := by
  intro hCand hCH
  obtain ⟨L, hL, K, hAEC, hLS, hEq, hTwo, hTail⟩ := hCand hCH
  refine ⟨L, hL, K, hAEC, hLS, ?_, hEq, hTail⟩
  simpa [hEq] using hTwo

theorem equivalent :
    RefStatement ↔ CandidateStatement :=
  ⟨ref_implies_candidate, candidate_implies_ref⟩

#print axioms ShelahCHScopeBridge.equivalent

end ShelahCHScopeBridge
