import OAI.InformationTheory.QuantumCircuit.Main

namespace ScientificAudit
namespace E20C

open OAI.QAC

/--
Human-readable existential-bad-input form of the general QAC^0 parity
lower bound.
-/
def GeneralExistentialStatement : Prop :=
  ∀ (d : ℕ) (c ε : ℝ),
    1 ≤ c →
    0 < ε →
    ε ≤ (1 : ℝ) / 2 →
    ∃ n₀ : ℕ,
      ∀ n ≥ n₀,
        ∀ N : ℕ,
          n ≤ N →
          (N : ℝ) ≤ (n : ℝ) ^ c →
          ∀ layers : List (PhysicalLayer N),
            layers.length ≤ d →
            ∀ out : Fin N,
              ∃ x : Word n,
                successProbability
                    (physicalCircuitMatrix layers) out x
                  < (1 : ℝ) / 2 + ε

theorem actual_implementation_implies_general_existential :
    GeneralExistentialStatement := by
  intro d c ε hc hε hhalf

  obtain ⟨n₀, hMain⟩ :=
    OAI.QAC.parity_lower_bound d c ε hc hε hhalf

  refine ⟨n₀, ?_⟩
  intro n hn N hnN hsize layers hdepth out

  have hNotAll :=
    hMain n hn N hnN hsize layers hdepth out

  by_contra hNoBad

  apply hNotAll
  intro x

  by_contra hNotLe

  have hLt :
      successProbability
          (physicalCircuitMatrix layers) out x
        < (1 : ℝ) / 2 + ε :=
    lt_of_not_ge hNotLe

  exact hNoBad ⟨x, hLt⟩

/--
The ordinary polynomial-size 2/3 specialization exported by the actual
OpenAI implementation.
-/
def PolynomialTwoThirdsStatement : Prop :=
  ∀ (d k C : ℕ),
    0 < d →
    0 < k →
    0 < C →
    ∃ n₀ : ℕ,
      ∀ n ≥ n₀,
        ∀ N : ℕ,
          n ≤ N →
          N ≤ C * (n + 1) ^ k →
          ∀ layers : List (PhysicalLayer N),
            layers.length ≤ d →
            ∀ out : Fin N,
              ∃ x : Word n,
                successProbability
                    (physicalCircuitMatrix layers) out x
                  < (2 : ℝ) / 3

theorem actual_implementation_implies_two_thirds :
    PolynomialTwoThirdsStatement := by
  intro d k C hd hk hC
  exact OAI.QAC.parity_lower_bound_polynomial_size
    d k C hd hk hC

#print axioms OAI.QAC.parity_lower_bound
#print axioms OAI.QAC.parity_lower_bound_polynomial_size

#print axioms ScientificAudit.E20C.actual_implementation_implies_general_existential
#print axioms ScientificAudit.E20C.actual_implementation_implies_two_thirds

end E20C
end ScientificAudit
