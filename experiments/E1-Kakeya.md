## E1. Kakeya: representation equivalence and trusted consequence

**Prior expectation:** Equivalent for the parameterization comparison; one-way implication for the trusted compact consequence.

### References

- [OpenAI: Local smoothing formalization scope](https://github.com/openai/math/blob/main/lean/docs/079.md)
- [OpenAI Comparator: `LocalSmoothing.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/LocalSmoothing.lean)
- [OpenAI: Local smoothing for the Euclidean wave equation](https://github.com/openai/math/tree/main/preprints/Local-smoothing-for-the-Euclidean-wave-equation-October-25-2026)

### Experiment

Audit the Kakeya statement across alternative formal representations of a unit segment.

One formulation uses a centered parameterization,

$$
\{x+t\omega : t\in[-1/2,1/2]\},
$$

while another uses an endpoint-style parameterization,

$$
\{x+t\omega : t\in[0,1]\}.
$$

The first comparison asks whether these produce semantically equivalent Kakeya-set predicates after the appropriate translation of the segment base point. We want SemantEq to establish both directions rather than treating the syntactic difference as a substantive theorem difference.

A second comparison asks whether the OpenAI formulation implies a smaller trusted compact formulation used in the audit. This is expected to be a valid restriction/consequence rather than a bidirectional equivalence.

### Results


Prove the centered unit is equal to the [0,1] segment
```
lake exe semanteq --strict --proof \
  ../src/oai_to_standard.lean \
  ../src/standard_to_oai.lean
```

Results:
```
[proof-audit] ../src/oai_to_standard.lean
[semanteq] importing (cache miss #1): #[Init, Mathlib]
── ../src/oai_to_standard.lean
   verdict: PASS   (antecedent oai_assumed, goal standard_from_oai)
   warnings: 1 tolerated (1 local hypothesis meeting a hypothesis of the antecedent)
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
[proof-audit] ../src/standard_to_oai.lean
── ../src/standard_to_oai.lean
   verdict: PASS   (antecedent standard_assumed, goal oai_from_standard)
   warnings: 1 tolerated (1 local hypothesis meeting a hypothesis of the antecedent)
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
```

See [raw](./results/geometry.json)

Prove arbitrary subset Kakeya is equal to the compact Kakeya

```
lake exe semanteq --strict --proof \
  ../src/oai3_to_trusted_compact.lean
```

Results:
```
[proof-audit] ../src/oai3_to_trusted_compact.lean
[semanteq] importing (cache miss #1): #[Init, Mathlib]
── ../src/oai3_to_trusted_compact.lean
   verdict: PASS   (antecedent oai3_assumed, goal trusted_wang_zahl_from_oai)
   warnings: 1 tolerated (1 local hypothesis meeting a hypothesis of the antecedent)
   severe warnings: none
   axioms beyond propext, Classical.choice, Quot.sound: none
```

See [raw](./results/subsets.json)


