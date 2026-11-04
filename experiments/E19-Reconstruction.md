# E19. Exact reconstruction thresholds versus supercritical reconstruction

**Prior expectation:** The current Result 229 family is broader than the
selected Lean formalization in two independent ways.

First, the family claims exact reconstruction thresholds, including
nonreconstruction at equality, while the Lean scope selects only the
supercritical reconstruction direction.

Second, the current family includes both three-state and four-state
broadcasting results, while the Lean scope lists only the three-state
paper and three-state comparator targets.

## References

- OpenAI Result 229: Sharp three- and four-state reconstruction thresholds
- `lean/docs/229.md`
- `ComparatorChallenges/ThreeStateSupercritical.lean`
- `ComparatorChallenges/ThreeStateSupercritical.json`
- `ComparatorChallenges/ThreeStateTreeClauses.lean`
- `ComparatorChallenges/ThreeStateTreeClauses.json`
- `OAI/Probability/ThreeState/Main.lean`
- `OAI/Probability/ThreeStateClauses/Main.lean`

## Background

For the symmetric three-state broadcast model, the current family claim
identifies the exact Kesten-Stigum reconstruction threshold:

\[
d\lambda^2 > 1.
\]

Above the threshold, reconstruction occurs.

At or below the threshold, reconstruction does not occur, including
nonreconstruction at equality.

The family also includes analogous four-state ferromagnetic results and a
three-community stochastic-block-model consequence.

The pinned Lean scope is narrower. It formalizes only the supercritical
three-state direction:

\[
d\lambda^2 > 1
\Rightarrow
Reconstructs.
\]

For regular trees the corresponding condition is

\[
b\lambda^2 > 1.
\]

The selected statements do not include:

- nonreconstruction at equality;
- nonreconstruction below threshold;
- the stochastic-block-model consequence;
- the four-state reconstruction result.

## Experiment

### E19-A — family coverage and scope

The current family includes:

1. exact three-state threshold on regular trees;
2. exact three-state threshold on observed Poisson trees;
3. nonreconstruction at equality;
4. four-state ferromagnetic reconstruction thresholds;
5. four-state tree-capacity results;
6. the three-community SBM weak-recovery consequence.

The pinned Lean scope lists only the three-state paper and states that the
selected formalization proves supercritical reconstruction.

Accordingly:

- three-state regular supercritical reconstruction: `TARGETED`
- three-state Poisson supercritical reconstruction: `TARGETED`
- three-state nonreconstruction at equality: `NOT_SELECTED`
- three-state subcritical nonreconstruction: `NOT_SELECTED`
- three-community SBM consequence: `NOT_SELECTED`
- four-state reconstruction results: `NOT_IN_SCOPE`

**Expected family-level classification:**
`PartialFormalizationCoverage`

Within the three-state theorem itself, the selected statement is also
strictly weaker than an exact-threshold claim because it retains only one
direction of the phase transition.


### E19-A results

A search of the pinned `lean/ComparatorChallenges` and
`lean/OAI/Probability` trees found no Lean or comparator artifact matching
the four-state reconstruction result.

The three-state implementation contains the expected selected theorems:

- `OAI.ThreeState.regular_supercritical`
- `OAI.ThreeState.poisson_supercritical`
- `OAI.ThreeStateClauses.regular_reconstructs_above_KS`
- `OAI.ThreeStateClauses.poisson_reconstructs_above_KS`

Thus the pinned formalization surface is three-state and supercritical.

**Classification:** `PartialFormalizationCoverage`

The family-level omissions include the four-state results, while the
three-state theorem itself is also weaker than an exact-threshold statement
because the nonreconstruction side of the phase transition is absent.


### E19-B — exact threshold versus supercritical half

SemantEq returned:

```text
verdict: Inconclusive
ref ⇒ cand: not proved
  no proof found in 83 attempts
cand ⇒ ref: not proved
  no proof found in 83 attempts
```

The SemantEq result alone does not establish either non-entailment.
Independent forward bridge
An independent Lean bridge proved:
\[
R \Rightarrow C.
\]
The proof is simply projection of the supercritical conjunct from the
exact-threshold reference.

ReconstructionThresholdBridge.ref_implies_candidate kernel-checks with:
[propext, Classical.choice, Quot.sound, Reconstructs]

and no sorryAx.

Thus SemantEq's failure on ref ⇒ cand is a proof-search false negative.
Countermodel to the reverse implication
To test the reverse direction, define:
\[
Reconstructs(x):=\mathrm{True}
\]
for every real \(x\).

Then the candidate statement holds trivially:
\[
x>1\Rightarrow Reconstructs(x).
\]
But the reference fails at \(x=1\), because exact-threshold behavior also
requires:
\[
x\le1\Rightarrow\neg Reconstructs(x).
\]
Lean kernel-checked:
- ReconstructionThresholdCountermodel.candidate_holds
- ReconstructionThresholdCountermodel.ref_fails
- ReconstructionThresholdCountermodel.candidate_does_not_imply_ref
with axioms:
[propext, Classical.choice, Quot.sound]

and no sorryAx.

Therefore:
\[
\boxed{R\Rightarrow C}
\]
but:
\[
\boxed{C\nRightarrow R}.
\]
The selected supercritical statement is strictly weaker than the exact
threshold claim.

E19-B classification: StrictlyWeakerCandidate

The two SemantEq failures have different semantic meanings:
- ref ⇒ cand: valid implication missed by proof search;
- cand ⇒ ref: genuinely invalid implication.

### E19-C — actual selected OpenAI implementation

We checked the actual pinned implementation behind the selected
three-state comparator targets.

The implementation theorems are:

- `OAI.ThreeState.regular_supercritical`
- `OAI.ThreeState.poisson_supercritical`

An independent bridge packaged these into the selected formal-strength
statements for regular and Poisson trees.

Lean kernel-checked:

```text
OAI.ThreeState.regular_supercritical
OAI.ThreeState.poisson_supercritical
ScientificAudit.E19C.actual_implementation_implies_regular_selected
ScientificAudit.E19C.actual_implementation_implies_poisson_selected
ScientificAudit.E19C.actual_implementation_implies_selected
```

All depend only on:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorryAx` occurs.

Thus the actual selected OpenAI implementation faithfully realizes the
supercritical reconstruction claims audited in E19-B.

### Implementation-scope note

The selected comparator targets are only the supercritical theorems
`regular_supercritical` and `poisson_supercritical`.

The surrounding pinned solution module also imports additional
nonreconstruction results. These include stronger unselected results in
some parameter regions, including exact-threshold behavior for
nonnegative lambda and additional proved negative-lambda regions.

Those auxiliary theorems do not eliminate the E19 family-level gap.

The selected formal statements remain supercritical-only, and the pinned
formalization does not establish the unrestricted exact three-state
threshold over the entire admissible parameter range represented by the
current family-level claim.

Accordingly, E19 distinguishes three layers:

1. the current family-level exact-threshold claim;
2. the selected comparator statements;
3. additional but incomplete unselected theorem content in the solution
   module.

### E19 overall result

The current Result 229 family claims exact reconstruction thresholds,
including both reconstruction above threshold and nonreconstruction at or
below threshold.

The selected Lean targets retain only the supercritical reconstruction
direction.

E19-B independently established:

\[
R\Rightarrow C
\]

but:

\[
C\nRightarrow R.
\]

The forward implication was kernel-proved, while the reverse was refuted
by an explicit kernel-checked countermodel.

SemantEq returned `Inconclusive` in both directions:

```text
ref ⇒ cand: not proved
cand ⇒ ref: not proved
```

Independent analysis showed that these failures had different meanings:

- `ref ⇒ cand`: valid implication missed by proof search;
- `cand ⇒ ref`: genuinely invalid implication.

E19-A additionally found a family-level coverage gap: the current family
includes four-state reconstruction results, while the searched pinned
comparator and probability-formalization trees contain only three-state
targets.

The actual selected OpenAI implementation kernel-checks against the
weaker supercritical candidate statement.

Therefore:

\[
\boxed{
\text{current exact-threshold family claim}
\;\Longrightarrow_{\text{strict}}\;
\text{selected supercritical formal strength}
\;\Longleftarrow\;
\text{actual selected implementation}
}
\]

**Classifications:**

- `PartialFormalizationCoverage`
- `StrictlyWeakerCandidate`
- `OneSidedPhaseTransitionFormalization`

Artifacts:

- `src/reconstruction_threshold_ref.lean`
- `src/reconstruction_threshold_candidate.lean`
- `src/reconstruction_threshold_bridge.lean`
- `src/reconstruction_threshold_countermodel.lean`
- `src/reconstruction_openai_bridge.lean`
- `results/E19-B.json`
- `results/E19-B-forward-bridge.txt`
- `results/E19-B-countermodel.txt`
- `results/E19-C-openai-bridge.txt`
- `evidence/e19-a/`

