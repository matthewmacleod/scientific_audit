# E7. Irrationality exponent of $\pi$: two characterizations of exponent two

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


