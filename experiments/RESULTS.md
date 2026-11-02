# Scientific Audit Results

This file summarizes the principal findings from experiments E1-E14.

The individual experiment files remain authoritative for detailed setup, frozen priors,
Lean bridges, separation witnesses, raw SemantEq output, provenance analysis, and
source-fidelity checks.

## Reading the results

SemantEq verdicts are treated as claims about what the automated search established,
not as ground truth about the mathematical relationship.

- **ExactMatch**: the elaborated statements are identical.
- **EquivalentRestricted**: SemantEq proved both directions within its permitted search.
- **LikelyTooWeak**: SemantEq proved reference → candidate but not candidate → reference.
- **Inconclusive**: SemantEq did not establish either direction. This is epistemically
  neutral: independent Lean proofs show that `Inconclusive` can conceal equivalence,
  strict implication, or genuine incomparability.

Fidelity classifications distinguish a separate question: whether the selected formal
target preserves the scientific claim at the relevant level of strength.

- **Positive fidelity**: the selected formal target preserves the relevant advertised
  claim.
- **Partial fidelity**: the central claim is preserved, but stronger constructive,
  quantitative, or operational content is outside the selected target.
- **Scope/provenance mismatch**: the selected formal target corresponds to an earlier,
  weaker, or otherwise different claim than the current scientific headline.
- **Controlled relation**: the experiment isolates logical strength or representation
  behavior and should not itself be interpreted as an announcement/formalization
  mismatch.

Invalid fixtures and compiler/setup failures are excluded from the scientific results.

---

## Overview

| Experiment | Topic | SemantEq finding | Independent Lean / audit result | Fidelity | Main finding |
|---|---|---|---|---|---|
| **E1** | Kakeya | Bridge-focused positive case | Centered-segment and `[0,1]` encodings were bridged; the OpenAI $(n=3)$ result was connected to an independent compact formulation with ProofAudit checks | **Positive representation fidelity** | Geometrically different encodings can preserve the same theorem, but the representation bridge must be audited explicitly |
| **E2** | Mutually Unbiased Bases | `LikelyTooWeak` for the controlled $(\le 3)$ vs $(\le 5)$ comparison | Independent bridge confirms $(\le3\Rightarrow\le5)$; the weaker bound does not establish the stronger headline | **Controlled relation** | SemantEq correctly detects a deliberate weakening; OpenAI itself does not equate the two bounds |
| **E3** | Ordinary Elliott | Full source comparison: `Inconclusive`; local subcases ranged from `DefEq` and `EquivalentRestricted` to `Inconclusive` | Full independent source-level bridge proves the two OpenAI formulations equivalent | **Positive cross-formulation fidelity** | `Inconclusive` can conceal full equivalence; local bridges can compose into an equivalence beyond SemantEq's autonomous search |
| **E4** | Reconstruction threshold | `LikelyTooWeak` | Independent separation witness shows the candidate supercritical implication is strictly weaker than the exact threshold biconditional | **Controlled relation** | SemantEq correctly detects genuine theorem-strength loss |
| **E5** | Mass Action | Mixed: E5-A `LikelyTooWeak`; E5-B/C/D `Inconclusive` | Uniformity loss is real; temporal difference disappears under appropriate positive continuous dynamics; abstract combined forms can be incomparable; final composition proves headline permanence → comparator-style bound under explicit background dynamics | **Scope / provenance mismatch** | The important missing information is classwise uniformity. The selected Lean target corresponds to an earlier weaker companion result rather than the later uniform-permanence headline |
| **E6** | Borsuk dimension 9 | E6-A/B `Inconclusive` | Explicit existential bridge, isometry-invariance theorem, dimension-9 trace-one affine bridge, and final transport of OpenAI's projector witness into ordinary $(\mathbb R^9)$ all pass | **Positive fidelity** | OpenAI's matrix formulation genuinely yields the advertised Borsuk counterexample in dimension 9 |
| **E7** | Irrationality exponent of $(\pi)$ | E7-A `Inconclusive`; E7-B `ExactMatch`; E7-C `Inconclusive` | Natural/integer denominator forms are equivalent; named exponent and expanded `sSup` form are identical; eventual lower bound independently implies $(\mu(\pi)=2)$; pinned-source statement fidelity passes | **Positive statement fidelity** | The formal premise really entails the advertised exponent statement. This does not independently validate the deep analytic proof establishing that premise |
| **E8** | Weak mixing / triangular billiards | Reduced strength test: `Inconclusive` | Weak mixing strictly implies ergodicity; explicit Bool-flip witness separates the converse; pinned comparator states ordinary ergodicity | **Scope / provenance mismatch** | The current weak-mixing headline is stronger than the earlier ergodicity result selected for Lean |
| **E9** | Heilbronn triangle problem | E9-B and E9-C: `Inconclusive` | “All sufficiently large $(n)$” strictly implies an unbounded subsequence, not conversely; independent asymptotic bridge proves the power-improved subsequence refutes the weaker eventual upper bound; pinned-source check passes | **Scope / provenance mismatch** | The selected Lean target proves the construction only along an unbounded sequence of sizes, while the broader headline quantifies over every sufficiently large $(n)$ |
| **E10** | Stable Coordinate | E10-A `LikelyTooWeak`; E10-B `Inconclusive` | Explicit counterexample strictly implies conjecture falsity; stabilization presentations are equivalent by conjugation; pinned comparator preserves the explicit degree-five stable noncoordinate witness and fiber package | **Positive fidelity** | The formalization retains the specific counterexample and geometric information, not merely the weaker statement that the conjecture is false |
| **E11** | $(L=RL=BPL)$ | E11-A `EquivalentRestricted` | SemantEq autonomously proves that $(BPL\subseteq L)$ is equivalent to $(L=RL=BPL)$ given the standard inclusions; pinned comparator states the class equality | **Partial fidelity** | Core class-equality headline is faithfully represented. The stronger advertised effective compiler and explicit running-time bounds are not separately stated in the Comparator target |
| **E12** | Hyperbolicity cones | E12-B `Inconclusive` | Independent Lean proves no semidefinite lift → nonspectrahedral, but not conversely; pinned comparator proves only no direct spectrahedral representation | **Scope / headline mismatch** | The current no-spectrahedral-shadow headline is strictly stronger than the formalized nonspectrahedral result. The formalized witness is known to admit a semidefinite lift |
| **E13** | Riesz transform / BPLI | E13-A `LikelyTooWeak` | Uniform class-level BPLI constants strictly imply measure-dependent constants; pinned comparator preserves the stronger quantifier order $(\exists(\theta,M)\forall\mu)$ | **Positive fidelity** | The formalization retains the theorem's essential quantitative uniformity |
| **E14** | ETH cross-formalization | E14-A `LikelyTooWeak`; E14-C1 `Inconclusive` | Anthropic's uniform-machine statement is strictly stronger than OpenAI's per-$(k)$ statement; Anthropic's time rate is sharper; exact counting strictly implies SAT decision; independent `eth-bridge` build reproduces OpenAI claim → Anthropic `ETHIsFalse` with `R=0` sorry declarations | **Partial fidelity; core headline positive** | The core conclusion “ETH is false” is independently bridged across the two formalizations, while their constructive uniformity and quantitative theorem strengths differ |

---

## Fidelity summary

A useful first-order classification of the suite is:

| Classification | Experiments | Interpretation |
|---|---|---|
| **Positive fidelity / positive source equivalence** | E1, E3, E6, E7, E10, E13 | No material mismatch found at the audited level; the formal target preserves the relevant claim or representation |
| **Scope / provenance / headline mismatch** | E5, E8, E9, E12 | The selected formal target corresponds to an earlier, weaker, or otherwise different scientific claim |
| **Partial fidelity** | E11, E14 | The core headline is preserved, while stronger constructive or quantitative claims lie outside the selected target or differ between formalizations |
| **Controlled logical-strength experiments** | E2, E4 | Deliberate comparison cases used to test whether the auditor distinguishes stronger and weaker statements |

The most pronounced mismatch is **E12**. The current headline requires absence of
any finite semidefinite lift, while the pinned comparator proves only absence of a
direct spectrahedral representation in the original coordinates:

$$
\neg \mathrm{Lift}(C)
\Rightarrow
\neg \mathrm{Direct}(C),
$$

but

$$
\neg \mathrm{Direct}(C)
\nRightarrow
\neg \mathrm{Lift}(C).
$$

The distinction is not merely hypothetical: the cone selected for the earlier
nonspectrahedral result has an exact semidefinite lift.

---

## SemantEq findings

### Correct autonomous detections

SemantEq successfully recognized several nontrivial relationships.

- **E7-B:** named irrationality exponent vs expanded `sSup` form → `ExactMatch`.
- **E11-A:** core derandomization inclusion vs class-equality packaging →
  `EquivalentRestricted`.
- **E2, E4, E5-A, E10-A, E13-A, E14-A:** `LikelyTooWeak` correctly identified
  one-way theorem-strength loss.

These cases show that SemantEq is capable of more than syntax matching. It can
sometimes normalize statements, instantiate witnesses, reason structurally, and detect
strict weakening.

### `Inconclusive` can hide equivalence

Independent Lean proofs established equivalence after SemantEq returned
`Inconclusive` in cases including:

- **E3:** full Elliott source formulations.
- **E6-B:** Borsuk obstruction under isometric equivalence.
- **E7-A:** natural-number vs positive-integer denominator formulations.
- **E10-B:** automorphism presentations transported by conjugation.

These failures often require synthesis of a representation bridge rather than new
domain mathematics.

### `Inconclusive` can hide strict implication

Examples include:

- **E5-B:** all-time bounds imply eventual bounds by choosing \(T=0\).
- **E6-A:** a specific witness implies an existential witness.
- **E7-C:** eventual Diophantine lower bounds imply irrationality exponent \(2\).
- **E8-B:** weak mixing implies ergodicity.
- **E9-B:** eventual validity for all sizes implies an unbounded valid subsequence.
- **E9-C:** a power-improved subsequence refutes an eventual almost-\(n^{-2}\) upper bound.
- **E12-B:** no semidefinite lift implies no direct spectrahedral representation.
- **E14-C1:** exact counting implies SAT decision.

The difficulty ranges from elementary structural reasoning to substantive mathematics.

### `Inconclusive` can hide incomparability

**E5-C** supplies the clearest example. Two independent separation models show that
the reduced combined Mass Action statements imply neither one another.

Therefore:

$$
\boxed{\texttt{Inconclusive} \text{ is epistemically neutral.}}
$$

It should not be interpreted as non-equivalence, incomparability, or evidence against
either implication.

---

## Equivalence-difficulty taxonomy

The experiments suggest that semantic-equivalence difficulty is not one-dimensional.

### 1. Definitional identity

The two propositions are the same after elaboration or unfolding.

Example:

- E7-B: named irrationality exponent vs expanded `sSup` definition.

### 2. Structural logical transport

The relationship requires witness introduction, elimination, quantifier plumbing, or
simple propositional reasoning.

Examples:

- E6-A: specific witness → existential witness.
- E5-B: all-time → eventual by choosing \(T=0\).
- E9-B: eventual all-sizes statement → subsequence witness.

### 3. Representation transport

The mathematics is unchanged, but types, coordinate systems, casts, or canonical
encodings differ.

Examples:

- E7-A: \(\mathbb N\) vs positive-\(\mathbb Z\) denominators.
- E3-B2: equivalent prime-range encodings.
- E6-B/C: isometric transport and trace-one matrices → \(\mathbb R^9\).
- E10-B: conjugation of automorphisms through an equivalence.

### 4. Canonical mathematical bridges

A standard mathematical theorem is needed, but the transformation remains reusable
and conventional.

Examples:

- E3-C2: square-root/order normalization.
- geometric invariance of compactness, diameter, and covering properties.

### 5. Substantive mathematical implication

Recognizing the relationship requires actual domain mathematics.

Examples:

- E7-C: Diophantine finiteness, irrational approximation, and supremum reasoning.
- E9-C: real-power asymptotics along an unbounded subsequence.
- parts of E3 involving `sInf`.

### 6. Compositional difficulty

Local transformations may each be manageable while their composition exceeds the
automated search.

The full E3 Elliott comparison is the clearest example: independent Lean proves the
source formulations equivalent even though SemantEq cannot autonomously compose the
required bridges.

A central consequence is:

$$
\boxed{
\text{difficulty of discovering a relation}
\neq
\text{logical strength of the relation}.
}
$$

---

## Statement fidelity is not proof validity

Several experiments make a second distinction essential.

A semantic audit may establish that:

$$
\text{formal theorem}
\Rightarrow
\text{scientific headline}
$$

without independently validating the deep mathematical proof establishing the formal
theorem's premises.

E7 is the clearest example. The audit independently verifies that the eventual
Diophantine lower bound implies

$$
\mu(\pi)=2,
$$

but that does not by itself independently validate the breakthrough proof of the
eventual lower bound.

Accordingly, at least three audit targets should remain distinct:

1. **Statement fidelity:** does the formal target say what the scientific claim says?
2. **Semantic relation:** are alternative formal statements equivalent, stronger,
   weaker, or incomparable?
3. **Proof validity:** does the deep proof establishing the formal theorem survive
   independent scrutiny?

The present experiments focus primarily on the first two.

---

## Extensional existence versus effective construction

E11 exposes another important boundary.

Class equality

$$
L=RL=BPL
$$

is an extensional statement about which languages are decidable in each class.

An advertised **effective compiler** is stronger operational information: it requires a
uniform computable transformation from randomized machines to deterministic machines,
together with resource guarantees.

Classical logic can blur this distinction. A theorem of the form

$$
\forall M\,\exists D,\; Correct(M,D)
$$

does not by itself certify an executable compiler, even though choice can produce a
set-theoretic function selecting witnesses.

This distinction should therefore be tracked independently from ordinary propositional
equivalence.

---

## Cross-formalization findings

E14 shows that independent formalizations can agree on a central scientific conclusion
while choosing meaningfully different theorem boundaries.

Anthropic's ETH formalization is stronger in at least two audited respects:

1. one uniform machine is quantified before \(k\), rather than allowing a separate
   machine for each fixed \(k\);
2. the formalized quantitative rate has a single \(\log\log n\) factor rather than the
   squared factor in OpenAI's selected Lean target.

Nevertheless, the independently developed `eth-bridge` was reproduced successfully:

```text
Build completed successfully (9521 jobs).
R=0 sorry-declarations in Bridge.Main
```
