# E10. Stable coordinate: predicate form versus expanded witness form

**Prior expectation:** Very likely equivalent after definition unfolding.

## References

- [OpenAI formalization scope: a stable-coordinate counterexample in four variables](https://github.com/openai/math/blob/main/lean/docs/049.md)
- [OpenAI Comparator: `StableCoordinateFour.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/StableCoordinateFour.lean)

## Background

It’s about polynomial coordinates in algebraic geometry. A polynomial F(x1,…,x4) is a coordinate if some invertible polynomial change of variables turns it into one of the variables, say x1. 

The result described in the OpenAI note claims an explicit degree-five polynomial F with a surprising property: in four variables, F is not a coordinate, but after adding one extra variable, it does become a coordinate. That’s a counterexample to the “stable coordinate conjecture,” which predicted that adding variables couldn’t make a noncoordinate polynomial become a coordinate.

The note also says every level surface F=c is isomorphic to ordinary three-dimensional affine space, but no polynomial change of coordinates in the original space can straighten it into a coordinate hyperplane.

“Predicate form versus expanded witness form” is a formalization detail: the predicate form says abstractly that F becomes a coordinate after adding a variable; the expanded witness form spells out the actual polynomial change of variables and its inverse. The underlying geometry is the same—the second version makes the evidence explicit for the proof assistant.

## Experiment

Compare the high-level predicate formulation of a polynomial being a stable coordinate but not a coordinate with the corresponding expanded witness formulation using polynomial automorphisms after adjoining an extra variable.

The aim is to test whether SemantEq can recognize semantic identity that is hidden largely behind definition expansion, witness packaging, and equivalent predicate interfaces.

This should serve as a positive calibration case outside the analysis/combinatorics examples.


OpenAI’s current Result 049 says there is an explicit degree-five \(f\in\mathbb C[x_1,\dots,x_4]\) that is not a coordinate, becomes a coordinate after adjoining one variable, and has affine-three-space but nonrectifiable fibers. The formalization scope says exactly that, and the pinned comparator packages precisely those claims as PrincipalPackage. GitHub The actual source theorem principal_package proves the same package and separately derives falsity of the four-variable Stable Coordinate conjecture from the explicit witness. GitHub

So E10 can be a positive-fidelity case.


## Results

### E10-A

We start with a very source-shaped logical question.

E10-A — explicit counterexample vs falsity of the conjecture

The OpenAI source does this exact step:

$$
\underbrace{
\operatorname{Stable}(f)\land\neg\operatorname{Coordinate}(f)
}_{\text{explicit witness}}
\quad\Longrightarrow\quad
\underbrace{
\neg\forall g\,
(\operatorname{Stable}(g)\to\operatorname{Coordinate}(g))
}_{\text{conjecture false}}.
$$

The reverse does not follow for the particular \(f\): falsity of the universal only says some polynomial is a counterexample. This mirrors the actual stable_coordinate_conjecture_four_false proof, which instantiates the universal statement at OpenAI’s explicit f.

Frozen prior:

$$
\boxed{\text{ref}\Rightarrow\text{cand},\qquad
\text{cand}\nRightarrow\text{ref}}
$$


```
lake exe semanteq --strict --timeout 0 \
  ../src/stable_coordinate_explicit_ref.lean \
  ../src/stable_coordinate_conjecture_false_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T05:06:32Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing stable_coordinate_explicit_ref__vs__stable_coordinate_conjecture_false_candidate
── stable_coordinate_explicit_ref__vs__stable_coordinate_conjecture_false_candidate
   verdict: LikelyTooWeak   (314989 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.StableCoordinateAudit.stable_coordinate_explicit_ref, <structural>]
      proof:  And.casesOn SemantEqRef.StableCoordinateAudit.stable_coordinate_explicit_ref fun left right a =>
                SemantEqRef.StableCoordinateAudit.stable_coordinate_explicit_ref.right
                  (a SemantEqRef.StableCoordinateAudit.f SemantEqRef.StableCoordinateAudit.stable_coordinate_explicit_ref.left)
   cand ⇒ ref: not proved
      no proof found in 43 attempts

```


SemantEq got the logical relation exactly right:

$$
\boxed{\text{LikelyTooWeak}}
$$

with

$$
\text{explicit counterexample at }f
\Rightarrow
\text{conjecture false}
$$

proved structurally, and no proof of the converse.


The generated proof is exactly the argument we expected: assume the universal conjecture, instantiate it at the distinguished \(f\), and contradict ¬ IsCoordinate f.

Now we independently close both directions so we know LikelyTooWeak is the true relation rather than just the search result.

```
lake env lean ../src/stable_coordinate_explicit_bridge.lean
```

```
lake env lean ../src/stable_coordinate_separation_witness.lean
```

E10-A is completely nailed down:

$$
\boxed{
\text{ref}\Rightarrow\text{cand},
\qquad
\text{cand}\nRightarrow\text{ref}
}
$$

and, importantly, SemantEq recognized that relation correctly.




### E10-B

For E10-B, I’d isolate the core representation-transport problem behind OpenAI’s actual theorem. The pinned source constructs
\[
\texttt{stabilizationEquiv} :
R_5 \simeq_{\mathbb C} R_4[w]
\]
and proves
\[
\operatorname{IsOneStableCoordinate}(g)
\iff
\exists \phi:R_4[w]\simeq_{\mathbb C}R_4[w],
\quad
\phi(Cg)=C(X_0).
\]
The proof works by conjugating automorphisms through that algebra equivalence. GitHub

So first let’s test the generic automorphism-conjugation skeleton, without burdening SemantEq with all the MvPolynomial machinery.


```
 lake exe semanteq --strict --timeout 0   ../src/stable_coordinate_transport_ref.lean   ../src/stable_coordinate_transport_candidate.lean
semanteq v1.4.0  git f927670  2026-11-02T05:57:37Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing stable_coordinate_transport_ref__vs__stable_coordinate_transport_candidate
── stable_coordinate_transport_ref__vs__stable_coordinate_transport_candidate
   verdict: Inconclusive   (561807 ms)
   ref ⇒ cand: not proved
      no proof found in 39 attempts
   cand ⇒ ref: not proved
      no proof found in 39 attempts
```

E10-B is now:

$$
\boxed{\text{SemantEq: Inconclusive}}
$$

with 39/39 failures both ways, despite the two statements being equivalent by conjugating the automorphism through $(e)$.

```
lake env lean ../src/stable_coordinate_transport_bridge.lean
```

E10-B becomes:

$$
\boxed{
\text{SemantEq: Inconclusive}
\qquad
\text{Lean: Equivalent}
}
$$

The interesting part is why. The missing witnesses are not mathematically deep, but they are synthesized higher-order objects:

$$
\psi=e\circ\phi\circ e^{-1}
$$

and

$$
\phi=e^{-1}\circ\psi\circ e.
$$

We classify E10-B as canonical representation transport via conjugation. That is more sophisticated than simple existential witness synthesis, but still something a future semantic auditor could plausibly support as a reusable structural pattern.

### E10-C Pinned source fidelity


```
mkdir -p audit_vendor/ComparatorChallenges

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/StableCoordinateFour.lean \
  -o audit_vendor/ComparatorChallenges/StableCoordinateFour.lean

shasum -a 256 \
  audit_vendor/ComparatorChallenges/StableCoordinateFour.lean
```
expect sorry

Bridge

```
ROOT="$(pwd)"
BASE_LEAN_PATH="$(lake env printenv LEAN_PATH)"

lake env env \
  LEAN_PATH="$ROOT/audit_vendor:$BASE_LEAN_PATH" \
  lean "$ROOT/../src/stable_coordinate_source_fidelity.lean"
```

E10-C establishes directly against the pinned OpenAI comparator:

$$
\boxed{
\deg f=5,\quad
\text{Stable}(f),\quad
\neg\text{Coordinate}(f)
}
$$

and therefore

$$
\boxed{
\neg\forall g\,
(\text{Stable}(g)\to\text{Coordinate}(g))
}
$$

plus the stronger all-fiber statement

$$
\boxed{
\forall t,\;
\operatorname{Fiber}(f-t)\simeq\mathbb A^3
\land
\neg\operatorname{Rectifiable}(t)
}.
$$

Those are exactly the pieces encoded in lines 35–47 of the pinned comparator.

This closes E10 very nicely:
- E10-A: strict implication correctly found by SemantEq (LikelyTooWeak).
- E10-B: true equivalence missed because conjugated automorphisms must be synthesized.
- E10-C: actual pinned comparator faithfully packages the advertised stable noncoordinate counterexample and all-fiber conclusion.
A genuinely good positive-fidelity case

The key scientific conclusion is:

$$
\boxed{\text{OpenAI's Lean target faithfully captures the advertised Stable Coordinate counterexample.}}
$$

And it actually preserves more information than the bare corollary “the conjecture is false.”
