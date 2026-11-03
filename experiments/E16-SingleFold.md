# E16. Single-fold Diophantine representations and promise undecidability

**Prior expectation:** The selected OpenAI Lean theorem should faithfully formalize the single-fold Diophantine representation claim. The advertised undecidability of Diophantine solvability under an at-most-one-solution promise is not separately formalized, but may follow as a substantive computability consequence of the formalized representation theorem. We therefore expect positive within-scope fidelity and leave support for the downstream undecidability claim unresolved until an explicit bridge is checked.

## References

- [OpenAI Result 242: Single-fold Diophantine representations](https://lance.fortnow.com/openai-math-tcs.htm#f242)
- [OpenAI formalization scope: `242.md`](https://github.com/openai/math/blob/main/lean/docs/242.md)
- [OpenAI Comparator: `SingleFold.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SingleFold.lean)
- [OpenAI Comparator configuration: `SingleFold.json`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/SingleFold.json)
- [OpenAI implementation: `OAI/NumberTheory/SingleFold/Main.lean`](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/SingleFold/Main.lean)

## Background

A Diophantine representation describes membership in a set using solvability of a polynomial equation over natural-number witnesses.

The single-fold requirement is much stronger than ordinary Diophantine representability. For each input belonging to the represented set, there must be exactly one complete auxiliary witness tuple solving the polynomial equation. For an input outside the set, there must be no such witness.

OpenAI Result 242 states that every recursively enumerable set of tuples of natural numbers has such a representation. The catalogue then gives two consequences: the finite-fold conjecture follows, and Diophantine solvability remains undecidable even under a promise that there is at most one solution.

The selected Lean comparator defines `Represents P S` by requiring, for every input `a`,

1. membership in `S` iff some witness makes the polynomial vanish; and
2. any two witnesses making the polynomial vanish are equal.

Thus the existence and uniqueness properties concern the whole witness tuple.

The Lean scope says that this single-fold representation theorem is formalized, while the at-most-one-solution undecidability consequence is not separately formalized.

This creates a different audit question from E15. A consequence need not have its own named theorem in order to be logically supported by a stronger formalized theorem. We therefore distinguish:

$$
\text{direct formalization}
\neq
\text{derivable formal support}.
$$

E16 tests both.

## Experiment

### E16-A — direct claim coverage

Decompose Result 242 into:

- **C1:** every recursively enumerable set has a single-fold Diophantine representation;
- **C2:** the finite-fold conjecture follows;
- **C3:** Diophantine solvability remains undecidable under an at-most-one-solution promise.

The selected Lean target is `OAI.SingleFold.main`.

The formalization scope explicitly identifies C1 as the formalized result and says C3 is not separately formalized.

Accordingly:

- **C1:** `TARGETED`
- **C2:** `ADVERTISED_CONSEQUENCE`
- **C3:** `NOT_SEPARATELY_FORMALIZED`

For C2 and C3, this is not yet a finding of missing semantic support. Their derivability from C1 is a separate question.

### E16-B — within-scope single-fold fidelity

Compare two logically natural formulations of the single-fold property.

The source-shaped formulation says:

$$
a\in S \leftrightarrow \exists w,\ R(a,w),
$$

together with global uniqueness:

$$
R(a,w)\land R(a,v)\Rightarrow w=v.
$$

The prose-shaped formulation says:

- if \(a\in S\), there exists exactly one witness;
- if \(a\notin S\), there is no witness.

These should be logically equivalent.

**Prior expectation:** Equivalent, with the reverse direction requiring a classical case split or equivalent reasoning.

### E16-A Freeze evidence

from scientific_audit/openai-math/ 

```
mkdir -p ../evidence/e16-a

cp overview.tex \
  ../evidence/e16-a/overview.tex

cp lean/docs/242.md \
  ../evidence/e16-a/242.md

cp lean/ComparatorChallenges/SingleFold.lean \
  ../evidence/e16-a/SingleFold.lean

cp lean/ComparatorChallenges/SingleFold.json \
  ../evidence/e16-a/SingleFold.json

cp lean/OAI/NumberTheory/SingleFold/Main.lean \
  ../evidence/e16-a/Main.lean

shasum -a 256 \
  overview.tex \
  lean/docs/242.md \
  lean/ComparatorChallenges/SingleFold.lean \
  lean/ComparatorChallenges/SingleFold.json \
  lean/OAI/NumberTheory/SingleFold/Main.lean

echo
shasum -a 256 \
  ../evidence/e16-a/overview.tex \
  ../evidence/e16-a/242.md \
  ../evidence/e16-a/SingleFold.lean \
  ../evidence/e16-a/SingleFold.json \
  ../evidence/e16-a/Main.lean
```


### E16-B

```
lake exe semanteq --strict --timeout 0 \
  ../src/singlefold_ref.lean \
  ../src/singlefold_candidate.lean
semanteq v1.4.0  git f927670  2026-11-03T01:18:36Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing singlefold_ref__vs__singlefold_candidate
── singlefold_ref__vs__singlefold_candidate
   verdict: Inconclusive   (256292 ms)
   ref ⇒ cand: not proved
      no proof found in 75 attempts
   cand ⇒ ref: not proved
      no proof found in 75 attempts
(base) [Mon Nov 02-18:28:14][mkm@mactop SemantEq]$

```

bridge.

```
 lake env lean ../src/singlefold_bridge.lean 2>&1 \
  | tee ../results/E16-B-bridge.txt
'SingleFoldAuditBridge.equivalent' depends on axioms: [propext,
 Classical.choice,
 Quot.sound,
 Input,
 Member,
 Solves,
 Witness]
```

The bridge proves:

$$
\boxed{\text{RefStatement} \leftrightarrow \text{CandidateStatement}}
$$

and the axiom report is exactly what we’d expect.



SemantEq v1.4.0 (`f927670`) returned:

- verdict: `Inconclusive`
- reference -> candidate: not proved after 75 attempts
- candidate -> reference: not proved after 75 attempts
- runtime: 256292 ms

This was contrary to the frozen prior expectation of equivalence.

We therefore constructed an independent Lean bridge over the same abstract signature.

The reference formulation states:

$$
a\in S \leftrightarrow \exists w,\ R(a,w)
$$

together with global uniqueness:

$$
R(a,w)\land R(a,v)\Rightarrow w=v.
$$

The candidate formulation states:

$$
a\in S\Rightarrow \exists!w,\ R(a,w)
$$

and

$$
a\notin S\Rightarrow \neg\exists w,\ R(a,w).
$$

Lean kernel-checked both implications and therefore proved:

$$
\boxed{R\leftrightarrow C}.
$$

The reverse direction uses classical reasoning: an observed witness rules out nonmembership because nonmembership implies absence of every witness; the `ExistsUnique` hypothesis then supplies uniqueness.


### E16-C1


$$
\boxed{
\texttt{OAI.SingleFold.main}
\stackrel{?}{\Longrightarrow}
\text{undecidability under the at-most-one-solution promise}
}
$$

```
cd scientific_audit/openai-math/lean/
lake build +OAI.NumberTheory.SingleFold.Main

ls -l .lake/build/lib/lean/OAI/NumberTheory/SingleFold/Main.olean
AUDIT_ROOT="$(cd ../.. && pwd)"
lake env lean \
  "$AUDIT_ROOT/src/singlefold_openai_consequence_bridge.lean" 2>&1 \
  | tee "$AUDIT_ROOT/results/E16-C1-openai-bridge.txt"
```


we have already proved something substantial:

$$
\boxed{
\begin{array}{c}
p\text{ recursively enumerable}\\
p\text{ noncomputable}
\end{array}
\quad\Longrightarrow\quad
\exists P:
\begin{cases}
p(a)\iff\exists w,\;P(a,w)=0,\\
\text{at most one }w\text{ solves it},\\
\text{solvability of }P(a,-)\text{ is noncomputable}.
\end{cases}}
$$

Notice what makes this much stronger than E16-B: there is no SemantEq restatement game here. We are consuming the real OpenAI theorem and proving a downstream computability result.


### E16-C2


```
AUDIT_ROOT="$(cd ../.. && pwd)"

lake env lean \
  "$AUDIT_ROOT/src/singlefold_openai_consequence_bridge.lean" 2>&1 \
  | tee "$AUDIT_ROOT/results/E16-C2-openai-bridge.txt"
```



We next tested whether the advertised at-most-one-solution undecidability
consequence is genuinely supported by the selected OpenAI theorem, despite
not being separately formalized in the OpenAI scope note.

Using the pinned OpenAI implementation `OAI.SingleFold.main`, we first
proved a generic consequence:

for every recursively enumerable but noncomputable predicate \(p\), there
exists a polynomial family \(P(a,w)\) such that

$$
p(a) \leftrightarrow \exists w,\;P(a,w)=0,
$$

any two zero witnesses for the same parameter are equal,

$$
P(a,w)=0 \land P(a,v)=0 \Rightarrow w=v,
$$

and the solvability predicate

$$
a\mapsto\exists w,\;P(a,w)=0
$$

is itself noncomputable.

We then instantiated this generic bridge with the halting problem. The
single coordinate of \(a : \mathrm{Fin}\ 1\to\mathbb N\) is interpreted as
the code of a partial-recursive program. Mathlib supplies recursive
enumerability and noncomputability of the resulting halting predicate.

Lean kernel-checked both the generic bridge and the concrete halting
instance.

`#print axioms` reported for both:

```text
[propext, Classical.choice, Quot.sound]
```

No sorryAx occurs.

Therefore the selected OpenAI single-fold theorem entails the existence
of a fixed Diophantine family whose parameterized solvability problem is
undecidable even though every parameter instance has at most one witness.
\[
\boxed{
\texttt{OAI.SingleFold.main}
\Rightarrow
\text{undecidable single-fold Diophantine solvability family}
}
\]
This establishes the substantive computability reduction advertised in
the public discussion.

A final exact-formulation check remains useful: convert each parameter
\(a\) computably into the specialized polynomial \(Q_a(w)=P(a,w)\), so
that the conclusion is stated directly as an H10-style decision problem
whose input is a polynomial promised to have at most one solution.

Artifacts:
- src/singlefold_openai_consequence_bridge.lean
- results/E16-C1-openai-bridge.txt
- results/E16-C2-openai-bridge.txt




### E16-C3

We have formally moved from the parameterized polynomial

$$
P(a,w)
$$

to an ordinary polynomial instance

$$
Q_a(w):=P(a,w)
$$

for every input \(a\), and kernel-checked:

$$
\operatorname{Halting}(a)
\iff
\exists w,\ Q_a(w)=0,
$$

while

$$
Q_a(w)=0\land Q_a(v)=0
\Longrightarrow w=v.
$$

Thus every resulting polynomial instance satisfies the promise

$$
\#\{w:Q_a(w)=0\}\le1,
$$

yet solvability across the family is undecidable.

That is the exact mathematical specialization step we were missing.

There is one final distinction I want us to preserve in the write-up. Mathlib's MvPolynomial is based on Finsupp and is largely noncomputable as a data structure, so this theorem still does not itself provide a Turing-machine encoding of arbitrary polynomial syntax. 

So if C3 succeeds, I think our strongest precise conclusion is:

$$
\boxed{
\text{OpenAI's theorem formally entails the mathematical core of the
at-most-one-solution undecidability consequence.}
}
$$

The only thing not yet internalized in Lean would be the conventional computable coding of polynomial instances as machine inputs. That is an encoding layer, not another mathematical reduction.

```
AUDIT_ROOT="$(cd ../.. && pwd)"

lake env lean \
  "$AUDIT_ROOT/src/singlefold_openai_consequence_bridge.lean" 2>&1 \
  | tee "$AUDIT_ROOT/results/E16-C3-specialization-bridge.txt"
```

We finally formalized the specialization step from the parameterized
single-fold polynomial

$$
P(a,w)
$$

to an ordinary witness-only polynomial instance

$$
Q_a(w):=P(a,w).
$$

For a polynomial

$$
P\in\mathbb Z[a,w],
$$

`specialize P a` substitutes the natural-number parameter tuple \(a\) as
integer constants while leaving the witness variables free.

We independently proved:

$$
\operatorname{eval}(\operatorname{specialize}(P,a),w)
=
\operatorname{evalNat}(P,a,w).
$$

Using this identity together with the C2 halting reduction, Lean
kernel-checked the existence of a polynomial family whose specialized
instances satisfy

$$
\operatorname{Halting}(a)
\leftrightarrow
\exists w,\;Q_a(w)=0
$$

and

$$
Q_a(w)=0\land Q_a(v)=0
\Rightarrow
w=v.
$$

Thus every specialized polynomial instance has at most one natural-number
solution, while solvability across the family is noncomputable.

`#print axioms ScientificAudit.E16C.halting_specialized_polynomial_instances`
reported:

```text
[propext, Classical.choice, Quot.sound]
```

No sorryAx occurs.

Therefore:

$$
\boxed{
\texttt{OAI.SingleFold.main}
\Rightarrow
\text{undecidable solvability for a family of ordinary polynomial
instances, each having at most one solution}
}
$$

This kernel-checks the mathematical and computability core of the
at-most-one-solution consequence advertised for Result 242.

One encoding-level qualification remains. The audit has not separately
formalized a computable finite syntax encoding

$$
a\mapsto \operatorname{code}(Q_a)
$$

for MvPolynomial instances. Accordingly, we do not claim that the
complete machine-level H10 decision problem over encoded polynomial input
has itself been packaged as a Lean theorem here. What is established is
the substantive reduction from halting to solvability of specialized
single-fold Diophantine instances.

Artifacts:
- src/singlefold_openai_consequence_bridge.lean
- results/E16-C1-openai-bridge.txt
- results/E16-C2-openai-bridge.txt
- results/E16-C3-specialization-bridge.txt
