# E3. Ordinary Elliott: two encodings of uniform nonpretentiousness


**Prior expectation:** Probably equivalent, but not syntactically obvious.

## References

- [OpenAI formalization scope: ordinary two-point correlations and the corrected Elliott conjecture](https://github.com/openai/math/blob/main/lean/docs/007.md)
- [OpenAI Comparator: `OrdinaryElliott.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/OrdinaryElliott.lean)

- [Wikepedia Background Multiplicative Function](https://en.wikipedia.org/wiki/Multiplicative_function)
- [Wikepedia Background Analytic Number Theory](https://en.wikipedia.org/wiki/Analytic_number_theory)
- [Terence Tao's Intro](https://terrytao.wordpress.com/2015/09/11/the-erdos-discrepancy-problem-via-the-elliott-conjecture/)

## Experiment

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

## Results



### E3 Ordinary Elliott: uniform nonpretentiousness

First run the raw source-form comparison with the prior expectation frozen before the 
result is observed:

```bash
lake exe semanteq --strict --timeout 0 \
  ../src/elliott_infimum_ref.lean \
  ../src/elliott_threshold_candidate.lean
```

For an archival machine-readable record, rerun with `--raw` and redirect stdout:

```bash
lake exe semanteq --strict --timeout 0 --raw \
  ../src/elliott_infimum_ref.lean \
  ../src/elliott_threshold_candidate.lean \
  > ../results/elliott_raw.json
```

Do not add hand-written bridge lemmas before recording this baseline result. If the raw
comparison is inconclusive, preserve that result and proceed to factored probes rather
than treating search failure as non-equivalence.

### E3-A

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

