# E12. Hyperbolicity cones: spectrahedrality versus semidefinite lifts


**Prior expectation:** Nonexistence of any semidefinite lift is stronger than nonspectrahedrality in the original coordinates.

## References

- [OpenAI formalization scope: hyperbolicity cones without semidefinite lifts](https://github.com/openai/math/blob/main/lean/docs/095.md)
- [OpenAI Comparator: `HyperbolicCones.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/HyperbolicCones.lean)

## Experiment

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

OpenAI’s current Result 095 headline is the stronger October 5 claim:

$$
\boxed{\text{some hyperbolicity cone is not a spectrahedral shadow}}
$$

equivalently, it admits no finite affine semidefinite lift. That disproves the Projected Lax conjecture. GitHub

But the Lean scope page says the formalization is for the earlier September 24 paper, A nonspectrahedral hyperbolicity cone. Its comparator proves only that an explicit degree-20 polynomial in a 23-dimensional space has a cone that cannot equal the PSD region of any linear pencil in the original coordinates:

$$
\forall N>0,\forall L,\qquad
C\neq\{x:L(x)\succeq0\}.
$$

That is “not spectrahedral,” not “not a spectrahedral shadow.”

OpenAI also has an October 5 companion paper proving that this same explicit 23-variable nonspectrahedral cone actually has an exact semidefinite lift, using a size-100 pencil with 307 auxiliary variables.



## Results

### E12-A
provenance / target alignment

The current Result 095 headline disproves the Projected Lax conjecture by exhibiting hyperbolicity cones with no finite semidefinite lift. The selected Lean formalization instead targets the earlier explicit 23-dimensional degree-20 cone and proves only that it is nonspectrahedral in its original coordinates. A companion OpenAI paper explicitly constructs a semidefinite lift of that same cone. Therefore the selected Lean target does not formalize the stronger no-lift headline.

### E12-B

est the pure logical strength distinction.

Let:

$$
\text{Direct}(C)
$$

mean “\(C\) has a spectrahedral representation in its original coordinates,” and

$$
\text{Lift}(C)
$$

mean “\(C\) has some semidefinite lift.”

Every direct representation is trivially a lift, so

$$
Direct(C)\Rightarrow Lift(C).
$$

Consequently,

$$
\neg Lift(C)\Rightarrow\neg Direct(C),
$$

but not conversely.


```
lake exe semanteq --strict --timeout 0 \
  ../src/hyperbolic_no_lift_ref.lean \
  ../src/hyperbolic_nonspectrahedral_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T14:18:09Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing hyperbolic_no_lift_ref__vs__hyperbolic_nonspectrahedral_candidate
── hyperbolic_no_lift_ref__vs__hyperbolic_nonspectrahedral_candidate
   verdict: Inconclusive   (440027 ms)
   ref ⇒ cand: not proved
      no proof found in 25 attempts
   cand ⇒ ref: not proved
      no proof found in 25 attempts

```

E12-B is now a nice case:

$$
\boxed{\text{SemantEq: Inconclusive}}
$$

even though the frozen relation is the strict implication

$$
\neg\mathrm{Lift}(C)\Rightarrow\neg\mathrm{Direct}(C).
$$


```
lake env lean ../src/hyperbolic_no_lift_bridge.lean
```

### E12-B2 — reverse separation witness

This captures the logical possibility

$$
\neg Direct(C)\quad\text{while}\quad Lift(C),
$$

which is exactly the distinction we care about.

```
lake env lean ../src/hyperbolic_scope_separation_witness.lean
```

we have the exact relation:

$$
\boxed{
\neg Lift(C)\Rightarrow\neg Direct(C),
\qquad
\neg Direct(C)\nRightarrow\neg Lift(C).
}
$$

That makes E12-B another case where Inconclusive hides a strict implication.


### E12-C 

Next do a pinned-source fidelity against the exact HyperbolicCones.lean comparator, confirming that the selected Lean target really is “not spectrahedral in the original coordinates,” rather than “no semidefinite lift.” This closes the provenance point directly against source

```
# 1. Vendor the exact pinned OpenAI comparator.

mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/HyperbolicCones.lean \
  -o audit_vendor/ComparatorChallenges/HyperbolicCones.lean


# 2. Record the frozen source hash.

shasum -a 256 \
  audit_vendor/ComparatorChallenges/HyperbolicCones.lean


# 3. Compile the pinned comparator.

ROOT="$(pwd)"

lake env lean \
  -o "$ROOT/audit_vendor/ComparatorChallenges/HyperbolicCones.olean" \
  "$ROOT/audit_vendor/ComparatorChallenges/HyperbolicCones.lean"
```
after run

```
ROOT="$(pwd)"
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"

lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/hyperbolic_cones_source_fidelity.lean"
```

Clean.


#### Conclusions

Importantly, its theorem quantifies only over linear pencils

$$
L:\text{Ambient}\to\operatorname{Sym}_N
$$

in the same ambient coordinates. There are no auxiliary variables and no projection in the statement.

So it does not state:

$$
\boxed{\text{“no spectrahedral shadow / no finite semidefinite lift.”}}
$$

That makes E12 unusually crisp:


- E12-A: provenance/target mismatch
  Current headline: no spectrahedral shadow / no finite semidefinite lift
  Selected Lean target: merely nonspectrahedral in the original coordinates

- E12-B: theorem-strength relation

$$
  \neg Lift(C)\Rightarrow\neg Direct(C),
  \qquad
  \neg Direct(C)\nRightarrow\neg Lift(C)
$$

  SemantEq: Inconclusive
  Lean: strict implication independently confirmed

- E12-C: pinned-source fidelity
  Exact comparator indeed states the weaker no direct spectrahedral representation claim

And the especially sharp scientific point is that OpenAI’s own companion work gives a lift for the formalized nonspectrahedral cone, so the formalized witness is not merely missing the stronger property in the statement; it actually has the opposite relevant fact: it does admit a semidefinite lift.

That makes E12 one of our strongest provenance-audit examples.

