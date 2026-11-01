# E12. Hyperbolicity cones: spectrahedrality versus semidefinite lifts

**Status:** Planned.

**Prior expectation:** Nonexistence of any semidefinite lift is stronger than nonspectrahedrality in the original coordinates.

### References

- [OpenAI formalization scope: hyperbolicity cones without semidefinite lifts](https://github.com/openai/math/blob/main/lean/docs/095.md)
- [OpenAI Comparator: `HyperbolicCones.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/HyperbolicCones.lean)

### Experiment

Distinguish two notions of semidefinite representability:

1. being spectrahedral in the original coordinates; and
2. being a spectrahedral shadow, equivalently admitting a finite semidefinite lift with auxiliary variables.

Schematically,

$$
\neg\operatorname{SemidefiniteLift}(C)
\Longrightarrow
\neg\operatorname{Spectrahedral}(C),
$$

but a nonspectrahedral set may still admit a semidefinite lift.

The audit should determine exactly which representation notion is asserted by the candidate theorem and whether the stronger no-lift claim follows.

Care is required to preserve witness identity: a companion result may construct a semidefinite lift for a particular explicit cone, so we must not conflate distinct cones or distinct claims within the family.

### Results


