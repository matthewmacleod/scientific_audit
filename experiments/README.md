# SemantEq Experiments

This file is the working registry for the experiments in the SemantEq scientific-audit project.

The purpose of the project is not to search only for failures. The central question is:

> Given two formalizations that purport to express the same scientific claim, what semantic relationship actually holds between them?

A successful equivalence proof is a substantive audit result. A one-way implication, a provable weakening, or an unresolved comparison is also informative. We therefore include expected-positive, expected-asymmetric, and genuinely uncertain cases.

For each experiment, the **prior expectation** should be frozen before the comparison is run. It is not the result. After the experiment, we will add the SemantEq output, Lean verification, exact toolchain/version information, and interpretation.

Project repository: [scientific_audit](https://github.com/matthewmacleod/scientific_audit)

Useful external context:

- [OpenAI math repository](https://github.com/openai/math)
- [OpenAI formalization catalogue](https://github.com/openai/math/blob/main/lean/formalization.yaml)
- [OpenAI Comparator challenges](https://github.com/openai/math/tree/main/lean/ComparatorChallenges)
- [MathVet explainer](https://github.com/mathvet/mathvet/blob/main/EXPLAINER.md)

## Experiment record template

When an experiment is run, append the following under its `Results` heading.

```text
SemantEq version:
Lean version:
Mathlib/toolchain:
Source revision(s):
Reference statement digest:
Candidate statement digest:
Prior expectation:
SemantEq classification:
Reference -> candidate:
Candidate -> reference:
Lean verification:
Trusted assumptions / imported bridge lemmas:
Countermodel or obstruction, if applicable:
Interpretation:
Artifacts:
```

The interpretation should distinguish at least the following outcomes where applicable:

- **Equivalent:** both directions are certified under the stated assumptions.
- **One-way implication:** one statement is a certified consequence of the other.
- **Provably non-equivalent:** separation is independently established, not merely inferred from a failed search.
- **LikelyTooWeak / likely too strong:** SemantEq finds a directional strength relationship but does not establish full semantic separation.
- **Unknown:** the permitted search/transformation system did not settle the relationship.

A failure to prove equivalence is not, by itself, evidence of non-equivalence.
