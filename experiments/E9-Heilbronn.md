# E9. Heilbronn triangle problem: eventual versus subsequential asymptotics

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

