## E1. Kakeya: representation equivalence and trusted consequence

**Prior expectation:** Equivalent for the parameterization comparison; one-way implication for the trusted compact consequence.

## References

- [OpenAI: Local smoothing formalization scope](https://github.com/openai/math/blob/main/lean/docs/079.md)
- [OpenAI Comparator: `LocalSmoothing.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/LocalSmoothing.lean)
- [OpenAI: Local smoothing for the Euclidean wave equation](https://github.com/openai/math/tree/main/preprints/Local-smoothing-for-the-Euclidean-wave-equation-October-25-2026)

## Experiment

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

## Kakeya / SemantEq-ProofAudit experiment Background

[General Background Wikipedia](https://en.wikipedia.org/wiki/Kakeya_set)

This package compares OpenAI's current Lean Kakeya target against an independently
maintained trusted Lean formulation from `leanprover/lean-eval`.

## Probe A: geometry identity

`oai_to_standard.lean` and `standard_to_oai.lean` compare:

- OpenAI: centered segment `x + t • ω`, `t ∈ [-1/2,1/2]`;
- independent standard geometry: `x + t • ω`, `t ∈ [0,1]`.

Both quantify over arbitrary subsets, so this isolates the geometric representation
choice. The bridge shifts the base point by `ω/2`.

Run both directions (see [INSTALL.md](./INSTALL.md)):
```
lake exe semanteq --strict --proof oai_to_standard.lean standard_to_oai.lean
```

A semantic-equivalence certification requires PASS in both directions.

## Probe B: exact independent trusted statement

`oai3_to_trusted_compact.lean` compares the n=3 OpenAI theorem to the trusted
lean-eval Wang--Zahl formulation. lean-eval additionally requires compactness.

Run:
```
lake exe semanteq --strict --proof oai3_to_trusted_compact.lean
```

If this passes, it certifies that OpenAI's $(n=3)$ arbitrary-set theorem entails an independently maintained compact $(n=3)$ Kakeya formulation,
through an explicit segment reparameterization and restriction to compact sets.

There is intentionally no trivial reverse ProofAudit fixture. Going from the compact
conjecture to the arbitrary-set conjecture requires a substantive mathematical reduction,
not merely the local semantic rewrite being tested here. Keleti--Máthé (2022) proves the
standard compact/Borel/arbitrary formulations equivalent mathematically, but importing
that result as a black-box bridge would defeat the purpose of a SemantEq-style audit.

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


### Results Summary

Probe A passes in both directions; Probe B passes in the audited OAI → trusted direction.

### Toolchain caveat

SemantEq is currently pinned to Lean 4.30.0-rc1 / Mathlib v4.30.0-rc1. The independent
lean-eval target was on Lean 4.32.2, and OpenAI's current math repository is on Lean
4.34.1. These fixtures transcribe only the exact statement-level geometry into SemantEq's
pinned Mathlib environment rather than importing either project directly.

For archival evidence, record the exact source commits and compiler-check these fixtures
in the SemantEq environment before interpreting the ProofAudit verdicts.

Observed results: both geometry-direction ProofAudit fixtures PASS, and the OAI \(n=3\) → trusted compact Wang–Zahl fixture PASS. All runs used SemantEq v1.4.0, git f927670, in strict mode.

