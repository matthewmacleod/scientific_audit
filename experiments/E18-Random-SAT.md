# E18. Random 3-SAT hitting-time variance: linear versus n log n

**Prior expectation:** The current Result 235 family claim is stronger at
k=3 than the selected Lean variance theorem. The family claims
Theta(n) hitting-time variance for every fixed k >= 3, while the selected
formalization gives a positive linear lower bound but only an O(n log n)
upper bound for k=3. We expect a quantitative-strength mismatch at k=3,
while the formalized statement should remain faithful to the earlier
variance result it actually targets.

## References

- [OpenAI Result 235: Random-SAT thresholds, sharp variance and computability](https://lance.fortnow.com/openai-math-tcs.htm#f235)
- [OpenAI formalization scope: `235.md`](https://github.com/openai/math/blob/main/lean/docs/235.md)
- [OpenAI Comparator: `SATVariance.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SATVariance.lean)
- [OpenAI Comparator configuration: `SATVariance.json`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SATVariance.json)
- [OpenAI implementation: `OAI/Probability/SATVariance/Main.lean`](https://github.com/openai/math/blob/main/lean/OAI/Probability/SATVariance/Main.lean)

## Background

Let H_n be the first prefix length at which a random k-SAT instance becomes
unsatisfiable.

The current OpenAI Result 235 family states that, for every fixed k >= 3,

$$
Var(H_n)=Theta_k(n).
$$

For k=3 this means both an eventual positive linear lower bound and an
eventual linear upper bound.

The result family now links a separate paper, *Linear Variance of the
Random 3-SAT Hitting Time*, which sharpens the earlier k=3 upper bound to
Theta(n).

The Lean scope, however, describes a different formal boundary. It says:

- for every fixed k >= 4, the formalization proves Theta_k(n);
- for k=3, it proves a positive linear lower bound and an O(n log n)
  upper bound;
- the linked sharpness supplements do not establish that the logarithmic
  factor is necessary.

The selected comparator theorem is `OAI.RandomKSAT.variance_main`.

Its upper bound uses

$$
ell(k,n)=
\begin{cases}
\log(e n), & k=3,\\
1, & k\ne3.
\end{cases}
$$

Thus at k=3 the selected theorem gives

$$
Var(H_n)\le C n\log(en),
$$

together with an eventual lower bound

$$
c n\le Var(H_n).
$$

The current family headline instead asserts the sharper

$$
c n\le Var(H_n)\le C n.
$$

E18 therefore tests a quantitative-strength boundary rather than a
disagreement about the underlying random-SAT model.

## Experiment

### E18-A — family claim versus selected formalization scope

Decompose the variance claim by clause size.

For fixed k >= 4:

$$
Var(H_n)=Theta_k(n)
$$

is directly represented by the selected Lean theorem, because `ell k n = 1`.

For k=3, the current family claim is:

$$
Var(H_n)=Theta(n),
$$

while the selected Lean theorem yields only:

$$
Omega(n)\le Var(H_n)\le O(n\log n).
$$

Accordingly:

- **k >= 4:** `TARGETED_AT_HEADLINE_STRENGTH`
- **k = 3 lower bound:** `TARGETED`
- **k = 3 O(n log n) upper bound:** `TARGETED`
- **k = 3 linear upper bound:** `NOT_IN_SELECTED_VARIANCE_TARGET`

The stronger k=3 statement is supported by a later companion paper in the
result family, but it is not the statement selected by `SATVariance.json`.

**Expected classification:** `QuantitativeStrengthMismatch`

This is a source-to-artifact scope result. It does not imply that
`variance_main` is mathematically defective: the theorem faithfully states
the weaker k=3 bounds documented in the Lean scope.


### E18-A results

The current Result 235 family states

$$
Var(H_n)=\Theta_k(n)
$$

for every fixed $(k\ge3)$, and now includes the separate paper
*Linear Variance of the Random 3-SAT Hitting Time*.

The pinned Lean scope has a different boundary:

- for fixed $(k\ge4)$: $(\Theta_k(n))$;
- for $(k=3)$: a positive linear lower bound and an $(O(n\log n))$
  upper bound.

`SATVariance.json` selects only `OAI.RandomKSAT.variance_main`.

The selected theorem has upper bound

$$
Var(H_n)\le Cn\,\ell(k,n),
$$

where

$$
\ell(3,n)=\log(en),
$$

together with an eventual positive linear lower bound.

A search of the pinned SATVariance implementation and comparator tree found
no separate theorem implementing the later linear $(k=3)$ upper bound.

Thus:

- current family \(k=3\) claim: `Theta(n)`
- selected Lean \(k=3\) target: `Omega(n)` and `O(n log n)`
- later linear \(k=3\) upper bound: `NOT_IN_SELECTED_VARIANCE_TARGET`

**Classification:** `QuantitativeStrengthMismatch`

This does not indicate an error in `variance_main`. The selected theorem
faithfully expresses the earlier variance result documented by the Lean
scope. The mismatch arises because the current result family has been
strengthened by a later companion result without a corresponding change
to the selected variance formalization.

### Results
### E18-B — directional strength audit

SemantEq compared the current headline-strength reference against the
weaker selected-formalization strength.

It returned:

```text
verdict: Inconclusive
ref ⇒ cand: not proved
  no proof found in 13 attempts
cand ⇒ ref: not proved
  no proof found in 13 attempts
```

The SemantEq result alone does not establish either non-entailment.
Independent forward bridge
An independent Lean bridge proved:

$$
R \Rightarrow C.
$$

The proof uses the fact that, eventually, the multiplicative logarithmic
factor is at least one. Hence an eventual linear upper bound

$$
V(x)\le Cx
$$

implies the weaker bound

$$
V(x)\le CxL(x).
$$

SATVarianceStrengthBridge.ref_implies_candidate kernel-checks with
axioms:
[propext, Classical.choice, Quot.sound,
 LogFactor, Variance, logFactor_ge_one]

and no sorryAx.

Thus SemantEq's failure on ref ⇒ cand is a proof-search false negative.
Countermodel to the reverse implication
To determine whether the reverse implication is merely difficult or
actually false, we constructed the concrete model

$$
V(x)=x^2,
\qquad
L(x)=x.
$$

For every \(x\ge1\),

$$
x\le x^2
$$

and

$$
x^2=xL(x),
$$

so the candidate statement holds.

However, there is no eventual constant $(C)$ satisfying

$$
x^2\le Cx.
$$

For any proposed $(C)$ and threshold $(N)$, choosing

$$
x\ge\max(N,C+1)
$$

violates the linear upper bound.


Lean kernel-checked:
- SATVarianceStrengthCountermodel.candidate_holds
- SATVarianceStrengthCountermodel.ref_fails
- SATVarianceStrengthCountermodel.candidate_does_not_imply_ref
with axioms:
[propext, Classical.choice, Quot.sound]

and no sorryAx.

Therefore:

$$
\boxed{R\Rightarrow C}
$$

but

$$
\boxed{C\nRightarrow R}.
$$

The selected-formalization strength is strictly weaker than the current
headline-strength claim.

E18-B classification: StrictlyWeakerCandidate

The SemantEq Inconclusive result contains two semantically different
failures:
- ref ⇒ cand: valid, but missed by proof search;
- cand ⇒ ref: genuinely invalid, established by an explicit
  kernel-checked countermodel.
Artifacts:
- src/sat_variance_strength_ref.lean
- src/sat_variance_strength_candidate.lean
- src/sat_variance_strength_bridge.lean
- src/sat_variance_strength_countermodel.lean
- results/E18-B.json
- results/E18-B-forward-bridge.txt
- results/E18-B-countermodel.txt
