# E6. Borsuk dimension nine: ambient representation invariance


**Prior expectation:** Probably equivalent after an explicit affine-isometric identification.

## References

- [OpenAI formalization scope: Borsuk's conjecture fails in dimension nine](https://github.com/openai/math/blob/main/lean/docs/156.md)
- [OpenAI Comparator: `BorsukNine.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/BorsukNine.lean)
- [Wikipedia](https://en.wikipedia.org/wiki/Borsuk%27s_conjecture)
- [Gil Kalai’s blog](https://gilkalai.wordpress.com/2009/06/21/borsuks-conjecture/)

## Experiment

Compare the formal counterexample expressed as a set of rank-one orthogonal projectors inside the affine space of trace-one symmetric $4\times4$ matrices with the scientific statement that there is a Borsuk counterexample in $\mathbb R^9$.

The relevant representation fact is that the trace-one symmetric matrices form a nine-dimensional affine Euclidean space. The audit asks whether the Borsuk property is preserved under the explicit affine-isometric transport into $\mathbb R^9$.

This extends the Kakeya positive-control idea from reparameterization of an object to a change of ambient representation.

## Results


## E6-A

Let’s first remove the dimensional representation issue entirely and ask whether SemantEq recognizes the simple logical relationship:

$$
\text{this particular set works}
\Rightarrow
\exists S,\;\text{some set works}.
$$

Here the candidate is stronger:

$$
\boxed{\text{candidate}\Rightarrow\text{reference}}
$$

simply by choosing

$$
S:=\texttt{projectorSet}.
$$

We do not expect

$$
\text{reference}\Rightarrow\text{candidate},
$$

because knowing that some counterexample exists doesn't establish that this particular projector construction is one.

That gives us a clean baseline before introducing the hard affine/isometry bridge.

```
 lake exe semanteq --strict --timeout 0 \
  ../src/borsuk_existential_ref.lean \
  ../src/borsuk_projector_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T15:29:07Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing borsuk_existential_ref__vs__borsuk_projector_candidate
── borsuk_existential_ref__vs__borsuk_projector_candidate
   verdict: Inconclusive   (570091 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
``` 

E6-A gave:

$$
\boxed{\texttt{Inconclusive}}
$$

with neither direction found after 87 attempts.

But our frozen prior was:

$$
\text{candidate}\Rightarrow\text{reference},
$$

because the candidate literally says that this particular set projectorSet has the required properties, while the reference only asks that some set have them.

So the expected proof is basically:

$$
P(\texttt{projectorSet})
\Rightarrow
\exists S,\;P(S)
$$

by choosing

$$
S:=\texttt{projectorSet}.
$$

SemantEq missed that.

Proves the miss:
```
lake env lean ../src/borsuk_existential_bridge.lean
```

## E6-B

E6-B should isolate one question: does an isometric embedding preserve the Borsuk obstruction—compactness, diameter, and impossibility of a 10-set smaller-diameter cover? If we can prove that cleanly, then later moving the projector witness from its matrix model into \(\mathbb R^9\) becomes a representation change rather than a new combinatorial argument.

We want to hold the combinatorial claim fixed and change only the ambient metric representation by an isometric equivalence \(e\):

$$
S \subseteq X
\qquad\longmapsto\qquad
e(S)\subseteq Y.
$$

The Borsuk obstruction should be invariant because an isometry preserves distances, hence diameter, and a small-diameter cover can be pushed forward or pulled back bijectively. Mathlib already has IsometryEquiv.diam_image, while isometries are continuous and injective.

There are really three invariances nested here:

$$
\operatorname{compact}(S)
\iff
\operatorname{compact}(eS),
$$

$$
\operatorname{diam}(S)
=
\operatorname{diam}(eS),
$$

and most interestingly,

$$
\operatorname{HasTenSmallCover}(S,r)
\iff
\operatorname{HasTenSmallCover}(eS,r).
$$

The last one follows because if

$$
S\subseteq \bigcup_{i=1}^{10}C_i
$$

with each \(C_i\) small, then

$$
e(S)\subseteq\bigcup_{i=1}^{10}e(C_i),
$$

and

$$
\operatorname{diam}(e(C_i))
=
\operatorname{diam}(C_i).
$$

Conversely, because transport is an isometric equivalence, use transport.symm to pull the cover back. Mathlib directly supplies preservation of diameter under an IsometryEquiv. Lean Community

So if SemantEq returns Inconclusive, this will be quite different from E6-A: it will be missing a genuine metric/geometric invariance bridge, not merely an existential witness.

```
 lake exe semanteq --strict --timeout 0   ../src/borsuk_isometry_ref.lean   ../src/borsuk_isometry_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T17:00:39Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing borsuk_isometry_ref__vs__borsuk_isometry_candidate
── borsuk_isometry_ref__vs__borsuk_isometry_candidate
   verdict: Inconclusive   (354466 ms)
   ref ⇒ cand: not proved
      no proof found in 87 attempts
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```

Inconclusive.

Unlike E6-A, though, this is not just existential-witness synthesis. The missing bridge is genuinely geometric: isometries preserve compactness and metric diameter, and bijectivity lets us push a finite cover forward and pull it back. Mathlib explicitly provides continuity of an IsometryEquiv and preservation of Metric.diam under an isometry.

Check bridge

```
lake env lean ../src/borsuk_isometry_bridge.lean
```

E6-B is now formally closed:

$$
\boxed{
\operatorname{BorsukObstruction}(S,r)
\iff
\operatorname{BorsukObstruction}(e[S],r)
}
$$

for any isometric equivalence \(e\).

So the actual relationship is genuine equivalence, while untouched SemantEq returned:
Inconclusive
ref ⇒ cand: not proved
cand ⇒ ref: not proved

This gives us another very clean auditor limitation, but a different kind from E6-A:
- E6-A: missed obvious existential-witness introduction.
- E6-B: missed a compositional geometric invariance involving compactness, diameter preservation, cover transport, and bijectivity.


## E6-C

E6-C in two tightly connected pieces:
- C1: prove the direction space of trace-one symmetric $(4\times4)$ matrices has dimension $(9)$.
- C2: use that dimension theorem to obtain a genuine linear isometry $ V \simeq_i \mathbb R^9$.

OpenAI’s source defines the ambient space as 16-dimensional EuclideanSpace ℝ (Fin 4 × Fin 4) and imposes symmetry plus one trace equation. GitHub We can encode those as seven independent linear constraints: six off-diagonal symmetry equations plus trace $(=0)$. Rank-nullity should then give $(16-7=9)$. Mathlib has exactly the finite-dimensional rank-nullity theorem we need.

```
lake env lean ../src/borsuk_tracezero_dimension.lean
```
clean.

We have formally established:

$$
\dim_{\mathbb R}\{A\in\mathbb R^{4\times4}:A^T=A,\ \operatorname{tr}A=0\}=9,
$$

and, more strongly, constructed an actual linear isometry

$$
\boxed{
\text{TraceZeroSymmetric}
\simeq_i
\mathbb R^9
}
$$

via an orthonormal basis.

So this is not merely a dimension-count argument. We now have the metric-preserving coordinate representation needed for Borsuk.

The proof structure is also very clean:

$$
16\text{ ambient coordinates}
-
6\text{ symmetry constraints}
-
1\text{ trace constraint}
=
9.
$$

And because the constraint map was explicitly shown surjective, the $(16-7=9)$ count is genuinely certified by rank-nullity rather than assumed.

So E6 currently looks like:
- E6-A: specific projector witness ⇒ existential Borsuk witness; SemantEq missed it.
- E6-B: Borsuk obstruction invariant under isometric equivalence; Lean proves ↔, SemantEq Inconclusive.
- E6-C1: trace-zero symmetric \(4\times4\) space has dimension 9.
- E6-C2: that space is linearly isometric to \(\mathbb R^9\).

## E6-C3

E6-C3 is the last representation step: prove that OpenAI’s actual affine set

$$
\{A:A^T=A,\ \operatorname{tr}A=1\}
$$

is an isometric translate of this trace-zero direction space. Then we compose that translation with traceZeroToR9, and Borsuk’s matrix representation is genuinely an isometric copy of $(\mathbb R^9)$.


```
lake env lean ../src/borsuk_traceone_affine_bridge.lean
```

We now have a kernel-checked chain:

$$
\text{source trace-one symmetric }4\times4\text{ matrices}
\simeq_i
\text{trace-zero symmetric direction space}
\simeq_i
\mathbb R^9.
$$

More concretely:
- C1: the trace-zero symmetric direction space has dimension $(9)$;
- C2: it is linearly isometric to EuclideanSpace ℝ (Fin 9);
- C3: the actual trace-one affine slice used by OpenAI is an isometric translate of that direction space, and therefore itself isometric to $(\mathbb R^9)$.
That means we’ve now justified the phrase “nine-dimensional” metrically, not merely by counting parameters.


The important result is already there:

$$
\boxed{
\text{OpenAI projector theorem}
\Rightarrow
\exists S\subseteq\mathbb R^9\;
\text{BorsukObstruction}(S,\sqrt2)
}
$$

with a kernel-checked Lean bridge.

E6-D has succeeded and that means E6 as a whole is now quite strong:

- E6-A: SemantEq missed the existential witness.
- E6-B: SemantEq missed genuine isometric invariance, which we proved both ways.
- E6-C: we formally proved the trace-one symmetric matrix representation really is isometric to $(\mathbb R^9)$.
- E6-D: we transported OpenAI’s actual projector witness into ordinary $(\mathbb R^9)$.

This is a very nice positive fidelity result for OpenAI’s Borsuk formalization.











