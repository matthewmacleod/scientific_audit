# E14. Exponential Time Hypothesis: cross-lab formalization alignment


**Prior expectation:** The OpenAI subexponential SAT/counting result should imply an appropriate neutral statement of $\neg\mathrm{ETH}$; the exact relationship between the OpenAI and Anthropic formalizations is uncertain until machine models, encodings, asymptotics, and definitions are aligned.

## References

- [OpenAI formalization scope: The Exponential Time Hypothesis is False](https://github.com/openai/math/blob/main/lean/docs/378.md)
- [OpenAI Comparator: `SubexponentialSAT.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SubexponentialSAT.lean)
- [Anthropic formal-math ETH README](https://github.com/anthropics/formal-math/blob/main/eth/README.md)
- [Anthropic `MainResults.lean`](https://github.com/anthropics/formal-math/blob/main/eth/MainResults.lean)

## Experiment

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

## Results

E14-A — uniform machine vs per-\(k\) machine
Frozen prior:

$$
\boxed{\text{Anthropic-style}\Rightarrow\text{OpenAI-style}}
$$

but not conversely.

Reference, representing Anthropic’s quantifier order.

```
lake exe semanteq --strict --timeout 0 \
  ../src/eth_uniform_machine_ref.lean \
  ../src/eth_per_k_machine_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T17:46:55Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing eth_uniform_machine_ref__vs__eth_per_k_machine_candidate
── eth_uniform_machine_ref__vs__eth_per_k_machine_candidate
   verdict: LikelyTooWeak   (166347 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.ETHCrossFormalization.eth_uniform_machine_ref, <structural>]
      proof:  fun k a => Exists.casesOn SemantEqRef.ETHCrossFormalization.eth_uniform_machine_ref fun w h => Exists.intro w (h k a)
   cand ⇒ ref: not proved
      no proof found in 87 attempts

```

and
```
lake env lean ../src/eth_uniformity_bridge.lean
```
clean

```
lake env lean ../src/eth_uniformity_separation_witness.lean
```
clean

### E14-B

For E14-B, we examine the second difference: the time bounds. Anthropic formalizes the sharper exponent

$$
O\!\left(
\min\left\{
\frac{km}{\sqrt{\log m}},
\frac{k^2n\log\log n}{\sqrt{\log n}}
\right\}
\right),
$$

with one constant independent of \(k\). GitHub

OpenAI’s selected Lean scope instead gives, for fixed \(k\),

$$
O_k\!\left(
\frac{n(\log\log n)^2}{\sqrt{\log n}}
\right),
$$

plus polynomial factors, and explicitly notes that the accompanying manuscript has a sharper $(n\log\log n/\sqrt{\log n})$ bound than the selected Lean target.

So there are actually two independent weakenings between the formalizations:

$$
\boxed{\text{uniform machine} \to \text{per-}k\text{ machine}}
$$

and

$$
\boxed{
n\log\log n/\sqrt{\log n}
\quad\text{vs}\quad
n(\log\log n)^2/\sqrt{\log n}.
}
$$

E14-B a time-bound scope/strength audit first, rather than immediately forcing it into SemantEq. The two developments use different machine models and encodings, so a direct statement comparison could conflate the rate difference with representation differences.


#### E14-B1

Quantitative cross-formalization difference. Anthropic formalizes a sharper $(n)$-dependence and a constant uniform in $(k)$. OpenAI’s selected comparator formalizes a weaker $(O_k\bigl(n(\log\log n)^2/\sqrt{\log n}\bigr))$ exponent. This is a genuine theorem-strength difference, not merely notation.


```
lake env lean ../src/eth_time_bound_strength_bridge.lean
```

E14-B is closed as a clean quantitative strength result:

\[
\boxed{
\frac{n\log\log n}{\sqrt{\log n}}
\;\lesssim\;
\frac{n(\log\log n)^2}{\sqrt{\log n}}
}
\]

in the asymptotic regime, so the single-\(\log\log\) rate is genuinely stronger. Together with E14-A, we now have two independent cross-formalization strength differences:

- Machine uniformity: \(\exists M\,\forall k\) is strictly stronger than \(\forall k\,\exists M_k\).
- Rate: single \(\log\log n\) is stronger than squared \((\log\log n)^2\).

Neither says OpenAI's formalization is wrong; they tell us Anthropic and OpenAI chose different formal theorem boundaries/strengths.

### E14-C



```
lake exe semanteq --strict --timeout 0 \
  ../src/eth_exact_counting_ref.lean \
  ../src/eth_false_operational_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T18:38:10Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing eth_exact_counting_ref__vs__eth_false_operational_candidate
── eth_exact_counting_ref__vs__eth_false_operational_candidate
   verdict: Inconclusive   (448187 ms)
   ref ⇒ cand: not proved
      no proof found in 59 attempts
   cand ⇒ ref: not proved
      no proof found in 59 attempts
```


confirm

```
lake env lean ../src/eth_counting_to_decision_bridge.lean
```

```
lake env lean ../src/eth_counting_decision_separation_witness.lean
```


E14-C1 is:

$$
\boxed{
\text{exact subexponential counting}
\Rightarrow
\text{subexponential SAT decision},
\qquad
\text{not conversely}.
}
$$

while SemantEq gave:

$$
\boxed{\texttt{Inconclusive}}
$$

E14-C1 is fully closed: exact counting strictly implies the operational SAT-decision consequence, SemantEq missed the forward existential transport, and the reverse fails cleanly.

### E14-C2

E14-C2 is where the interesting mathematics begins:

$$
\forall \delta>0\;\exists\text{ a }2^{\delta n}\text{-type 3-SAT decider}
\Longrightarrow
\texttt{ETHIsFalse}
$$

using Anthropic’s actual infimum-based definition of the ETH constant.

Does OpenAI’s formal exact-counting claim imply Anthropic’s independently defined formal proposition ETHIsFalse?

An independently developed Lean bridge proves that OpenAI’s pinned formal claim, re-elaborated in Anthropic’s environment, implies Anthropic’s ETHIsFalse. The bridge itself is kernel-checked, but composition with OpenAI’s original proof crosses a Lean/Mathlib version seam rather than occurring in one kernel environment.

An independently developed Lean bridge proves that OpenAI’s pinned formal claim, re-elaborated in Anthropic’s environment, implies Anthropic’s ETHIsFalse. The bridge itself is kernel-checked, but composition with OpenAI’s original proof crosses a Lean/Mathlib version seam rather than occurring in one kernel environment.

to run


```
cd ..

git clone https://github.com/anthropics/formal-math.git anthropic-formal-math
git clone https://github.com/TSavo/eth-bridge.git eth-bridge
cd eth-bridge
git log -1 --oneline
cat README.md

cd ../anthropic-formal-math/eth
cp -R ../../eth-bridge/bridge ./bridge


grep -q 'name = "Bridge"' lakefile.toml || cat >> lakefile.toml <<'EOF'

[[lean_lib]]
name = "Bridge"
srcDir = "bridge"
globs = ["Bridge.+"]
EOF

lake exe cache get
lake build Bridge

lake build Bridge 2>&1 | tee bridge-build.log
../../eth-bridge/instrument.sh bridge-build.log
```

Build completed successfully (9521 jobs).
R=0 sorry-declarations in Bridge.Main


### Conclusion

E14 overall as partial fidelity, not unqualified positive fidelity.

Why? Because we found two real strength differences:

$$
\exists M\,\forall k
\quad\text{(Anthropic)}
$$

is stronger than

$$
\forall k\,\exists M_k
\quad\text{(OpenAI selected target)},
$$

and Anthropic’s formalized time rate is sharper than the squared-\(\log\log n\) rate in OpenAI’s selected Lean target.

So I’d summarize E14 as:
- Core headline (“ETH is false”): positive fidelity.
- Full quantitative/constructive package: partial fidelity / different theorem boundaries.
- Not a mismatch like E12, because OpenAI’s weaker formal theorem still suffices for the central scientific conclusion.



