# E10. Stable coordinate: predicate form versus expanded witness form

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


