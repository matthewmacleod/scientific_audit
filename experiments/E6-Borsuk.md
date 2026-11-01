# E6. Borsuk dimension nine: ambient representation invariance

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

