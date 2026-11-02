# E13. Uniform rectifiability and big pieces of Lipschitz images


**Prior expectation:** Mathematically expected to correspond under the standard characterization used by the formalization; SemantEq success is uncertain because the bridge contains substantive geometry.

## References

- [OpenAI paper: Riesz transforms and uniform rectifiability in higher codimension](https://github.com/openai/math/tree/main/preprints/Riesz-transforms-and-uniform-rectifiability-in-higher-codimension-September-24-2026)
- [OpenAI Comparator: `RieszQuantitative.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/RieszQuantitative.lean)

## Background

This concerns a theorem connecting an analytic test for a measure with the geometric shape of the set carrying that measure.

A set is uniformly rectifiable if, at every location and scale, it contains a substantial piece that looks like a Lipschitz image of flat  n-dimensional space. “Big pieces” means that piece has a fixed positive fraction of the measure in the ball; “uniform” means the fraction and the Lipschitz bound work consistently across locations and scales.

The result says that in the higher-codimension range d≥4 , 2≤n≤d−2 , an n-dimensional measure with the expected ball-growth and a uniformly L2-bounded n-dimensional Riesz transform must be uniformly rectifiable. In plain terms: if this singular-integral operator behaves stably at every truncation scale, the underlying measure cannot be geometrically too wild—it must contain quantitatively large, well-behaved Lipschitz pieces. The Lean note says it formalizes this implication; a related variation and principal-value result is outside that formalization.

## Experiment

Compare a conclusion phrased as uniform $n$-rectifiability with a conclusion phrased through uniform big pieces of Lipschitz images (BPLI), under the Ahlfors-David regularity and quantitative hypotheses in the formal development.

The purpose is to test a positive equivalence whose bridge is itself mathematically meaningful rather than merely syntactic or definitional.

A SemantEq failure here would not by itself establish non-equivalence. It may instead show that the equivalence requires background mathematics outside the system's permitted transformation set.

E13 looks like a positive-fidelity case at first inspection, and the most interesting thing to audit is the uniformity of the quantitative constants.

OpenAI’s headline says that in higher codimension, an $(n)$-AD-regular measure with uniformly $(L^2)$-bounded hard-truncated Riesz transforms is uniformly $(n)$-rectifiable, with quantitative bounds depending only on the dimensions, AD constant, and operator bound. 




## Results


### E13-A

```
lake exe semanteq --strict --timeout 0 \
  ../src/riesz_uniform_bpli_ref.lean \
  ../src/riesz_pointwise_bpli_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T15:53:05Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing riesz_uniform_bpli_ref__vs__riesz_pointwise_bpli_candidate
── riesz_uniform_bpli_ref__vs__riesz_pointwise_bpli_candidate
   verdict: LikelyTooWeak   (111075 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.RieszUniformityAudit.riesz_uniform_bpli_ref, <structural>]
      proof:  fun μ a =>
                Exists.casesOn SemantEqRef.RieszUniformityAudit.riesz_uniform_bpli_ref fun w h =>
                  And.casesOn h fun left right => Exists.casesOn right fun w_1 h => Exists.intro w ⟨left, Exists.intro w_1 (h μ a)⟩
   cand ⇒ ref: not proved
      no proof found in 9 attempts

```

E13-A is another case where SemantEq got the relation exactly right:

$$
\boxed{\texttt{LikelyTooWeak}}
$$

with

$$
\exists \theta,M\,\forall\mu
\;\Longrightarrow\;
\forall\mu\,\exists \theta,M
$$

proved structurally, and no reverse proof found.

The generated proof is exactly what we expected: extract the single class-uniform \(\theta,M\), then reuse them for each individual \(\mu\).


####= E13-A1,A2

```
lake env lean ../src/riesz_uniformity_bridge.lean
```

```
lake env lean ../src/riesz_uniformity_separation_witness.lean
```

E13-A is fully classified:

\[
\boxed{
\text{uniform BPLI constants}
\Rightarrow
\text{measurewise BPLI constants},
\qquad
\text{not conversely}.
}
\]

And unlike many earlier cases, SemantEq recognized the strict weakening correctly.

That is especially important scientifically because the uniformity is not cosmetic: the headline is quantitative. Losing

\[
\exists(\theta,M)\,\forall\mu
\]

to

\[
\forall\mu\,\exists(\theta_\mu,M_\mu)
\]

would lose exactly the class-level quantitative control the theorem advertises.

### E13-B

That makes E13-B much more meaningful: we test the actual pinned statement, especially the part that could easily have been weakened accidentally.

The comparator defines

\[
\forall d,n,C_{\rm AD},C_R\;
\exists\theta>0,\exists M\;
\forall\mu,\; \cdots
\]

so the constants are selected before the measure. GitHub The full Lean proof has the same architecture: it constructs the budgets and \(M\), refines the global \(\theta,M\) witnesses, and only then does intro μ.


````
mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/RieszQuantitative.lean \
  -o audit_vendor/ComparatorChallenges/RieszQuantitative.lean

shasum -a 256 \
  audit_vendor/ComparatorChallenges/RieszQuantitative.lean

ROOT="$(pwd)"

lake env lean \
  -o "$ROOT/audit_vendor/ComparatorChallenges/RieszQuantitative.olean" \
  "$ROOT/audit_vendor/ComparatorChallenges/RieszQuantitative.lean"
````

```
ROOT="$(pwd)"
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"

lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/riesz_source_fidelity.lean"
```

strong positive-fidelity finding:

$$
\boxed{
\forall(d,n,C_{\rm AD},C_R)\;
\exists(\theta,M)\;
\forall\mu
}
$$

rather than the weaker

$$
\forall(d,n,C_{\rm AD},C_R,\mu)\;
\exists(\theta_\mu,M_\mu).
$$


That matters because OpenAI’s public headline explicitly says the rectifiability bounds depend only on dimension, regularity, and operator bounds.

### Conclusions

- E13-A: uniform class-level BPLI constants vs measure-dependent constants
  SemantEq: LikelyTooWeak
  Independent Lean: strict implication confirmed

- E13-B: exact pinned-source fidelity
  The comparator preserves the crucial quantifier order

$$
  \forall(d,n,C_{\rm AD},C_R)\;\exists(\theta,M)\;\forall\mu,
$$

The advertised quantitative dependence is genuinely retained That is a very nice scientific result because the uniformity is the theorem. If the constants had moved inside the \(\mu\)-quantifier, much of the advertised quantitative content would have disappeared.


