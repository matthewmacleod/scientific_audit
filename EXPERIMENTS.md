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

- [Wikepedia Background Multiplicative Function](https://en.wikipedia.org/wiki/Multiplicative_function)
- [Wikepedia Background Analytic Number Theory](https://en.wikipedia.org/wiki/Analytic_number_theory)
- [Terence Tao's Intro](https://terrytao.wordpress.com/2015/09/11/the-erdos-discrepancy-problem-via-the-elliott-conjecture/)

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


**Prior expectation:** The exact-threshold claim is stronger than a supercritical reconstruction statement.



### References

- [OpenAI paper: The exact reconstruction threshold for the three-state symmetric channel](https://github.com/openai/math/tree/main/preprints/The-exact-reconstruction-threshold-for-the-three-state-symmetric-channel-September-25-2026)
- [OpenAI math repository](https://github.com/openai/math)
-
- [Wikepedia](https://en.wikipedia.org/wiki/Reconstruction_conjecture)

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


```
lake exe semanteq --strict --timeout 0 \
  ../src/reconstruction_exact_ref.lean \
  ../src/reconstruction_supercritical_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T01:55:21Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing reconstruction_exact_ref__vs__reconstruction_supercritical_candidate
── reconstruction_exact_ref__vs__reconstruction_supercritical_candidate
   verdict: LikelyTooWeak   (170071 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.reconstruction_exact_ref, <structural>]
      proof:  fun Reconstructs b hb lam hlam a =>
                And.casesOn hlam fun left right =>
                  Iff.casesOn
                    ((fun Reconstructs b hb lam hlam => Iff.symm (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam))
                      Reconstructs b hb lam hlam)
                    fun mp mpr =>
                    Iff.casesOn (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam) fun mp mpr =>
                      (fun Reconstructs b hb lam hlam => (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam).mpr)
                        Reconstructs b hb lam ⟨hlam.left, hlam.right⟩ a
   cand ⇒ ref: not proved
      no proof found in 81 attempts
```

there is an issue this is provisional: 

We wrote:
theorem reconstruction_exact_ref
    (Reconstructs : ℕ → ℝ → Prop)
    ...

That means Reconstructs is universally quantified as part of the theorem. So the candidate is really something like

$$
\forall R\,\forall b\,\forall\lambda,\quad
P(b,\lambda)\to R(b,\lambda),
$$

rather than a theorem about one fixed reconstruction predicate. If there exists a supercritical admissible pair, choosing $R=\bot$ makes that universal theorem inconsistent. Strict SemantEq did not exploit that inconsistency, which is good, but it means this controlled fixture is not as semantically clean as I thought when I wrote it.

Provisional only: Reconstructs was universally quantified, so this fixture tests syntactic/logical shape but is not used as the canonical E4 strength comparison.

#### E4-B2


```
lake exe semanteq --strict --timeout 0 \
  ../src/reconstruction_reduced_exact_ref.lean \
  ../src/reconstruction_reduced_supercritical_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T05:50:50Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing reconstruction_reduced_exact_ref__vs__reconstruction_reduced_supercritical_candidate
── reconstruction_reduced_exact_ref__vs__reconstruction_reduced_supercritical_candidate
   verdict: LikelyTooWeak   (94928 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.OAI.ThreeStateReduced.regular_exact, <structural>]
      proof:  fun b hb lam h hcrit =>
                And.casesOn (motive := fun x =>
                  SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) →
                    (1 < ↑b * lam ^ 2 ↔
                        SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x)) →
                      (SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) ↔
                          1 < ↑b * lam ^ 2) →
                        ∃ L,
                          0 < L ∧ Filter.Tendsto (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) Filter.atTop (nhds L))
                  h
                  (fun left right h_fwd_0 h_fwd_1 h_fwd_2 =>
                    Iff.casesOn h_fwd_1 fun mp mpr =>
                      Iff.casesOn h_fwd_2 fun mp mpr =>
                        (fun b hb lam h => (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h).mpr) b hb lam ⟨left, right⟩
                          hcrit)
                  ((fun b hb lam h => (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h).mpr) b hb lam h hcrit)
                  ((fun b hb lam h => Iff.symm (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h)) b hb lam h)
                  (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h)
   cand ⇒ ref: not proved
      no proof found in 71 attempts
```

E4-B2 result: LikelyTooWeak. SemantEq proved the exact-threshold reference implies OpenAI’s selected supercritical reconstruction theorem, but did not prove the converse after 71 attempts. The fixture preserves OpenAI’s actual Reconstructs semantics and threshold expression while replacing the computationally expensive internal construction of regularAdvantage with a fixed opaque symbol. This isolates logical strength rather than implementation details.

#### E4-C

```
lake env lean ../src/reconstruction_separation_witness.lean
```

finishes successfully.


E4 is not merely “SemantEq didn’t prove the converse.” We have independently established strict weakening:

$$
\text{Exact threshold} \Rightarrow \text{Supercritical theorem}
$$

but

$$
\text{Supercritical theorem} \nRightarrow \text{Exact threshold}.
$$

That gives us a nice methodological contrast between search incompleteness (E3) and correct strength diagnosis (E4).

---

## E5. Mass-action permanence: quantifier order

**Status:** Planned.

**Prior expectation:** The class-uniform statement is stronger than the trajectory-dependent statement.

### References

- [OpenAI formalization scope: classwise permanence for weakly reversible mass-action systems](https://github.com/openai/math/blob/main/lean/docs/149.md)
- [OpenAI Comparator: `MassAction.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MassAction.lean)
- [OpenAI paper: Uniform Permanence in Weakly Reversible Mass-Action Systems](https://github.com/openai/math/tree/main/preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026)

- [arXiv review](https://arxiv.org/abs/1010.3050)
- [Wikipedia Chemical reaction network theory](https://en.wikipedia.org/wiki/Chemical_reaction_network_theory)
- [A blog on reaction network theory](https://johncarlosbaez.wordpress.com/2011/11/12/network-theory-part-17/)


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

#### Experimental refinement

E5-A — Uniformity only. Hold everything else fixed and compare

$$
\exists\varepsilon\,\forall x_0\,P(\varepsilon,x_0)
$$

against

$$
\forall x_0\,\exists\varepsilon\,P(\varepsilon,x_0).
$$


E5-B — Time only. Fix one $(x_0,\varepsilon)$ and compare eventual bounds

$$
\exists T\,\forall t\ge T,\;P(t)
$$

against all-time bounds

$$
\forall t\ge0,\;P(t).
$$

Here the direction reverses:

$$
\text{all-time}\Rightarrow\text{eventual},
$$

but not conversely. This isolates the part where Lean is actually stronger.

E5-C — Combined reduced claim. Compare

$$
\exists\varepsilon\;\forall x_0\;\exists T(x_0)\;\forall t\ge T(x_0)
$$

against

$$
\forall x_0\;\exists\varepsilon(x_0)\;\forall t\ge0.
$$

E5-D — Source-faithful reduced mass-action model. Restore positive states, classes, global solutions, species-indexed concentrations, $(\varepsilon\in(0,1))$, and reciprocal upper bounds, while keeping the ODE itself opaque. This tells us whether the conclusions above survive a much closer representation of MassAction.lean.

E5-E — Geometry bridge. Formalize the connection between a compact absorbing set in the positive orthant and common positive lower/finite upper coordinate bounds. This is the mathematical bridge from the headline’s geometric permanence language to an $(\varepsilon)$-style formulation.

E5-F — Full-source stress test. Only after we know all the pieces separately do we throw a headline-faithful permanence formulation and the actual comparator structure at SemantEq. Then if it gets stuck, we know why.


### Results


#### E5-A

```
lake exe semanteq --strict --raw --timeout 0 \
  ../src/mass_action_uniform_ref.lean \
  ../src/mass_action_pointwise_candidate.lean > ../results/E5-A.json
```

SemantEq result: LikelyTooWeak; reference ⇒ candidate proved, candidate ⇒ reference not proved. Prior directionality confirmed by automated search. Strict non-implication to be independently established by E5-A separation witness.


```
lake env lean ../src/mass_action_uniformity_separation_witness.lean
```

The pointwise candidate preserves per-trajectory boundedness but does not preserve the classwise uniform witness required by permanence.

#### E5-B

```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_eventual_ref.lean \
  ../src/mass_action_all_time_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T18:50:32Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_eventual_ref__vs__mass_action_all_time_candidate
── mass_action_eventual_ref__vs__mass_action_all_time_candidate
   verdict: Inconclusive   (202846 ms)
   ref ⇒ cand: not proved
      no proof found in 37 attempts
   cand ⇒ ref: not proved
      no proof found in 37 attempts
```

E5-B: Eval returned Inconclusive in both directions, although a direct kernel-checked proof establishes candidate ⇒ reference by choosing \(T=0\), and a separate Lean countermodel proves reference ⇏ candidate.


```
lake env lean ../src/mass_action_time_bridge.lean
lake env lean ../src/mass_action_time_separation_witness.lean
```
clean.


#### E5-C

This sets up E5-C beautifully. We now combine the two opposing changes:

Reference-like permanence:

$$
\exists \varepsilon>0\;
\forall x_0>0\;
\exists T\ge0\;
\forall t\ge T,\;
P(\varepsilon,x_0,t)
$$

versus Lean-like trajectorywise bounds:

$$
\forall x_0>0\;
\exists \varepsilon>0\;
\forall t\ge0,\;
P(\varepsilon,x_0,t).
$$


```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_uniform_eventual_ref.lean \
  ../src/mass_action_pointwise_all_time_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T00:00:17Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_uniform_eventual_ref__vs__mass_action_pointwise_all_time_candidate
── mass_action_uniform_eventual_ref__vs__mass_action_pointwise_all_time_candidate
   verdict: Inconclusive   (230419 ms)
   ref ⇒ cand: not proved
      no proof found in 49 attempts
   cand ⇒ ref: not proved
      no proof found in 49 attempts
```

This is clean:
```
lake env lean ../src/mass_action_combined_separation_witnesses.lean
```

E5-C Eval: Inconclusive; neither implication proved in 49 attempts. Frozen prior was logical incomparability because the reference strengthens uniformity across initial states while the candidate strengthens temporal scope.

#### E5-D

Checked the pinned OpenAI comparator again. Its conclusion really does preserve these features: positive species-indexed initial concentrations; an $(\varepsilon\in(0,1))$; existence of a global forward solution; every global forward solution bounded for every $(t\ge0)$; and, for every species $(i)$,

$$
\varepsilon\le x_i(t)\le\varepsilon^{-1}.
$$

Crucially, $(\varepsilon)$ comes after $(x_0)$, and OpenAI's scope note explicitly says it may depend on the initial state.

For D, we preserve all of that conclusion structure, plus an explicit compatibility class, while abstracting only the internal reaction-network/ODE machinery.

Frozen E5-D prior
Because D retains the same crossed quantifiers as C, our prior remains:

$$
\boxed{\text{logically incomparable}}
$$

Reference wins on classwise uniformity:

$$
\exists\varepsilon\;\forall x_0\in C
$$

while candidate wins on temporal scope:

$$
\forall t\ge0
$$

instead of trajectory-dependent eventual entry.

```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_source_reduced_ref.lean \
  ../src/mass_action_source_reduced_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T02:28:43Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_source_reduced_ref__vs__mass_action_source_reduced_candidate
── mass_action_source_reduced_ref__vs__mass_action_source_reduced_candidate
   verdict: Inconclusive   (318375 ms)
   ref ⇒ cand: not proved
      no proof found in 67 attempts
   cand ⇒ ref: not proved
      no proof found in 67 attempts
```

Reduced source-shaped probe: Inconclusive. Neither direction proved. Because the fixture leaves trajectory regularity and positivity opaque, it preserves the logical incomparability of E5-C and is not yet treated as the final source-level relationship.


#### E5-D1

Rather than making another countermodel, I’d add precisely the fact we omitted:
A positive continuous trajectory that is eventually contained in a reciprocal box admits some trajectory-specific reciprocal box valid from time zero.

That is a real-analysis lemma, independent of reaction-network details.

Schematically:

$$
\begin{aligned}
&x:[0,\infty)\to(0,\infty)^d,\\
&x\text{ continuous},\\
&\exists T,\varepsilon_C>0:
  \forall t\ge T,\,
  \varepsilon_C\le x_i(t)\le\varepsilon_C^{-1}
\\[3pt]
&\qquad\Longrightarrow\\[3pt]
&\exists\delta>0:
  \forall t\ge0,\,
  \delta\le x_i(t)\le\delta^{-1}.
\end{aligned}
$$

If we kernel-prove that, it resolves the question we just uncovered: the “all-time” part of OpenAI's theorem is not actually stronger than permanence once positivity and continuity are restored; it is obtainable by absorbing the finite transient into an $(x_0)$-dependent constant.  Then the only substantive lost strength is the one you’d expect chemically:

$$
\boxed{\text{uniformity over the stoichiometric class}.}
$$


```
lake env lean ../src/mass_action_transient_bridge.lean
```

This is an important result.

E5-D1 now kernel-proves:

$$
\boxed{
\text{positive continuous trajectory}
+
\text{eventual reciprocal box}
\Rightarrow
\text{some trajectory-specific all-time reciprocal box}
}
$$

So the earlier E5-C incomparability really was caused by abstracting away physical/analytic structure. Once continuity and strict positivity return, the apparent temporal strengthening can be absorbed into the finite transient.

That changes the emerging E5 story:

- E5-A: $(\exists\varepsilon\,\forall x_0)$ is strictly stronger than $(\forall x_0\,\exists\varepsilon)$.
- E5-B: abstractly, all-time is stronger than eventual.
- E5-C/D: with no trajectory regularity, those opposing changes produce incomparability.
- E5-D1: for actual positive continuous trajectories, eventual $(\Rightarrow\)$ trajectory-specific all-time bounds, so the temporal opposition disappears.

Which suggests the source-level relationship may really be:

$$
\boxed{
\text{classwise permanence}
\Rightarrow
\text{OpenAI's trajectorywise bound}
}
$$

with the lost information concentrated in classwise uniformity, not temporal scope.  That is a much subtler and better conclusion than simply reading the quantifier surface.

The natural E5-D2 now is to lift D1 from one concentration coordinate to finitely many species and obtain one common $(\delta)$ for all $(i\in\mathrm{Fin}\,d)$:

$$
\exists\delta>0\;
\forall i,\forall t\ge0,\qquad
\delta\le x_i(t)\le\delta^{-1}.
$$

Because the species set is finite, we should be able to take the minimum of the finitely many coordinatewise $(\delta_i)$'s.


#### E5-D2

```
lake env lean ../src/mass_action_transient_bridge_fin.lean
```
clean.

D2 passes, and we have formally established the chemically relevant statement

$$
\begin{aligned}
&\forall i,\quad x_i(t)>0
\quad\text{and}\quad x_i \text{ continuous},\\
&\exists T,\varepsilon_C>0:\quad
t\ge T
\Rightarrow
\forall i,\;
\varepsilon_C\le x_i(t)\le\varepsilon_C^{-1}
\\
&\qquad\Longrightarrow\\
&\exists\delta(x_0)>0:\quad
\forall t\ge0,\forall i,\;
\delta(x_0)\le x_i(t)\le\delta(x_0)^{-1}.
\end{aligned}
$$


We now have the finite-species version of the transient bridge. So the apparent “eventual vs from $(t=0)$” mismatch really can be absorbed into a trajectory-specific \(\delta\) once we restore continuity, positivity, and finitely many species.

#### E5-E1

This is the scalar compact-set bridge.  This one is pleasantly direct because Mathlib has exactly the compactness fact we want: a continuous function that is strictly above $(0)$ on a compact set has a uniform positive lower bound.

We prove:

$$
K\subset(0,\infty),\quad K\text{ compact}
$$

implies

$$
\exists \varepsilon\in(0,1)\;
\forall x\in K,\qquad
\varepsilon\le x\le\varepsilon^{-1}.
$$

```
lake env lean ../src/mass_action_compact_scalar_bridge.lean
```

E5-E1 passed, we've formally connected the geometric language to the comparator-style language in one dimension:

$$
\boxed{
\text{compact + strictly positive}
\Rightarrow
\text{uniform positive lower and finite upper bounds}
}
$$

The nice part is that this proof doesn't even need $(K)$ to be explicitly nonempty; the compactness lemmas handle the vacuous empty-set case too.

#### E5-E2

```
lake env lean ../src/mass_action_compact_species_bridge.lean
```


We have the exact finite-dimensional geometric bridge we wanted:

$$
\boxed{
K\subset(\mathbb R_{>0})^d,\quad K\text{ compact}
\Rightarrow
\exists\varepsilon\in(0,1)\;
\forall x\in K,\forall i,\;
\varepsilon\le x_i\le\varepsilon^{-1}
}
$$

And the chain is formally getting very strong:

$$
\text{compact positive absorbing set}
\overset{\text{E5-E2}}{\Longrightarrow}
\text{uniform eventual reciprocal box}
$$

followed by

$$
\text{uniform eventual reciprocal box}
\overset{\text{E5-D2}}{\Longrightarrow}
\text{trajectory-specific all-time reciprocal box}.
$$

#### E5-F

```
lake env lean ../src/mass_action_final_composition_bridge.lean
```

The clean kernel check now gives us a formal composition:

$$
\boxed{
\text{headline-style classwise permanence}
\Rightarrow
\text{OpenAI-style trajectorywise all-time bounds}
}
$$

provided the ordinary dynamical background assumptions we made explicit hold: forward continuity, positivity, uniqueness, and compatibility-class membership.

And that changes the interpretation of the whole experiment in an important way.

At first, the surface quantifiers suggested two competing differences:

$$
\text{uniform but eventual}
\quad\text{vs}\quad
\text{pointwise but all-time}.
$$

Our abstract E5-C really was incomparable. But once we restored the analytic structure of positive continuous mass-action trajectories, the temporal difference collapsed:

$$
\text{eventual common box}
\Rightarrow
\text{trajectory-specific all-time box}.
$$

So the substantive loss is the uniformity:

$$
\exists\varepsilon_C\,\forall x_0\in C
$$

becomes

$$
\forall x_0\in C\,\exists\varepsilon(x_0).
$$

That is exactly the kind of thing a superficial logical comparison could misdiagnose.

E5-F is a source-faithful reduced composition theorem, not yet literally a theorem about every definition in OpenAI’s full MassAction.lean. We explicitly stated the dynamical properties we needed rather than deriving all of them from OpenAI’s ODE implementation.

#### E5 Summary

The important thing is to distinguish what SemantEq reported on the reduced E5 probes from what we ultimately proved mathematically.  For the source-shaped E5-D comparison, SemantEq itself said:

$$
\texttt{Inconclusive}
$$

with

$$
\text{ref}\to\text{cand}: \text{not proved}
$$

and

$$
\text{cand}\to\text{ref}: \text{not proved}.
$$

But that was not the final mathematical relationship.  After restoring the structure that the reduced fixture had hidden — positivity, continuity, finite species, compactness, and forward uniqueness — E5-F gave us a clean Lean proof of:

$$
\boxed{\text{reference}\to\text{candidate}}
$$

So SemantEq missed that implication in the reduced comparison.

The reverse direction is different. The candidate only gives an \(x_0\)-dependent bound:

$$
\forall x_0\,\exists \varepsilon(x_0),
$$

while the reference claims classwise uniformity:

$$
\exists\varepsilon_C\,\forall x_0\in C.
$$

Our E5-A separation witness proved that the pointwise form does not logically recover the uniform form in general.

So the best current summary is:

$$
\boxed{\text{ref}\to\text{cand}}
$$

is formally established by E5-F, while

$$
\boxed{\text{cand}\to\text{ref}}
$$

is not supported, and the controlled uniformity counterexample shows why it cannot follow merely from the comparator's pointwise-bound structure.

One precision point: we have not constructed an actual mass-action reaction network satisfying OpenAI's comparator theorem while violating permanence. So we  shouldn't yet write the strongest possible source-level claim

$$
\text{cand}\nrightarrow\text{ref}
$$

as a theorem specifically about genuine mass-action systems. What we have proved is that the logical information present in the candidate is insufficient to recover classwise uniformity.

So E5 summary is:

$$
\boxed{
\text{SemantEq D: neither direction discovered}
}
$$

but our audit subsequently found

$$
\boxed{
\text{Reference}\Rightarrow\text{Candidate}
}
$$

and identified loss of classwise uniformity as the remaining reason the candidate should be regarded as weaker.


| Probe | Finding |
|---|---|
| E5-A | Loss of classwise uniformity is a genuine weakening |
| E5-B | Abstract all-time is stronger than eventual; SemantEq missed the easy implication |
| E5-C | With dynamics abstracted away, combined statements are genuinely incomparable |
| E5-D | Source-shaped but opaque dynamics still look incomparable |
| E5-D1/D2 | Positivity + continuity + finite species eliminate the temporal conflict |
| E5-E1/E2 | Compact positive absorbing set gives a common reciprocal concentration box |
| E5-F | Full reduced composition proves headline-style permanence ⇒ comparator-style bound |



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
