import OAI.NumberTheory.SingleFold.Main
import Mathlib.Computability.Halting

namespace ScientificAudit
namespace E16C

open OAI.SingleFold
open Encodable Denumerable
open Nat.Partrec (Code)

noncomputable section

theorem main_implies_unique_witness_undecidability
    {p : (Fin 1 → ℕ) → Prop}
    (hre : REPred p)
    (hnot : ¬ ComputablePred p) :
    ∃ (m : ℕ), 1 ≤ m ∧
    ∃ P : MvPolynomial (Fin 1 ⊕ Fin m) ℤ,
      (∀ a, p a ↔ ∃ w, evalNat P a w = 0) ∧
      (∀ a w v,
        evalNat P a w = 0 →
        evalNat P a v = 0 →
        w = v) ∧
      ¬ ComputablePred (fun a => ∃ w, evalNat P a w = 0) := by

  let S : Set (Fin 1 → ℕ) := {a | p a}

  have hS : REPred (fun a => a ∈ S) := by
    simpa [S] using hre

  obtain ⟨m, hm, P, hRep⟩ :=
    OAI.SingleFold.main 1 (by simp) S hS

  refine ⟨m, hm, P, ?_, ?_, ?_⟩

  · intro a
    simpa [S] using (hRep a).1

  · intro a w v hw hv
    exact (hRep a).2 w v hw hv

  · intro hSolvable
    apply hnot
    exact hSolvable.of_eq (fun a => by
      simpa [S] using (hRep a).1.symm)


/-- Encode the halting problem in the single coordinate of a `Fin 1 -> Nat`
    parameter tuple.  The coordinate itself is interpreted as a Gödel number
    for a partial-recursive program. -/
def HaltingVec (a : Fin 1 → ℕ) : Prop :=
  (Nat.Partrec.Code.eval (ofNat Code (a 0)) 0).Dom

theorem haltingVec_re : REPred HaltingVec := by
  have hGet : Computable (fun a : Fin 1 → ℕ => a 0) := by
    exact
      Computable.fin_app.comp
        Computable.id
        (Computable.const (0 : Fin 1))

  have hCode :
      Computable (fun a : Fin 1 → ℕ => ofNat Code (a 0)) :=
    (Computable.ofNat Code).comp hGet

  have hEval :
      Partrec (fun a : Fin 1 → ℕ =>
        Nat.Partrec.Code.eval (ofNat Code (a 0)) 0) :=
    Nat.Partrec.Code.eval_part.comp
      hCode
      (Computable.const 0)

  change REPred (fun a : Fin 1 → ℕ =>
    ((ofNat Code (a 0)).eval 0).Dom)
  exact hEval.dom_re

theorem haltingVec_not_computable :
    ¬ ComputablePred HaltingVec := by
  intro h

  let lift : Code → (Fin 1 → ℕ) :=
    fun c _ => encode c

  have hLiftPrim : Primrec lift := by
    refine (Primrec.fin_curry).2 ?_
    change Primrec₂ (fun c : Code => fun _ : Fin 1 => encode c)
    exact
      Primrec₂.mk
        ((@Primrec.encode Code _).comp
          (Primrec.fst (α := Code) (β := Fin 1)))

  have hLift : Computable lift :=
    hLiftPrim.to_comp

  have hComp :
      ComputablePred (fun c : Code => HaltingVec (lift c)) := by
    rcases h with ⟨decH, hdec⟩
    letI : DecidablePred HaltingVec := decH

    have hdec' :
        Computable (fun c : Code =>
          decide (HaltingVec (lift c))) :=
      hdec.comp hLift

    exact hdec'.computablePred

  have hHalting :
      ComputablePred
        (fun c : Code => (Nat.Partrec.Code.eval c 0).Dom) := by
    exact hComp.of_eq (fun c => by
      simp [HaltingVec, lift])

  exact ComputablePred.halting_problem 0 hHalting

theorem halting_singlefold_instance :
    ∃ (m : ℕ), 1 ≤ m ∧
    ∃ P : MvPolynomial (Fin 1 ⊕ Fin m) ℤ,
      (∀ a, HaltingVec a ↔ ∃ w, evalNat P a w = 0) ∧
      (∀ a w v,
        evalNat P a w = 0 →
        evalNat P a v = 0 →
        w = v) ∧
      ¬ ComputablePred (fun a => ∃ w, evalNat P a w = 0) :=
  main_implies_unique_witness_undecidability
    haltingVec_re
    haltingVec_not_computable


/-- Specialize the parameter variables of the OpenAI polynomial, leaving
    only the witness variables free. -/
noncomputable def specialize {m : ℕ}
    (P : MvPolynomial (Fin 1 ⊕ Fin m) ℤ)
    (a : Fin 1 → ℕ) :
    MvPolynomial (Fin m) ℤ :=
  MvPolynomial.eval₂Hom
    MvPolynomial.C
    (Sum.elim
      (fun i => MvPolynomial.C (a i : ℤ))
      (fun j => MvPolynomial.X j))
    P

/-- Evaluate an ordinary witness-only polynomial at a natural tuple. -/
noncomputable def evalWitness {m : ℕ}
    (Q : MvPolynomial (Fin m) ℤ)
    (w : Fin m → ℕ) : ℤ :=
  MvPolynomial.eval (fun j => (w j : ℤ)) Q

/-- Specializing the parameter variables and then evaluating the remaining
    witness variables agrees exactly with OpenAI's `evalNat`. -/
theorem eval_specialize {m : ℕ}
    (P : MvPolynomial (Fin 1 ⊕ Fin m) ℤ)
    (a : Fin 1 → ℕ)
    (w : Fin m → ℕ) :
    evalWitness (specialize P a) w =
      OAI.SingleFold.evalNat P a w := by

  change
    (MvPolynomial.eval (fun j : Fin m => (w j : ℤ)))
      (MvPolynomial.eval₂
        (MvPolynomial.C : ℤ →+* MvPolynomial (Fin m) ℤ)
        (Sum.elim
          (fun i => MvPolynomial.C (a i : ℤ))
          (fun j => MvPolynomial.X j))
        P)
      =
    MvPolynomial.eval
      (Sum.elim
        (fun i => (a i : ℤ))
        (fun j => (w j : ℤ)))
      P

  rw [MvPolynomial.eval_eval₂]

  have hCoeff :
      (MvPolynomial.eval (fun j : Fin m => (w j : ℤ))).comp
        (MvPolynomial.C : ℤ →+* MvPolynomial (Fin m) ℤ)
        =
      RingHom.id ℤ := by
    ext z
    exact MvPolynomial.eval_C z

  rw [hCoeff, MvPolynomial.eval₂_id]

  have hVars :
      (fun s : Fin 1 ⊕ Fin m =>
        (MvPolynomial.eval (fun j : Fin m => (w j : ℤ)))
          (Sum.elim
            (fun i => MvPolynomial.C (a i : ℤ))
            (fun j => MvPolynomial.X j)
            s))
        =
      Sum.elim
        (fun i => (a i : ℤ))
        (fun j => (w j : ℤ)) := by
    funext s
    cases s with
    | inl i =>
        exact MvPolynomial.eval_C (a i : ℤ)
    | inr j =>
        exact MvPolynomial.eval_X j

  rw [hVars]

/-- The concrete halting reduction can therefore be expressed as a family
    of ordinary polynomial instances `Q_a(w)`, each having at most one
    natural solution. -/
theorem halting_specialized_polynomial_instances :
    ∃ (m : ℕ), 1 ≤ m ∧
    ∃ P : MvPolynomial (Fin 1 ⊕ Fin m) ℤ,
      (∀ a,
        HaltingVec a ↔
          ∃ w, evalWitness (specialize P a) w = 0) ∧
      (∀ a w v,
        evalWitness (specialize P a) w = 0 →
        evalWitness (specialize P a) v = 0 →
        w = v) ∧
      ¬ ComputablePred
        (fun a =>
          ∃ w, evalWitness (specialize P a) w = 0) := by

  obtain ⟨m, hm, P, hMem, hUnique, hNoncomp⟩ :=
    halting_singlefold_instance

  refine ⟨m, hm, P, ?_, ?_, ?_⟩

  · intro a
    simpa only [eval_specialize] using hMem a

  · intro a w v hw hv
    apply hUnique a w v
    · simpa only [eval_specialize] using hw
    · simpa only [eval_specialize] using hv

  · simpa only [eval_specialize] using hNoncomp

#print axioms ScientificAudit.E16C.halting_specialized_polynomial_instances


#print axioms ScientificAudit.E16C.main_implies_unique_witness_undecidability
#print axioms ScientificAudit.E16C.halting_singlefold_instance

end
end E16C
end ScientificAudit
