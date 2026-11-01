# E8. Weak mixing versus ergodicity

**Status:** Planned.

**Prior expectation:** Weak mixing is stronger; the reverse implication should not be certified without additional assumptions.

### References

- [OpenAI paper: Weak mixing of triangular billiards with an irrational angle](https://github.com/openai/math/tree/main/preprints/Weak-mixing-of-triangular-billiards-with-an-irrational-angle-October-5-2026)
- [OpenAI triangle-billiards Lean development](https://github.com/openai/math/tree/main/lean/OAI/Dynamics/TriangleBilliards)

### Experiment

Compare the claim that the billiard flow is weakly mixing with the weaker property that it is ergodic.

Schematically,

$$
\operatorname{WeakMixing}(T)\Longrightarrow\operatorname{Ergodic}(T),
$$

while ergodicity alone does not imply weak mixing in general.

This is a property-hierarchy experiment. Unlike MUB, the difference is not a changed numerical constant; unlike reconstruction, the relationship depends on a genuine mathematical theorem connecting two dynamical properties.

A key methodological question is whether that bridge theorem is already available within the permitted trusted background or must be supplied explicitly.

### Results

