# E7. Irrationality exponent of $\pi$: two characterizations of exponent two


**Prior expectation:** Probably equivalent given the standard background facts encoded by the development.

## References

- [OpenAI formalization scope: the irrationality exponent of $\pi$ is 2](https://github.com/openai/math/blob/main/lean/docs/017.md)
- [OpenAI Comparator: `PiExponent.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/PiExponent.lean)
- [OpenAI Lean implementation: `PiExponent/Main.lean`](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/PiExponent/Main.lean)
- [OpenAI paper: The irrationality exponent of pi is 2](https://github.com/openai/math/tree/main/preprints/The-irrationality-exponent-of-pi-is-2-September-24-2026)

## Background


It’s a claim about how closely rational numbers can approximate $\pi$. The irrationality exponent $\mu(\pi)$ is the supremum of the powers $\nu$ for which

$$0 < \left|\pi - \frac{p}{q}\right| < \frac{1}{q^{\nu}}$$

has infinitely many rational solutions $p/q$.

The claimed result is that $\pi$’s exponent is exactly $2$. In practical terms:

For every $\varepsilon > 0$, only finitely many fractions approximate $\pi$ more closely than $1/q^{2+\varepsilon}$. That is, $\left|\pi - \frac{p}{q}\right| \geq \frac{1}{q^{2+\varepsilon}}$ for all but finitely many $p/q$.
Yet $\pi$ has infinitely many rational approximations at the $1/q^2$ scale, which holds for every irrational number by Dirichlet’s theorem.

So this is about ruling out infinitely many exceptionally accurate approximations, not about saying no individual fraction can be remarkably close. The “two characterizations” are two equivalent ways of stating that $\mu(\pi) = 2$.


The claim is plausible, but the gap is large. Almost every real number has irrationality exponent $2$, and $\mu(\pi) = 2$ has long been the conjectured value. But the best published upper bounds were nowhere near that, in the range of $7$ to $8$. Going from there to exactly $2$ would be a leap, not an incremental improvement. It would be a bigger deal than the result looks at first glance, because no transcendental number’s exponent was previously known to be pinned down this way for something as natural as $\pi$.

It’s worth taking seriously, with verification pending. Wikipedia currently labels it an unverified proof, and that’s the right stance. A claim like this stands or falls on whether experts in Diophantine approximation can check every step. Until then I’d treat it as promising, not settled.

The consequences are concrete. One result I came across in the search: the Flint Hills series $\sum \frac{1}{n^3 \sin^2 n}$ converges if $\mu(\pi) \leq 5/2$. So if the proof holds, that long-open convergence question gets resolved too.


## Experiment

Split the selected theorem into its two mathematical characterizations and audit them against one another.

One formulation gives eventual lower bounds: for every $\nu>2$, sufficiently large denominators satisfy

$$
\left|\pi-\frac pq\right|\ge q^{-\nu}.
$$

The other defines the irrationality exponent through a supremum over exponents admitting infinitely many sufficiently good rational approximations and states that this supremum equals $2$.

The experiment asks whether SemantEq can recover the equivalence between these substantially different descriptions under the exact assumptions and definitions available in the formal development.

## Results

### E7-A


```
 lake exe semanteq --strict --timeout 0 \
  ../src/pi_eventual_nat_ref.lean \
  ../src/pi_eventual_int_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T20:03:36Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing pi_eventual_nat_ref__vs__pi_eventual_int_candidate
── pi_eventual_nat_ref__vs__pi_eventual_int_candidate
   verdict: Inconclusive   (596853 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```


SemantEq again gives us an epistemically neutral Inconclusive, despite OpenAI already treating the two denominator formulations as equivalent.

This is particularly interesting because OpenAI’s own formalization explicitly uses eventualLowerBound_iff_integer Real.pi to convert the natural-denominator statement into the integer-denominator one.

### E7-B

This one is useful as a sanity/control case because there should be no number theory at all in the relationship. OpenAI defines

$$
\mu(x)
=
\sup\{\nu>0:\text{infinitely many sufficiently good rational approximations}\},
$$

and the candidate simply writes that definition out longhand. GitHub

```
lake exe semanteq --strict --timeout 0 \
  ../src/pi_irrationality_named_ref.lean \
  ../src/pi_irrationality_expanded_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T20:34:21Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing pi_irrationality_named_ref__vs__pi_irrationality_expanded_candidate
── pi_irrationality_named_ref__vs__pi_irrationality_expanded_candidate
   verdict: ExactMatch   (518 ms)
   identical statements, no implication proof needed
```

$$
\text{E7-B: exact definitional identity, recognized immediately}.
$$

### E7-C

$$
\text{eventual lower bound for }\pi
\quad\Longrightarrow\quad
\mu(\pi)=2.
$$

```
lake exe semanteq --strict --timeout 0 \
  ../src/pi_eventual_lower_bound_ref.lean \
  ../src/pi_exponent_sup_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T22:25:14Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing pi_eventual_lower_bound_ref__vs__pi_exponent_sup_candidate
── pi_eventual_lower_bound_ref__vs__pi_exponent_sup_candidate
   verdict: Inconclusive   (239384 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```

E7-C gives us:

$$
\boxed{\text{SemantEq: Inconclusive}}
$$

with 87/87 failures in both directions after about 239 s.

We would not classify this alongside E7-A as something SemantEq obviously ought to normalize. The actual OpenAI bridge contains real mathematics. Their proof proceeds by showing $(2)$ itself is an admissible approximation exponent for irrational numbers, proving that the eventual lower bound makes the good-approximation set finite for every $(\nu>2)$, excluding every exponent above $(2)$, and finally sandwiching the supremum. The specialization to $(\pi)$ uses irrational_pi.

We will dissect C before doing the final bridge:

$$
\begin{array}{ll}
\textbf{C1:}&
\text{EventualLowerBound}(x),\ \nu>2
\Rightarrow
\text{GoodRationalApproximations}(x,\nu)\text{ finite}\\[3pt]
\textbf{C2:}&
x\text{ irrational}
\Rightarrow
2\in\text{ApproximationExponents}(x)\\[3pt]
\textbf{C3:}&
\text{C1+C2}
\Rightarrow
\sup\text{ApproximationExponents}(x)=2.
\end{array}
$$

Then specialize \(x=\pi\).


```
lake env lean ../src/pi_exponent_supremum_bridge.lean
```

This decomposition is stronger than simply saying “we manually proved ref ⇒ cand.” We can say why SemantEq did not discover it:

$$
\text{Diophantine finiteness}
+\text{ irrational approximation}
+\text{ supremum reasoning}.
$$

That is Tier 2 substantive mathematics, not a missing cast normalization or existential-witness heuristic.



```
lake env lean ../src/pi_exponent_components_bridge.lean
```
clean.


E7-C is now independently decomposed and kernel-checked all the way through:

$$
\text{irrationality}
\Rightarrow
2\in A_x
$$

$$
\text{EventualLowerBound}
\Rightarrow
\forall \nu>2,\; G_{x,\nu}\text{ finite}
$$

$$
\Rightarrow
A_x\subseteq(-\infty,2]
$$

$$
\Rightarrow
\sup A_x=2.
$$

So E7-C is firmly:

$$
\boxed{
\text{SemantEq: Inconclusive}
\qquad
\text{Lean: ref}\Rightarrow\text{cand}
}
$$


## E7-D

```
mkdir -p ../src/OAI/NumberTheory/PiExponent

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/NumberTheory/PiExponent/Statement.lean \
  -o ../src/OAI/NumberTheory/PiExponent/Statement.lean
```

```
mkdir -p audit_vendor/OAI/NumberTheory/PiExponent

cp ../src/OAI/NumberTheory/PiExponent/Statement.lean \
  audit_vendor/OAI/NumberTheory/PiExponent/Statement.lean

lake env lean \
  -o audit_vendor/OAI/NumberTheory/PiExponent/Statement.olean \
  audit_vendor/OAI/NumberTheory/PiExponent/Statement.lean
```


then

```
lake env bash -c '
  export LEAN_PATH="audit_vendor:${LEAN_PATH:-}"
  lean ../src/pi_source_statement_fidelity.lean
'
```

Clean.

We now have a really strong case structure:
- E7-A: $(\mathbb N)i$-denominator vs positive-$(\mathbb Z)$-denominator formulation
  SemantEq: Inconclusive
  Lean: equivalent via explicit representation transport
- E7-B: named irrationality exponent vs expanded sSup form
  SemantEq: ExactMatch
- E7-C: eventual lower bound $(\Rightarrow \mu(\pi)=2)$
  SemantEq: Inconclusive
  Lean: independently proved by decomposing the real mathematical steps
- E7-D: actual pinned OpenAI source statement fidelity
  Lean: clean against the vendored exact Statement.lean





