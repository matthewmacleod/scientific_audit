import OAI.ModelTheory.Categoricity.Main

namespace ScientificAudit
namespace E15B

open Cardinal Ordinal Order

universe u
noncomputable section

theorem selected_main_implies_prescribed_transfer_failure
    (hCH : OAI.CHObstruction.CH.{u}) :
    ∃ (L : ℕ → Type), Countable (Σ n, L n) ∧
    ∃ K : OAI.CHObstruction.ClassData.{u} L,
      K.IsAEC ∧
      K.HasLSNumber ℵ₀ ∧
      OAI.CHObstruction.hanf (ℵ₀ : Cardinal.{u}) <
        succ OAI.CHObstruction.tailThreshold ∧
      K.Categorical (succ OAI.CHObstruction.tailThreshold) ∧
      ¬ K.Categorical
        (OAI.CHObstruction.hanf (ℵ₀ : Cardinal.{u})) := by

  obtain ⟨L, hL, K, hK, hLS, he, ht, hc⟩ :=
    OAI.CHObstruction.main hCH

  refine ⟨L, hL, K, hK, hLS, ?_, hc _ (le_succ _), ?_⟩

  · rw [← he]
    exact
      OAI.CHObstruction.endpoint_lt_tailThreshold.trans
        (lt_succ _)

  · rw [← he]
    obtain ⟨M, N, hm, hn, hmc, hnc, hne⟩ := ht
    exact fun h => hne (h.2 M N hm hn hmc hnc)

#print axioms ScientificAudit.E15B.selected_main_implies_prescribed_transfer_failure

end
end E15B
end ScientificAudit
