# SemantEq Experiments

This file is the working registry for the experiments in the SemantEq scientific-audit project.

The purpose of the project is not to search only for failures. The central question is:

> Given two formalizations that purport to express the same scientific claim, what semantic relationship actually holds between them?

A successful equivalence proof is a substantive audit result. A one-way implication, a provable weakening, or an unresolved comparison is also informative. We therefore include expected-positive, expected-asymmetric, and genuinely uncertain cases.

For each experiment, the **prior expectation** should be frozen before the comparison is run. It is not the result. After the experiment, we will add the SemantEq output, Lean verification, exact toolchain/version information, and interpretation.

Project repository: [scientific_audit](https://github.com/matthewmacleod/scientific_audit)

Useful external context:

- [OpenAI math repository](https://github.com/openai/math)
- [OpenAI formalization catalogue](https://github.com/openai/math/blob/main/lean/formalization.yaml)
- [OpenAI Comparator challenges](https://github.com/openai/math/tree/main/lean/ComparatorChallenges)
- [MathVet explainer](https://github.com/mathvet/mathvet/blob/main/EXPLAINER.md)

---

## E1. Kakeya: representation equivalence and trusted consequence

**Status:** Existing run; normalize the completed results into this registry.

**Prior expectation:** Equivalent for the parameterization comparison; one-way implication for the trusted compact consequence.

### References

- [OpenAI: Local smoothing formalization scope](https://github.com/openai/math/blob/main/lean/docs/079.md)
- [OpenAI Comparator: `LocalSmoothing.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/LocalSmoothing.lean)
- [OpenAI: Local smoothing for the Euclidean wave equation](https://github.com/openai/math/tree/main/preprints/Local-smoothing-for-the-Euclidean-wave-equation-October-25-2026)

### Experiment

Audit the Kakeya statement across alternative formal representations of a unit segment.

One formulation uses a centered parameterization,

$$
\{x+t\omega : t\in[-1/2,1/2]\},
$$

while another uses an endpoint-style parameterization,

$$
\{x+t\omega : t\in[0,1]\}.
$$

The first comparison asks whether these produce semantically equivalent Kakeya-set predicates after the appropriate translation of the segment base point. We want SemantEq to establish both directions rather than treating the syntactic difference as a substantive theorem difference.

A second comparison asks whether the OpenAI formulation implies a smaller trusted compact formulation used in the audit. This is expected to be a valid restriction/consequence rather than a bidirectional equivalence.

### Results

_To be filled from the completed SemantEq/Lean run._

---

## E2. Mutually unbiased bases in dimension six: numerical weakening

**Status:** Existing run; normalize the completed results into this registry.

**Prior expectation:** The headline/reference statement is strictly stronger than the selected Lean candidate.

### References

- [OpenAI formalization scope: exactly three mutually unbiased bases in dimension six](https://github.com/openai/math/blob/main/lean/docs/266.md)
- [OpenAI Comparator: `MUBSix.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MUBSix.lean)
- [OpenAI paper: The maximum number of mutually unbiased bases in dimension six](https://github.com/openai/math/tree/main/preprints/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026)

### Experiment

Compare the scientific claim that every family of mutually unbiased bases in $\mathbb C^6$ has at most three members with the selected formal statement establishing an upper bound of five.

Abstractly, the central comparison is:

$$
N\le 3
$$

versus

$$
N\le 5.
$$

We expect the stronger bound to imply the weaker bound, but not conversely. This is the clean numerical-weakening control case.

### Results

_To be filled from the completed SemantEq/Lean run._

---

## E3. Ordinary Elliott: two encodings of uniform nonpretentiousness

**Status:** Planned.

**Prior expectation:** Probably equivalent, but not syntactically obvious.

### References

- [OpenAI formalization scope: ordinary two-point correlations and the corrected Elliott conjecture](https://github.com/openai/math/blob/main/lean/docs/007.md)
- [OpenAI Comparator: `OrdinaryElliott.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/OrdinaryElliott.lean)

### Experiment

Compare two formal encodings of uniform nonpretentiousness appearing in the OpenAI development.

One style expresses divergence through a limit of an infimum-distance quantity, schematically:

$$
\inf_{|t|\le N} D(f,\chi n^{it};N)\longrightarrow\infty.
$$

Another expresses the same intended condition through eventual threshold domination:

$$
\forall K,\; \text{eventually }\forall |t|\le N,\quad K\le D(f,\chi n^{it};N)^2.
$$

The experiment asks whether SemantEq can certify equivalence after accounting for the square/square-root relationship and the exact definitions used in the two statements.

This is a particularly useful positive case because the formulations are independently written and structurally different even though they appear to encode the same mathematical concept.

### Results

#### E3-A

Full Ordinary Elliott formulations

This is the first real experiment. Compares

- elliott_infimum_ref.lean: the Tendsto / sInf / square-root formulation
- elliott_threshold_candidate.lean: the eventual threshold formulation

```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_infimum_ref.lean \
  ../src/elliott_threshold_candidate.lean \
```

Both fixtures compiled successfully, and SemantEq returned:
```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_infimum_ref.lean \
  ../src/elliott_threshold_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T13:56:03Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_infimum_ref__vs__elliott_threshold_candidate
── elliott_infimum_ref__vs__elliott_threshold_candidate
   verdict: Inconclusive   (66907 ms)
   ref ⇒ cand: not proved
      no proof found in 67 attempts
   cand ⇒ ref: not proved
      no proof found in 67 attempts
```


Prior: Equivalent
Verdict: Inconclusive
ref ⇒ cand: not proved, 67 attempts
cand ⇒ ref: not proved, 67 attempts

Interpretation: SemantEq-Eval could not autonomously establish equivalence between the two full independently written OpenAI formulations. This is not evidence of non-equivalence.

```
lake exe semanteq --strict --timeout 0 --raw \
  ../src/elliott_infimum_ref.lean \
  ../src/elliott_threshold_candidate.lean \
  > ../results/elliott_raw.json
```

#### E3-B

```
 lake exe semanteq --strict --timeout 0 \
  ../src/elliott_distance_ref.lean \
  ../src/elliott_distance_candidate.lean
semanteq v1.4.0  git f927670 (dirty)  2026-10-30T04:35:54Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_distance_ref__vs__elliott_distance_candidate
── elliott_distance_ref__vs__elliott_distance_candidate
   verdict: Inconclusive   (193196 ms)
   ref ⇒ cand: not proved
      no proof found in 79 attempts
   cand ⇒ ref: not proved
      last refusal (1 proof refused): normalize (plumbing/cast); simp only [Finset.range_add, Nat.add_one, Nat.add_comm, Real.ext_cauchy_iff, Nat.add_succ, Finset.sum_filter, Nat.Icc_eq_range', Nat.floor_natCast, ← Set.ncard_Iic_nat, MonCat.one_of, ← Nat.siz
```

```
lake exe semanteq --strict --timeout 0 --raw \
  ../src/elliott_distance_ref.lean \
  ../src/elliott_distance_candidate.lean \
  > ../results/elliott_distance_raw.json
```

Prior: Equivalent
Verdict: Inconclusive
ref ⇒ cand: not proved, 79 attempts
cand ⇒ ref: not proved; one generated proof refused by strict normalization policy
Interpretation: unresolved under strict SemantEq; diagnostic evidence points to finite-prime-range/index normalization as a search/audit boundary.

#### E3-B1

```
lake exe semanteq --strict --timeout 0 --raw \
  ../src/elliott_twist_ref.lean \
  ../src/elliott_twist_candidate.lean \
  > ../results/elliott_twist_raw.json
```

```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_twist_ref.lean \
  ../src/elliott_twist_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T06:07:19Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_twist_ref__vs__elliott_twist_candidate
── elliott_twist_ref__vs__elliott_twist_candidate
   verdict: DefEq   (1327 ms)
   identical statements, no implication proof needed
```

E3-B1 result: DefEq. The star (...) and conj (characterTwist ...) formulations elaborate to identical propositions. No implication proof was required. Therefore the character-twist/conjugation encoding does not explain the unresolved raw E3 comparison.

---

#### E3-B2

```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_prime_range_ref.lean \
  ../src/elliott_prime_range_candidate.lean

```

Results
```
lake exe semanteq --strict --timeout 0   ../src/elliott_prime_range_ref.lean   ../src/elliott_prime_range_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T06:00:27Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_prime_range_ref__vs__elliott_prime_range_candidate
── elliott_prime_range_ref__vs__elliott_prime_range_candidate
   verdict: Inconclusive   (194644 ms)
   ref ⇒ cand: not proved
      no proof found in 83 attempts
   cand ⇒ ref: not proved
      no proof found in 83 attempts

```

#### B2 bridge

$$
(\operatorname{Icc}(2,N)).\operatorname{filter}(\operatorname{Prime})
=
(\operatorname{range}(N+1)).\operatorname{filter}(\operatorname{Prime}).
$$

```
lake env lean ../src/elliott_prime_range_bridge.lean
```

#### B2 ProofAudit ref and cand

Results

```
lake exe semanteq --strict --proof   ../src/elliott_prime_range_ref_to_candidate_proofaudit.lean   ../src/elliott_prime_range_candidate_to_ref_proofaudit.lean
[proof-audit] ../src/elliott_prime_range_ref_to_candidate_proofaudit.lean
[semanteq] importing (cache miss #1): #[Init, Mathlib]
── ../src/elliott_prime_range_ref_to_candidate_proofaudit.lean
   verdict: PASS   (antecedent reference_assumed, goal candidate_from_reference)
   warnings: 3 tolerated (3 library facts inside a rewrite record or a local restatement's proof)
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
[proof-audit] ../src/elliott_prime_range_candidate_to_ref_proofaudit.lean
── ../src/elliott_prime_range_candidate_to_ref_proofaudit.lean
   verdict: PASS   (antecedent candidate_assumed, goal reference_from_candidate)
   warnings: 3 tolerated (3 library facts inside a rewrite record or a local restatement's proof)
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
```

The two representations are formally equivalent, but SemantEq-Eval did not autonomously discover the equivalence under strict mode. Once supplied with an explicit kernel-checked bridge, SemantEq-ProofAudit certifies both implications.


#### E3-C

Pure analytic equivalence


OpenAI’s reference formulation is literally Tendsto of an sInf of the square-root distance, while the second formulation quantifies over every real threshold $K$ and eventually requires the squared distance to exceed it uniformly in $t$. 

For this probe we remove all number theory, prime enumeration, character twists, and even the |t| ≤ N versus Icc difference. The only remaining comparison is:

$$
\inf_{t\in[-N,N]}\sqrt{d_N(t)}
\longrightarrow +\infty
$$

versus

$$
\forall K\in\mathbb R,\quad
\forall^\infty N,\quad
\forall t\in[-N,N],\quad
K\le d_N(t).
$$

Frozen prior:

$$
\boxed{\text{Equivalent}}
$$

Results
```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_analytic_infimum_ref.lean \
  ../src/elliott_analytic_threshold_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T13:31:23Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_analytic_infimum_ref__vs__elliott_analytic_threshold_candidate
── elliott_analytic_infimum_ref__vs__elliott_analytic_threshold_candidate
   verdict: Inconclusive   (88020 ms)
   ref ⇒ cand: not proved
      no proof found in 85 attempts
   cand ⇒ ref: not proved
      no proof found in 85 attempts
```

Inconclusive.

That means we have now isolated a second independent search boundary. The raw E3-A failure is not explained solely by the prime-range normalization.

## E3-C1


C1 should preserve exactly that structural fact:

$$
g_N(t)\ge 0.
$$

Then we test only:
$$
\inf_{t\in[-N,N]}g_N(t)\to+\infty
$$

versus

$$
\forall K\in\mathbb R,\quad
\forall^\infty N,\quad
\forall t\in[-N,N],\quad
K\le g_N(t).
$$

Results

```
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_analytic_infimum_nosqrt_ref.lean \
  ../src/elliott_analytic_threshold_nosqrt_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T14:27:56Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_analytic_infimum_nosqrt_ref__vs__elliott_analytic_threshold_nosqrt_candidate
── elliott_analytic_infimum_nosqrt_ref__vs__elliott_analytic_threshold_nosqrt_candidate
   verdict: Inconclusive   (292033 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```

E3-C1: The pure nonnegative infimum-divergence formulation remains Inconclusive under SemantEq-Eval. This isolates the unresolved transformation to the relationship between sInf/Tendsto atTop and eventual uniform pointwise lower bounds. It does not establish non-equivalence.

## E3-C1a

E3-C1a asks only whether SemantEq recognizes the standard threshold meaning of divergence to $+\infty$:

$$
h(N)\to+\infty
$$

versus

$$
\forall K\in\mathbb R,\quad
\forall^\infty N,\quad K\le h(N).
$$

No sInf, no intervals, no square roots, no Elliott machinery at all.

Frozen prior:

$$
\boxed{\text{Equivalent}}
$$

```
 lake exe semanteq --strict --timeout 0 \
  ../src/elliott_tendsto_attop_ref.lean \
  ../src/elliott_tendsto_threshold_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T15:29:58Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_tendsto_attop_ref__vs__elliott_tendsto_threshold_candidate
── elliott_tendsto_attop_ref__vs__elliott_tendsto_threshold_candidate
   verdict: EquivalentRestricted   (122444 ms)
   ref ⇒ cand: proved
      script: simp only [Filter.tendsto_atTop] at hyps/h_ante; simp only [SemantEqRef.tendsto_attop_ref]; <structural close>
      proof:  fun h K => Eq.mp (forall_congr fun h => _simp_1) SemantEqRef.tendsto_attop_ref h K
   cand ⇒ ref: proved
      script: intros; rw [Filter.tendsto_atTop] at *; <structural close>
      proof:  fun h =>
                Eq.mpr (id (congrArg (fun _a => _a) (propext Filter.tendsto_atTop))) (SemantEqCand.tendsto_threshold_candidate h)
```

E3-C1a result: EquivalentRestricted. SemantEq proved both directions using Filter.tendsto_atTop. Therefore the unresolved E3-C1 comparison is not caused by the equivalence between Tendsto ... atTop atTop and eventual threshold domination.




#### E3-C1b

the remaining suspect is overwhelmingly the sInf layer:

$$
K\le
\inf_{t\in[-N,N]} g_N(t)
$$

versus

$$
\forall t\in[-N,N],\quad K\le g_N(t).
$$

That is exactly E3-C1b.

The comparison is:

$$
K \le \inf S
$$

versus

$$
\forall x\in S,\quad K\le x,
$$

for a nonempty, bounded-below set $S\subseteq\mathbb R$.

That is exactly the characterization we need inside C1, with nothing Elliott-specific left.

Frozen prior:

$$
\boxed{\text{Equivalent}}
$$

```
 lake exe semanteq --strict --timeout 0 \
  ../src/elliott_sinf_lower_bound_ref.lean \
  ../src/elliott_sinf_pointwise_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T16:03:43Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_sinf_lower_bound_ref__vs__elliott_sinf_pointwise_candidate
── elliott_sinf_lower_bound_ref__vs__elliott_sinf_pointwise_candidate
   verdict: Inconclusive   (753293 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```

E3-C1b result: Inconclusive. SemantEq-Eval did not prove either direction of the standard equivalence between $K \le \inf S$ and $K$ being a lower bound of every element of a nonempty bounded-below set $S$. Since E3-C1a independently certified the Tendsto atTop/eventual-threshold transformation, this isolates sInf lower-bound reasoning as at least one remaining search boundary.





#### E3-C1b proof audit

```
lake exe semanteq --strict --proof \
  ../src/elliott_sinf_ref_to_candidate_proofaudit.lean \
  ../src/elliott_sinf_candidate_to_ref_proofaudit.lean
[proof-audit] ../src/elliott_sinf_ref_to_candidate_proofaudit.lean
[semanteq] importing (cache miss #1): #[Init, Mathlib]
── ../src/elliott_sinf_ref_to_candidate_proofaudit.lean
   verdict: FAIL   (antecedent reference_assumed, goal candidate_from_reference)
   reasons:
      content import le_trans on goal spine (application head)
      content import csInf_le on goal spine (application head)
   warnings: none
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
[proof-audit] ../src/elliott_sinf_candidate_to_ref_proofaudit.lean
── ../src/elliott_sinf_candidate_to_ref_proofaudit.lean
   verdict: FAIL   (antecedent candidate_assumed, goal reference_from_candidate)
   reasons:
      content import le_csInf on goal spine (application head)
   warnings: none
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
```

Prior: Equivalent.
Eval: Inconclusive; neither direction proved after 87 attempts.
Lean: both implications are kernel-checkable using the standard conditional-completeness facts csInf_le and le_csInf.
ProofAudit: FAIL in both directions. Strict ProofAudit rejects the required sInf facts as content imports on the goal spine (le_trans, csInf_le, le_csInf).
Interpretation: the propositions are mathematically equivalent, but the equivalence lies outside SemantEq-ProofAudit's restricted admissible transformation regime.


#### E3-C2

We have already localized one boundary to sInf, but C still also contained

$$
\sqrt{d_N(t)}
$$

versus

$$
d_N(t).
$$

So C2 should ask only the elementary equivalence, under the conditions actually relevant to squared distance:

$$
0\le x,\quad 0\le r,
$$

and compare

$$
r\le\sqrt{x}
$$

with

$$
r^2\le x.
$$

Frozen prior:

$$
\boxed{\text{Equivalent}}
$$


Results
```
 lake exe semanteq --strict --timeout 0 \
  ../src/elliott_sqrt_threshold_ref.lean \
  ../src/elliott_square_threshold_candidate.lean
semanteq v1.4.0  git f927670  2026-10-30T18:50:27Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing elliott_sqrt_threshold_ref__vs__elliott_square_threshold_candidate
── elliott_sqrt_threshold_ref__vs__elliott_square_threshold_candidate
   verdict: Inconclusive   (469546 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```

prove bridge
```
lake env lean ../src/elliott_sqrt_threshold_bridge.lean
```

Results
```
lake exe semanteq --strict --proof \
  ../src/elliott_sqrt_ref_to_candidate_proofaudit.lean \
  ../src/elliott_sqrt_candidate_to_ref_proofaudit.lean
[proof-audit] ../src/elliott_sqrt_ref_to_candidate_proofaudit.lean
[semanteq] importing (cache miss #1): #[Init, Mathlib]
── ../src/elliott_sqrt_ref_to_candidate_proofaudit.lean
   verdict: PASS   (antecedent reference_assumed, goal candidate_from_reference)
   warnings: none
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
[proof-audit] ../src/elliott_sqrt_candidate_to_ref_proofaudit.lean
── ../src/elliott_sqrt_candidate_to_ref_proofaudit.lean
   verdict: PASS   (antecedent candidate_assumed, goal reference_from_candidate)
   warnings: none
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
```

Prior: Equivalent.
Eval: Inconclusive; neither direction proved after 87 attempts.
Lean: equivalence kernel-checked.
ProofAudit: PASS in both directions when expressed through the canonical Mathlib theorem Real.le_sqrt; no warnings or extra axioms.
Interpretation: the square-root/squared-threshold equivalence lies within SemantEq’s restricted admissible transformation regime, but Eval does not autonomously discover it.

#### E3-D

The theorem we want is exactly:

$$
\operatorname{Tendsto}\left(
N\mapsto
\inf_{t\in[-N,N]}\sqrt{d_N(t)},
\operatorname{atTop},
\operatorname{atTop}
\right)
$$

if and only if

$$
\forall K\in\mathbb R,\quad
\forall^\infty N,\quad
\forall t\in[-N,N],
\quad K\le d_N(t).
$$

<!verified the Mathlib signatures we need: Real.sqrt_pos gives $0<\sqrt{x}\leftrightarrow0<x$, and Real.le_sqrt gives $r\le\sqrt{x}\leftrightarrow r^2\le x$ under nonnegativity assumptions. Lean Community.>


No output means E3-D kernel-checks cleanly with no sorry, no warnings, and no linter issues.

So we have now formally established in Lean:

$$
\boxed{
\operatorname{Tendsto}\left(
N\mapsto
\inf_{t\in[-N,N]}\sqrt{d_N(t)},
\operatorname{atTop},
\operatorname{atTop}
\right)
\iff
\forall K,\;\forall^\infty N,\;\forall t\in[-N,N],\;K\le d_N(t)
}
$$

for arbitrary

$$
d:\mathbb N\to\mathbb R\to\mathbb R.
$$

That is stronger than merely saying we “expect” the analytic formulations to agree. Lean has now proved the equivalence.


E3-D result: The complete abstract analytic equivalence was proved directly in Lean with no sorry declarations or warnings. Thus the sInf/square-root/Tendsto formulation and the eventual squared-distance threshold formulation are mathematically equivalent. SemantEq-Eval’s earlier Inconclusive verdict therefore reflects an autonomous equivalence-discovery limitation rather than a semantic mismatch.

#### Full bridge


```
lake env lean ../src/elliott_full_source_equiv_bridge.lean
```

this finishes successful. 

E3 conclusion. OpenAI's two independently written formulations of uniform nonpretentiousness are formally equivalent: a full source-level Lean bridge compiles without sorry or warnings. The original SemantEq-Eval comparison nevertheless returned Inconclusive. Diagnostic decomposition shows that some representation changes are definitionally equal or autonomously certifiable, while others require explicit bridges. In particular, the sInf lower-bound characterization is mathematically valid but falls outside strict ProofAudit's restricted admissible transformation regime. E3 therefore identifies a boundary between general mathematical equivalence and autonomous/restricted semantic-equivalence certification; it does not identify a soundness failure.

## E4. Reconstruction threshold: biconditional versus one direction

**Status:** Planned.

**Prior expectation:** The exact-threshold claim is stronger than a supercritical reconstruction statement.

### References

- [OpenAI paper: The exact reconstruction threshold for the three-state symmetric channel](https://github.com/openai/math/tree/main/preprints/The-exact-reconstruction-threshold-for-the-three-state-symmetric-channel-September-25-2026)
- [OpenAI math repository](https://github.com/openai/math)

### Experiment

Compare the advertised exact reconstruction threshold

$$
\operatorname{Reconstructs}\iff d\lambda^2>1
$$

with a formal statement establishing only the supercritical direction,

$$
d\lambda^2>1\;\Longrightarrow\;\operatorname{Reconstructs}.
$$

The exact threshold also requires non-reconstruction at or below the threshold. The experiment should test whether SemantEq correctly distinguishes a biconditional from one of its implications.

This is a logical-completeness case rather than a numerical-bound case.

### Results

_To be filled after the experiment._

---

## E5. Mass-action permanence: quantifier order

**Status:** Planned.

**Prior expectation:** The class-uniform statement is stronger than the trajectory-dependent statement.

### References

- [OpenAI formalization scope: classwise permanence for weakly reversible mass-action systems](https://github.com/openai/math/blob/main/lean/docs/149.md)
- [OpenAI Comparator: `MassAction.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MassAction.lean)
- [OpenAI paper: Uniform Permanence in Weakly Reversible Mass-Action Systems](https://github.com/openai/math/tree/main/preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026)

### Experiment

Compare a classwise permanence claim in which one common compact absorbing set, or one common positive bound, works for every trajectory in a positive stoichiometric compatibility class with a statement in which the bound may depend on the initial state.

The semantic distinction is approximately:

$$
\exists \varepsilon>0\;\forall x\;P(x,\varepsilon)
$$

versus

$$
\forall x\;\exists \varepsilon_x>0\;P(x,\varepsilon_x).
$$

The first implies the second, while the reverse does not follow in general. This is intended as a direct test of whether SemantEq preserves quantifier scope rather than matching only local predicates and vocabulary.

### Results

_To be filled after the experiment._

---

## E6. Borsuk dimension nine: ambient representation invariance

**Status:** Planned.

**Prior expectation:** Probably equivalent after an explicit affine-isometric identification.

### References

- [OpenAI formalization scope: Borsuk's conjecture fails in dimension nine](https://github.com/openai/math/blob/main/lean/docs/156.md)
- [OpenAI Comparator: `BorsukNine.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/BorsukNine.lean)

### Experiment

Compare the formal counterexample expressed as a set of rank-one orthogonal projectors inside the affine space of trace-one symmetric $4\times4$ matrices with the scientific statement that there is a Borsuk counterexample in $\mathbb R^9$.

The relevant representation fact is that the trace-one symmetric matrices form a nine-dimensional affine Euclidean space. The audit asks whether the Borsuk property is preserved under the explicit affine-isometric transport into $\mathbb R^9$.

This extends the Kakeya positive-control idea from reparameterization of an object to a change of ambient representation.

### Results

_To be filled after the experiment._

---

## E7. Irrationality exponent of $\pi$: two characterizations of exponent two

**Status:** Planned.

**Prior expectation:** Probably equivalent given the standard background facts encoded by the development.

### References

- [OpenAI formalization scope: the irrationality exponent of $\pi$ is 2](https://github.com/openai/math/blob/main/lean/docs/017.md)
- [OpenAI Comparator: `PiExponent.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/PiExponent.lean)
- [OpenAI Lean implementation: `PiExponent/Main.lean`](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/PiExponent/Main.lean)
- [OpenAI paper: The irrationality exponent of pi is 2](https://github.com/openai/math/tree/main/preprints/The-irrationality-exponent-of-pi-is-2-September-24-2026)

### Experiment

Split the selected theorem into its two mathematical characterizations and audit them against one another.

One formulation gives eventual lower bounds: for every $\nu>2$, sufficiently large denominators satisfy

$$
\left|\pi-\frac pq\right|\ge q^{-\nu}.
$$

The other defines the irrationality exponent through a supremum over exponents admitting infinitely many sufficiently good rational approximations and states that this supremum equals $2$.

The experiment asks whether SemantEq can recover the equivalence between these substantially different descriptions under the exact assumptions and definitions available in the formal development.

### Results

_To be filled after the experiment._

---

## E8. Weak mixing versus ergodicity

**Status:** Planned.

**Prior expectation:** Weak mixing is stronger; the reverse implication should not be certified without additional assumptions.

### References

- [OpenAI paper: Weak mixing of triangular billiards with an irrational angle](https://github.com/openai/math/tree/main/preprints/Weak-mixing-of-triangular-billiards-with-an-irrational-angle-October-5-2026)
- [OpenAI triangle-billiards Lean development](https://github.com/openai/math/tree/main/lean/OAI/Dynamics/TriangleBilliards)

### Experiment

Compare the claim that the billiard flow is weakly mixing with the weaker property that it is ergodic.

Schematically,

$$
\operatorname{WeakMixing}(T)\Longrightarrow\operatorname{Ergodic}(T),
$$

while ergodicity alone does not imply weak mixing in general.

This is a property-hierarchy experiment. Unlike MUB, the difference is not a changed numerical constant; unlike reconstruction, the relationship depends on a genuine mathematical theorem connecting two dynamical properties.

A key methodological question is whether that bridge theorem is already available within the permitted trusted background or must be supplied explicitly.

### Results

_To be filled after the experiment._

---

## E9. Heilbronn triangle problem: eventual versus subsequential asymptotics

**Status:** Planned.

**Prior expectation:** The eventual statement is stronger than an unbounded-subsequence construction.

### References

- [OpenAI formalization scope: a power improvement in the Heilbronn triangle lower bound](https://github.com/openai/math/blob/main/lean/docs/191.md)
- [OpenAI Comparator: `HeilbronnTriangle.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/HeilbronnTriangle.lean)

### Experiment

Compare a claim holding for every sufficiently large $n$ with a construction known only along an unbounded sequence of sizes.

The semantic contrast is approximately:

$$
\exists N\;\forall n\ge N,\;P(n)
$$

versus

$$
\exists (n_j)_{j\ge1},\quad n_j\to\infty\quad\text{and}\quad\forall j,\;P(n_j).
$$

The first yields the second after choosing a suitable sequence; the reverse does not follow. This is an asymptotic-quantification audit.

### Results

_To be filled after the experiment._

---

## E10. Stable coordinate: predicate form versus expanded witness form

**Status:** Planned.

**Prior expectation:** Very likely equivalent after definition unfolding.

### References

- [OpenAI formalization scope: a stable-coordinate counterexample in four variables](https://github.com/openai/math/blob/main/lean/docs/049.md)
- [OpenAI Comparator: `StableCoordinateFour.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/StableCoordinateFour.lean)

### Experiment

Compare the high-level predicate formulation of a polynomial being a stable coordinate but not a coordinate with the corresponding expanded witness formulation using polynomial automorphisms after adjoining an extra variable.

The aim is to test whether SemantEq can recognize semantic identity that is hidden largely behind definition expansion, witness packaging, and equivalent predicate interfaces.

This should serve as a positive calibration case outside the analysis/combinatorics examples.

### Results

_To be filled after the experiment._

---

## E11. $\mathsf L=\mathsf{RL}=\mathsf{BPL}$: equality normalization

**Status:** Planned.

**Prior expectation:** Equivalent.

### References

- [OpenAI formalization scope: exact derandomization of logarithmic space](https://github.com/openai/math/blob/main/lean/docs/103.md)
- [OpenAI Comparator: `LogspaceEquality.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/LogspaceEquality.lean)
- [OpenAI paper: Exact derandomization of logarithmic space](https://github.com/openai/math/tree/main/preprints/Exact-Derandomization-of-Logarithmic-Space-L-equals-RL-equals-BPL-September-23-2026)

### Experiment

Compare alternative logical presentations of equality among the three complexity classes, for example

$$
\mathsf L=\mathsf{RL}\;\land\;\mathsf{RL}=\mathsf{BPL}
$$

and

$$
\mathsf L=\mathsf{RL}\;\land\;\mathsf L=\mathsf{BPL}.
$$

The experiment is intentionally simple mathematically. Its purpose is to verify that SemantEq handles equality symmetry/transitivity and conjunction normalization correctly before those same transformations appear inside more complicated statements.

### Results

_To be filled after the experiment._

---

## E12. Hyperbolicity cones: spectrahedrality versus semidefinite lifts

**Status:** Planned.

**Prior expectation:** Nonexistence of any semidefinite lift is stronger than nonspectrahedrality in the original coordinates.

### References

- [OpenAI formalization scope: hyperbolicity cones without semidefinite lifts](https://github.com/openai/math/blob/main/lean/docs/095.md)
- [OpenAI Comparator: `HyperbolicCones.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/HyperbolicCones.lean)

### Experiment

Distinguish two notions of semidefinite representability:

1. being spectrahedral in the original coordinates; and
2. being a spectrahedral shadow, equivalently admitting a finite semidefinite lift with auxiliary variables.

Schematically,

$$
\neg\operatorname{SemidefiniteLift}(C)
\Longrightarrow
\neg\operatorname{Spectrahedral}(C),
$$

but a nonspectrahedral set may still admit a semidefinite lift.

The audit should determine exactly which representation notion is asserted by the candidate theorem and whether the stronger no-lift claim follows.

Care is required to preserve witness identity: a companion result may construct a semidefinite lift for a particular explicit cone, so we must not conflate distinct cones or distinct claims within the family.

### Results

_To be filled after the experiment._

---

## E13. Uniform rectifiability and big pieces of Lipschitz images

**Status:** Planned stretch-positive case.

**Prior expectation:** Mathematically expected to correspond under the standard characterization used by the formalization; SemantEq success is uncertain because the bridge contains substantive geometry.

### References

- [OpenAI paper: Riesz transforms and uniform rectifiability in higher codimension](https://github.com/openai/math/tree/main/preprints/Riesz-transforms-and-uniform-rectifiability-in-higher-codimension-September-24-2026)
- [OpenAI Comparator: `RieszQuantitative.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/RieszQuantitative.lean)

### Experiment

Compare a conclusion phrased as uniform $n$-rectifiability with a conclusion phrased through uniform big pieces of Lipschitz images (BPLI), under the Ahlfors-David regularity and quantitative hypotheses in the formal development.

The purpose is to test a positive equivalence whose bridge is itself mathematically meaningful rather than merely syntactic or definitional.

A SemantEq failure here would not by itself establish non-equivalence. It may instead show that the equivalence requires background mathematics outside the system's permitted transformation set.

### Results

_To be filled after the experiment._

---

## E14. Exponential Time Hypothesis: cross-lab formalization alignment

**Status:** Planned; open-ended cross-formalization experiment.

**Prior expectation:** The OpenAI subexponential SAT/counting result should imply an appropriate neutral statement of $\neg\mathrm{ETH}$; the exact relationship between the OpenAI and Anthropic formalizations is uncertain until machine models, encodings, asymptotics, and definitions are aligned.

### References

- [OpenAI formalization scope: The Exponential Time Hypothesis is False](https://github.com/openai/math/blob/main/lean/docs/378.md)
- [OpenAI Comparator: `SubexponentialSAT.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SubexponentialSAT.lean)
- [Anthropic formal-math ETH README](https://github.com/anthropics/formal-math/blob/main/eth/README.md)
- [Anthropic `MainResults.lean`](https://github.com/anthropics/formal-math/blob/main/eth/MainResults.lean)

### Experiment

Construct, if feasible, a small neutral target expressing the relevant form of the Exponential Time Hypothesis and compare it separately with the OpenAI and Anthropic formalizations.

The OpenAI selected theorem proves a deterministic exact-counting/SAT algorithm for fixed-width CNF formulas with a subexponential-in-$n$ runtime bound. Anthropic's independent Lean development explicitly defines `ETH` and `ETHIsFalse` using its own machine model and formal interfaces.

The ideal audit has three nodes:

$$
\text{OpenAI algorithm statement}
\quad\longrightarrow\quad
\neg\mathrm{ETH}_{\text{neutral}},
$$

$$
\text{Anthropic `ETHIsFalse`}
\quad\longleftrightarrow\quad
\neg\mathrm{ETH}_{\text{neutral}},
$$

and, only after those bridges are understood, a comparison between the two labs' formal statements.

This is deliberately not assumed to be a simple equivalence test. Differences in machine model, input encoding, counting versus decision, asymptotic conventions, and fixed-width quantification must remain explicit rather than being normalized away informally.

### Results

_To be filled after the experiment._

---

## Experiment record template

When an experiment is run, append the following under its `Results` heading.

```text
SemantEq version:
Lean version:
Mathlib/toolchain:
Source revision(s):
Reference statement digest:
Candidate statement digest:
Prior expectation:
SemantEq classification:
Reference -> candidate:
Candidate -> reference:
Lean verification:
Trusted assumptions / imported bridge lemmas:
Countermodel or obstruction, if applicable:
Interpretation:
Artifacts:
```

The interpretation should distinguish at least the following outcomes where applicable:

- **Equivalent:** both directions are certified under the stated assumptions.
- **One-way implication:** one statement is a certified consequence of the other.
- **Provably non-equivalent:** separation is independently established, not merely inferred from a failed search.
- **LikelyTooWeak / likely too strong:** SemantEq finds a directional strength relationship but does not establish full semantic separation.
- **Unknown:** the permitted search/transformation system did not settle the relationship.

A failure to prove equivalence is not, by itself, evidence of non-equivalence.
