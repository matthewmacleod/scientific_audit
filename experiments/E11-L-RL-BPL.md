# E11. $\mathsf L=\mathsf{RL}=\mathsf{BPL}$: equality normalization

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


