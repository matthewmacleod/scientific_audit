# E8. Weak mixing versus ergodicity

**Status:** Planned.

**Prior expectation:** Weak mixing is stronger; the reverse implication should not be certified without additional assumptions.

## References

- [OpenAI paper: Weak mixing of triangular billiards with an irrational angle](https://github.com/openai/math/tree/main/preprints/Weak-mixing-of-triangular-billiards-with-an-irrational-angle-October-5-2026)
- [OpenAI triangle-billiards Lean development](https://github.com/openai/math/tree/main/lean/OAI/Dynamics/TriangleBilliards)

- [Wikipedia Mixing](https://en.wikipedia.org/wiki/Mixing_(mathematics)


## Background

It’s about a key distinction in ergodic theory, which studies measure-preserving systems that evolve over time.

Ergodic means the system has no nontrivial measurable region that stays separate forever.

Weakly mixing is a stronger condition: over long time averages, the system loses persistent patterns of correlation.

The useful connection is that a system is weakly mixing exactly when the system running two independent copies side by side is ergodic. So weak mixing implies ergodicity, but not vice versa. An irrational rotation of the circle, for example, is ergodic but not weakly mixing: its motion keeps a regular, detectable pattern. So the OpenAI result is about formalizing or establishing this relationship between the two notions and not, in itself, a claim that weak mixing and ergodicity are the same.

### Experiment

Compare the claim that the billiard flow is weakly mixing with the weaker property that it is ergodic.

Schematically,

$$
\operatorname{WeakMixing}(T)\Longrightarrow\operatorname{Ergodic}(T),
$$

while ergodicity alone does not imply weak mixing in general.

This is a property-hierarchy experiment. Unlike MUB, the difference is not a changed numerical constant; unlike reconstruction, the relationship depends on a genuine mathematical theorem connecting two dynamical properties.

A key methodological question is whether that bridge theorem is already available within the permitted trusted background or must be supplied explicitly.

## Results


### E8-A

OpenAI’s current Result 150 headline is the October 5 theorem:

$$
\boxed{\text{irrational triangular billiards are weakly mixing}}
$$

and the paper states equivalently that the product flow with itself is ergodic. GitHub

But lean/docs/150.md explicitly says the Lean formalization covers the September 25 ergodicity paper, not the later weak-mixing paper. GitHub The comparator’s MainConclusion ends with the ordinary invariant-set criterion

$$
\mu(A)=0\ \lor\ \mu(A)=1
$$

for invariant measurable $(A)$, i.e. ergodicity of the original flow; there is no product-flow weak-mixing conclusion in that comparator. 

Result 150’s current family headline is weak mixing, while the selected Lean formalization is explicitly scoped to the earlier ergodicity result. The comparator establishes ergodicity of the billiard flow, together with existence, uniqueness, measure preservation, and the flow law, but not weak mixing/product ergodicity. This is a formalization-target/provenance mismatch, not evidence that the ergodicity formalization is incorrect.

### E8-A

E8-B tests the actual logical strength difference in a clean reduced setting:

$$
\text{weak mixing}\Rightarrow\text{ergodicity},
\qquad
\text{ergodicity}\not\Rightarrow\text{weak mixing}.
$$

A two-cycle gives us a beautiful separation witness: the flip on two points is ergodic, but its product preserves the diagonal, so it is not weakly mixing.

```
 lake exe semanteq --strict --raw --timeout 0 \
  ../src/weak_mixing_ref.lean \
  ../src/ergodicity_candidate.lean \
  > ../results/E8-B.json
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing weak_mixing_ref__vs__ergodicity_candidate
```

E8-B is already informative:

$$
\boxed{\text{SemantEq: Inconclusive}}
$$

even though our frozen prior was

$$
\text{WeakMixing}(T)\Rightarrow\text{Ergodic}(T).
$$

So SemantEq missed even the forward implication. Let’s now establish the actual relationship independently.

We do this in two pieces:
1. bridge: product ergodicity implies ordinary ergodicity;
2. separation witness: the Bool flip is ergodic but its product is not.

#### E8-B1

```
lake env lean ../src/weak_mixing_implies_ergodic_bridge.lean
```


#### E8-B2

```
lake env lean ../src/weak_mixing_separation_witness.lean
```


### Conclusions

E8-B is fully closed:

$$
\boxed{
\text{WeakMixing} \Rightarrow \text{Ergodic}
}
$$

but

$$
\boxed{
\text{Ergodic} \nRightarrow \text{WeakMixing}
}
$$

with the Bool flip as an explicit counterexample to the reverse implication.

So SemantEq’s Inconclusive again hid a strict implication.

And paired with E8-A, we have a strong provenance point: the current family-level headline is weak mixing, while the Lean target is the earlier, strictly weaker ergodicity theorem.


##### Pinned source statement check

# From scientific_audit/SemantEq/

# 1. Vendor the exact pinned OpenAI comparator source.
```
mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/IrrationalTriangleBilliard.lean \
  -o audit_vendor/ComparatorChallenges/IrrationalTriangleBilliard.lean
```


# 2. Record the exact source hash.
```
shasum -a 256 \
  audit_vendor/ComparatorChallenges/IrrationalTriangleBilliard.lean
```


# 3. Compile the vendored comparator to an .olean under the SemantEq root.
```
ROOT="$(pwd)"
```

```
lake env lean \
  -o "$ROOT/audit_vendor/ComparatorChallenges/IrrationalTriangleBilliard.olean" \
  "$ROOT/audit_vendor/ComparatorChallenges/IrrationalTriangleBilliard.lean"
```

# Expected:
# warning: declaration uses `sorry`
#
# This warning is expected because the upstream comparator theorem is admitted.


# 4. Verify the compiled module exists.
```
ls -l \
  "$ROOT/audit_vendor/ComparatorChallenges/IrrationalTriangleBilliard.olean"
```


# 5. Capture SemantEq/Lake's normal Lean module search path.
```
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"
```


# 6. Compile the source-fidelity bridge while prepending audit_vendor
#    to the existing Lean search path.
```
lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/weak_mixing_source_fidelity.lean"
```

Clean.

E8-C imports and checks the exact pinned OpenAI comparator source. The upstream comparator compiles with a sorry warning, so E8-C establishes statement/target fidelity only; it does not independently validate the underlying billiard proof.
