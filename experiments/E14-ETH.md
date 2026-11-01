# E14. Exponential Time Hypothesis: cross-lab formalization alignment

**Status:** Planned; open-ended cross-formalization experiment.

**Prior expectation:** The OpenAI subexponential SAT/counting result should imply an appropriate neutral statement of $\neg\mathrm{ETH}$; the exact relationship between the OpenAI and Anthropic formalizations is uncertain until machine models, encodings, asymptotics, and definitions are aligned.

### References

- [OpenAI formalization scope: The Exponential Time Hypothesis is False](https://github.com/openai/math/blob/main/lean/docs/378.md)
- [OpenAI Comparator: `SubexponentialSAT.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SubexponentialSAT.lean)
- [Anthropic formal-math ETH README](https://github.com/anthropics/formal-math/blob/main/eth/README.md)
- [Anthropic `MainResults.lean`](https://github.com/anthropics/formal-math/blob/main/eth/MainResults.lean)

### Experiment

Construct, if feasible, a small neutral target expressing the relevant form of the Exponential Time Hypothesis and compare it separately with the OpenAI and Anthropic formalizations.

The OpenAI selected theorem proves a deterministic exact-counting/SAT algorithm for fixed-width CNF formulas with a subexponential-in-$n$ runtime bound. Anthropic's independent Lean development explicitly defines `ETH` and `ETHIsFalse` using its own machine model and formal interfaces.

The ideal audit has three nodes:

$$
\text{OpenAI algorithm statement}
\quad\longrightarrow\quad
\neg\mathrm{ETH}_{\text{neutral}},
$$

$$
\text{Anthropic `ETHIsFalse`}
\quad\longleftrightarrow\quad
\neg\mathrm{ETH}_{\text{neutral}},
$$

and, only after those bridges are understood, a comparison between the two labs' formal statements.

This is deliberately not assumed to be a simple equivalence test. Differences in machine model, input encoding, counting versus decision, asymptotic conventions, and fixed-width quantification must remain explicit rather than being normalized away informally.

### Results


