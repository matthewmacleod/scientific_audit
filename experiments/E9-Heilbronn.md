# E9. Heilbronn triangle problem: eventual versus subsequential asymptotics

**Prior expectation:** The eventual statement is stronger than an unbounded-subsequence construction.

## References

- [OpenAI formalization scope: a power improvement in the Heilbronn triangle lower bound](https://github.com/openai/math/blob/main/lean/docs/191.md)
- [OpenAI Comparator: `HeilbronnTriangle.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/HeilbronnTriangle.lean)


## Background

It’s a result about arranging points in a square so that even the smallest triangle formed by any three points is as large as possible.

Let H(n) be the largest possible area of the smallest triangle among n points in the unit square. The OpenAI result constructs point sets, for infinitely many increasingly large values of n, where every triangle has area at least n−2+η for some fixed η>0. Because this is larger than n−2 for large n, it gives a power improvement over the older scale. 

“Subsequential” means the result holds for an unbounded sequence of values of n, not necessarily every sufficiently large n. The accompanying paper states a stronger “eventual” result—one that holds for all large enough n—while the Lean formalization covers the subsequence version.


## Experiment

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

## Results


E9-A — provenance / target alignment
Record this without a SemantEq verdict:
The paper headline establishes a power-improved construction for every sufficiently large size \(n\). The selected Lean formalization establishes the construction only along an unbounded sequence \(n_j\to\infty\). OpenAI’s own formalization scope explicitly identifies the paper statement as broader. This is a formalization-scope difference, not evidence that the formalized subsequence theorem is incorrect.

Then E9-B should isolate exactly that quantifier-strength difference before touching Heilbronn geometry.

### E9-B

E9-B — eventual all sizes vs unbounded subsequence

Frozen prior:

$$
\boxed{
\text{EventuallyAllSizes}\Rightarrow\text{UnboundedSubsequence}
}
$$

but not conversely.

```
lake exe semanteq --strict --timeout 0 \
  ../src/heilbronn_eventual_all_ref.lean \
  ../src/heilbronn_unbounded_subsequence_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T03:26:35Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing heilbronn_eventual_all_ref__vs__heilbronn_unbounded_subsequence_candidate
── heilbronn_eventual_all_ref__vs__heilbronn_unbounded_subsequence_candidate
   verdict: Inconclusive   (66104 ms)
   ref ⇒ cand: not proved
      no proof found in 35 attempts
   cand ⇒ ref: not proved
      no proof found in 35 attempts
```

E9-B1: prove the forward implication
The frozen prior was:

$$
\text{EventuallyAllSizes}\Rightarrow\text{UnboundedSubsequence}.
$$

This should be purely structural: choose \(n_j=N+j\).

```
lake env lean ../src/heilbronn_scope_bridge.lean
```

```
lake env lean ../src/heilbronn_scope_separation_witness.lean
```

E9-B is fully classified:
\[
\boxed{
\text{EventuallyAllSizes}
\Rightarrow
\text{UnboundedSubsequence},
\qquad
\text{UnboundedSubsequence}
\nRightarrow
\text{EventuallyAllSizes}
}
\]
while SemantEq returned Inconclusive both ways.

So this is another case where Inconclusive hides a strict implication, and the missed forward direction is mostly structural witness synthesis: construct \(n_j=N+j\) and prove it tends to infinity.

That also makes the provenance result sharper: OpenAI’s Lean target is genuinely weaker in its size quantifier than the broader “all sufficiently large \(n\)” headline.

### E9-C

The pinned comparator makes E9-C quite crisp. Its first theorem gives a positive power improvement along an unbounded subsequence, while its second theorem concludes

$$
0<\eta/2
\quad\text{and}\quad
\neg\operatorname{eventualAlmostUpperBound}(\eta/2).
$$

That is exactly the substantive implication we want to isolate.

Frozen prior
Only:

$$
\boxed{\text{ref}\Rightarrow\text{cand}}
$$

The actual reasoning is:

$$
n_j^{-2+\eta}
\le a_j
\le
C n_j^{-2+\eta/2}.
$$

For positive \(n_j\), cancellation of the common \(n_j^{-2}\) behavior gives essentially

$$
n_j^{\eta/2}\le C.
$$

But

$$
n_j\to\infty,\qquad \eta/2>0
$$

implies

$$
n_j^{\eta/2}\to\infty,
$$

so eventually $(n_j^{\eta/2}>C)$, contradiction.

That mirrors why OpenAI can derive the refutation theorem from the power-improved construction: the comparator defines eventualAlmostUpperBound ε as a universal $(C n^{-2+\epsilon})$ upper bound for every sufficiently large configuration, while the first theorem produces configurations with minimum triangle area $(n^{-2+\eta})$ along $(n_j\to\infty)$.

```
lake exe semanteq --strict --timeout 0 \
  ../src/heilbronn_power_subsequence_ref.lean \
  ../src/heilbronn_almost_upper_refuted_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T03:36:40Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing heilbronn_power_subsequence_ref__vs__heilbronn_almost_upper_refuted_candidate
── heilbronn_power_subsequence_ref__vs__heilbronn_almost_upper_refuted_candidate
   verdict: Inconclusive   (270915 ms)
   ref ⇒ cand: not proved
      no proof found in 73 attempts
   cand ⇒ ref: not proved
      no proof found in 73 attempts
```

E9-C is now:

$$
\boxed{\text{SemantEq: Inconclusive}}
$$

with 73/73 failed attempts in each direction. Now let’s prove only the frozen direction independently.

The clean route is exactly the asymptotic contradiction we anticipated. Mathlib has the theorem that $(x^\alpha\to\infty)$ as $(x\to\infty)$ whenever $(\alpha>0)$, so we can compose that with \(n_j\to\infty\). Lean Community


E9-C independent bridge

```
lake env lean ../src/heilbronn_asymptotic_bridge.lean
```

E9-C is closed:

$$
\boxed{
\text{SemantEq: Inconclusive}
\qquad
\text{Lean: ref}\Rightarrow\text{cand}
}
$$

And the classification is nicely different from E9-B:

- E9-B: structural witness synthesis

$$
  \text{eventually all sizes}\Rightarrow\text{unbounded subsequence}
$$ 

- E9-C: substantive asymptotic reasoning

$$
  n_j^{-2+\delta}\ \text{along }n_j\to\infty
  \Rightarrow
  \neg O(n^{-2+\delta/2})
$$ 

So E9 is shaping up beautifully as another internal difficulty contrast.


### E9-D

Check pinned source

```
# From scientific_audit/SemantEq/

mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/HeilbronnTriangle.lean \
  -o audit_vendor/ComparatorChallenges/HeilbronnTriangle.lean

shasum -a 256 \
  audit_vendor/ComparatorChallenges/HeilbronnTriangle.lean

ROOT="$(pwd)"

lake env lean \
  -o "$ROOT/audit_vendor/ComparatorChallenges/HeilbronnTriangle.olean" \
  "$ROOT/audit_vendor/ComparatorChallenges/HeilbronnTriangle.lean"
```


```
ROOT="$(pwd)"
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"

lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/heilbronn_source_fidelity.lean"
```

E9-D establishes directly against the pinned source:

$$
\boxed{
\begin{aligned}
&\text{formalized construction is along }n_j\to\infty,\\
&\text{not a construction for every sufficiently large }n,\\
&\text{and the comparator separately states the }
\eta/2\text{ upper-bound refutation.}
\end{aligned}
}
$$

The source is explicit about all three pieces: Tendsto n atTop atTop, the per-\(j\) configuration, and ¬ eventualAlmostUpperBound (heilbronnExponent / 2).


### Summary

- E9-A: provenance/scope mismatch identified.
- E9-B: “all sufficiently large sizes” strictly stronger than “unbounded subsequence”; SemantEq Inconclusive, Lean bridge + counterexample clean.
- E9-C: subsequence power improvement refutes the weaker eventual $(n^{-2+\delta/2})$ upper bound; SemantEq Inconclusive, independent asymptotic bridge clean.
- E9-D: exact pinned OpenAI comparator confirms both source claims.
That’s another very solid case, and importantly it separates structural quantifier weakening from substantive asymptotic reasoning within the same scientific result.


