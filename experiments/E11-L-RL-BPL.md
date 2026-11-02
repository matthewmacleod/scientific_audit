# E11. $\mathsf L=\mathsf{RL}=\mathsf{BPL}$: equality normalization

**Prior expectation:** Equivalent.

### References

- [OpenAI formalization scope: exact derandomization of logarithmic space](https://github.com/openai/math/blob/main/lean/docs/103.md)
- [OpenAI Comparator: `LogspaceEquality.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/LogspaceEquality.lean)
- [OpenAI paper: Exact derandomization of logarithmic space](https://github.com/openai/math/tree/main/preprints/Exact-Derandomization-of-Logarithmic-Space-L-equals-RL-equals-BPL-September-23-2026)

## Background

This is a claimed derandomization theorem in computational complexity. The classes describe what a computer can solve using only logarithmic memory in the input size:

    L: deterministic computation.
    RL: randomized computation with one-sided error.
    BPL: randomized computation with two-sided bounded error.

The result claims that randomness doesn’t let a logarithmic-space computer solve any additional problems:
L=RL=BPL.

The known inclusions already give L⊆RL⊆BPL, so the difficult part is showing BPL⊆L that every problem solvable with bounded-error randomness in logarithmic space can also be solved deterministically in logarithmic space. 

“Equality normalization” is about presenting the conclusion as equalities of complexity classes; it isn’t a separate kind of algorithm. If correct, this would settle a long-standing open question. The OpenAI preprint is unrefereed, however, so the claim still needs independent scrutiny, even though the project provides a Lean formalization.

## Experiment

Compare alternative logical presentations of equality among the three complexity classes, for example

$$
\mathsf L=\mathsf{RL}\;\land\;\mathsf{RL}=\mathsf{BPL}
$$

and

$$
\mathsf L=\mathsf{RL}\;\land\;\mathsf L=\mathsf{BPL}.
$$

The experiment is intentionally simple mathematically. Its purpose is to verify that SemantEq handles equality symmetry/transitivity and conjunction normalization correctly before those same transformations appear inside more complicated statements.


OpenAI’s public description says not merely \(L=RL=BPL\), but that an effective compiler turns each randomized polynomial-time logspace machine into a deterministic logspace decider, with explicit polynomial running-time bounds. GitHub

But OpenAI’s own formalization-scope page says:
the selected Comparator theorem asserts equality of the language classes; the explicit compiler and numerical running-time bounds are not separately stated in the Comparator target. GitHub

That is not the same kind of problem as E8 or E9. The core scientific headline

$$
L=RL=BPL
$$

is faithfully formalized. But some stronger constructive information advertised alongside it is outside the selected comparator statement.

tentatively structure E11 as:

- E11-A: $(BPL\subseteq L)$ versus $(L=RL=BPL)$ under the standard easy inclusions — logical equivalence test.
- E11-B: equality of classes versus the stronger effective compiler with explicit time bounds — provenance/scope distinction, probably no SemantEq verdict.
- E11-C: inspect whether the full Lean development actually contains enough constructive machinery behind BPL_subset_L to recover some compiler claim, even though the Comparator does not state it.
- E11-D: pinned-source fidelity for the actual equality theorem.

And conceptually, this result is enormous if correct. It says bounded-error random bits add no computational power at all to logarithmic workspace:

$$
\boxed{L=RL=BPL}.
$$

The randomized algorithm might look fundamentally stronger because it can explore probabilistic branches, but the theorem says a deterministic machine with only $(O(\log n))$ workspace can reproduce its decision power. The giant Lean proof preceding BPL_subset_L is where all of that difficulty lives; the final equality itself is almost bookkeeping.

## Results


### E11-A

```
lake exe semanteq --strict --timeout 0 \
  ../src/logspace_core_inclusion_ref.lean \
  ../src/logspace_equality_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T07:14:39Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing logspace_core_inclusion_ref__vs__logspace_equality_candidate
── logspace_core_inclusion_ref__vs__logspace_equality_candidate
   verdict: EquivalentRestricted   (52482 ms)
   ref ⇒ cand: proved
      script: normalize (plumbing/cast) + structural
      proof:  fun a a_1 =>
                Eq.mpr (id (Eq.trans (congr (congrArg And _simp_22) (Eq.trans _simp_17 _simp_22)) _simp_13))
                  ⟨fun x =>
                    {
                      mp := fun a_2 =>
                        a
                          (SemantEqRef.LogspaceDerandomization.logspace_core_inclusion_ref a a_1
                            (a_1 (a (SemantEqRef.LogspaceDerandomization.logspace_core_inclusion_ref a a_1 a_2)))),
                      mpr := a_1 },
                    fun x =>
                    { mp := a,
                      mpr := fun a_2 =>
                        SemantEqRef.LogspaceDerandomization.logspace_core_inclusion_ref a a_1
                          (a_1 (a (SemantEqRef.LogspaceDerandomization.logspace_core_inclusion_ref a a_1 (a_1 a_2)))) }⟩
   cand ⇒ ref: proved
      script: normalize (plumbing/cast) + structural
      proof:  fun a a_1 =>
                And.casesOn
                  (Eq.mp
                    (Eq.trans
                      (Eq.trans
                        (implies_congr (Eq.refl (SemantEqRef.LogspaceDerandomization.L ⊆ SemantEqRef.LogspaceDerandomization.RL))
                          (Eq.trans
                            (Eq.trans
                              (implies_congr
                                (Eq.refl (SemantEqRef.LogspaceDerandomization.RL ⊆ SemantEqRef.LogspaceDerandomization.BPL))
                                (Eq.trans (congr (congrArg And _simp_22) (Eq.trans _simp_17 _simp_22)) _simp_13))
                              _simp_8)
                            (congr (congrArg And _simp_7) _simp_7)))
                        _simp_8)
                      (congr (congrArg And _simp_7) _simp_7))
                    SemantEqCand.LogspaceDerandomization.logspace_equality_candidate)
                  fun left right =>
                  And.casesOn
                    (Eq.mp
                      (Eq.trans
                        (Eq.trans
                          (implies_congr (Eq.refl (SemantEqRef.LogspaceDerandomization.L ⊆ SemantEqRef.LogspaceDerandomization.RL))
                            (Eq.trans
                              (Eq.trans
                                (implies_congr
                                  (Eq.refl (SemantEqRef.LogspaceDerandomization.RL ⊆ SemantEqRef.LogspaceDerandomization.BPL))
                                  (Eq.trans (congr (congrArg And _simp_22) (Eq.trans _simp_17 _simp_22)) _simp_13))
                                _simp_8)
                              (congr (congrArg And _simp_7) _simp_7)))
                          _simp_8)
                        (congr (congrArg And _simp_7) _simp_7))
                      SemantEqCand.LogspaceDerandomization.logspace_equality_candidate)
                    fun left right ⦃a_2⦄ a_3 =>
                    (fun x a a_4 =>
                        ((Eq.mp
                                (Eq.trans
                                  (Eq.trans
                                    (implies_congr
                                      (Eq.refl (SemantEqRef.LogspaceDerandomization.L ⊆ SemantEqRef.LogspaceDerandomization.RL))
                                      (Eq.trans
                                        (Eq.trans
                                          (implies_congr
                                            (Eq.refl
                                              (SemantEqRef.LogspaceDerandomization.RL ⊆ SemantEqRef.LogspaceDerandomization.BPL))
                                  …[truncated]

```

E11-A: core derandomization inclusion vs class-equality packaging
Frozen prior: Equivalent under $(L\subseteq RL\subseteq BPL)$
SemantEq: EquivalentRestricted
Both implications proved autonomously.


And this is a particularly useful positive result because it shows SemantEq can handle something more interesting than ExactMatch: it normalized the statements, reasoned through subset transitivity and antisymmetry, and recovered a genuine logical equivalence.

One crucial interpretation point, though: This does not mean SemantEq proved derandomization. The deep theorem is still

$$
\boxed{BPL\subseteq L}.
$$

Our reference assumes/provides that as the theorem conclusion. E11-A checks that, once you have it together with the easy inclusions, the advertised

$$
L=RL=BPL
$$

really follows and is logically equivalent to that core inclusion.

So E11-A has beautifully verified the headline packaging, while leaving the enormous scientific content exactly where it belongs: in OpenAI’s proof of \(BPL\subseteq L\).

That is another really nice example for our discussion:

$$
\text{deep scientific theorem}
\quad+\quad
\text{shallow logical packaging}.
$$

And this time SemantEq correctly handled the packaging all by itself.

### E11-B

E11-B — constructive-claim scope.
The public result advertises an effective machine-to-machine compiler with explicit polynomial running-time bounds. The selected Comparator theorem states only equality of language classes. OpenAI’s scope documentation explicitly acknowledges that the compiler and numerical running-time bounds are not separately represented in the Comparator target. The full Lean development constructs a deterministic witness inside the proof of BPL_subset_L, but that proof is classical/noncomputable and its exported theorem is extensional class inclusion. Accordingly, the current audit establishes the class-equality claim, but does not independently certify the stronger operational claim that an executable compiler with the advertised explicit time bound has been formalized.

I would not call that a contradiction. Better classification:
\[
\boxed{\text{core theorem faithfully formalized; stronger constructive claim outside Comparator scope}}
\]
There’s also a really interesting conceptual trap here. In ordinary classical logic,
\[
\forall M\,\exists D,\;Correct(M,D)
\]
can be turned by choice into
\[
\exists F\,\forall M,\;Correct(M,F(M)).
\]
But that \(F\) need not be computable. So a semantic-equivalence checker operating only at the level of propositions can accidentally erase exactly the distinction that “effective compiler” is trying to express.

That deserves a discussion subsection too:
Extensional existence versus effective construction.

### E11-C

pinned compare

```
mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/LogspaceEquality.lean \
  -o audit_vendor/ComparatorChallenges/LogspaceEquality.lean

shasum -a 256 \
  audit_vendor/ComparatorChallenges/LogspaceEquality.lean
```

```
ROOT="$(pwd)"

lake env lean \
  -o "$ROOT/audit_vendor/ComparatorChallenges/LogspaceEquality.olean" \
  "$ROOT/audit_vendor/ComparatorChallenges/LogspaceEquality.lean"
```

```
ROOT="$(pwd)"
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"

lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/logspace_source_fidelity.lean"
```

E11 is fully closed:

- E11-A: $(BPL \subseteq L)$ is equivalent to $(L=RL=BPL)$ under the standard easy inclusions; SemantEq got this right with EquivalentRestricted.
- E11-B: the stronger “effective compiler + explicit running-time bounds” claim is outside the selected Comparator target, so that constructive claim remains a separate audit question.
- E11-C: the exact pinned Comparator really does state the class-equality theorem cleanly.

That gives us another nice positive-fidelity case, plus a useful discussion distinction:

$$
\text{extensional class equality}
\neq
\text{effective compiler theorem}.
$$

