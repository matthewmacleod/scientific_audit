# E17. Weak normalization implies strong normalization in pure type systems

**Prior expectation:** Strong positive-fidelity control. The public result, formalization scope, comparator statement, and selected implementation all appear to state the same system-wide implication. SemantEq should recognize equivalence between the predicate-packaged comparator formulation and an expanded formulation of the same weak- and strong-normalization conditions.

## References

- [OpenAI Result 245: the beta-Barendregt-Geuvers-Klop conjecture](https://lance.fortnow.com/openai-math-tcs.htm#f245)
- [OpenAI formalization scope: `245.md`](https://github.com/openai/math/blob/main/lean/docs/245.md)
- [OpenAI Comparator: `TypeSystemNormalization.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/TypeSystemNormalization.lean)
- [OpenAI Comparator configuration: `TypeSystemNormalization.json`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/TypeSystemNormalization.json)
- [OpenAI implementation: `OAI/Computability/TypeSystem/Normalization.lean`](https://github.com/openai/math/blob/main/lean/OAI/Computability/TypeSystem/Normalization.lean)

## Background

Weak and strong normalization are very different termination properties.

An expression is weakly normalizing when there exists at least one finite beta-reduction path leading to a normal form:

$$
WN(M) :=
\exists N,\;M\to_\beta^*N \land Normal(N).
$$

Strong normalization requires every possible reduction process to terminate. The OpenAI comparator formalizes this using accessibility of the converse beta-reduction relation:

$$
SN(M) :=
Acc(\lambda N\,M.\;M\to_\beta N,\;M).
$$

The theorem is not merely an implication for one term. It is system-wide. Weak normalization requires every legal expression in every valid context to be weakly normalizing, while strong normalization requires every such expression to be strongly normalizing.

This makes the theorem striking: existence of some terminating reduction path for each legal term is upgraded to termination of every reduction path.

The formalization also retains reductions inside type annotations and permits arbitrary sorts and nonfunctional axioms and product rules.

## Experiment

### E17-A — source and scope alignment

Result 245, `lean/docs/245.md`, and `TypeSystemNormalization.lean` all identify the target as the beta-Barendregt-Geuvers-Klop conjecture:

$$
SystemWeaklyNormalizing(P)
\Rightarrow
SystemStronglyNormalizing(P)
$$

for every pure type system \(P\).

The comparator configuration selects exactly:

`OAI.PureTypeSystem.weak_implies_strong`

from:

`OAI.Computability.TypeSystem.Normalization`.

No separate companion theorem or explicit scope exclusion appears in the result-245 Lean note.

**E17-A prior:** full direct claim coverage.

### E17-B — predicate form versus expanded normalization conditions

Compare two formulations of the same theorem.

The reference spells out weak and strong normalization directly:

- weak normalization is existence of a beta-reachable normal form;
- strong normalization is accessibility of the converse beta relation;
- both are quantified over every legal expression in every valid context.

The candidate packages those same conditions behind `Normal`,
`WeaklyNormalizing`, `StronglyNormalizing`,
`SystemWeaklyNormalizing`, and `SystemStronglyNormalizing`.

**Prior expectation:** Equivalent after definition unfolding.

This is intended as a positive calibration case. Unlike E15 and E16, no substantive mathematical bridge should be required to establish equivalence between the two audit statements.

#### E17-B results

Results

```
lake exe semanteq --strict --timeout 0 \
  ../src/normalization_ref.lean \
  ../src/normalization_candidate.lean
semanteq v1.4.0  git f927670  2026-11-03T14:24:15Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing normalization_ref__vs__normalization_candidate
── normalization_ref__vs__normalization_candidate
   verdict: ExactMatch   (499 ms)
   identical statements, no implication proof needed
(base) [Tue Nov 03-07:29:28][mkm@mactop SemantEq]$
```



SemantEq v1.4.0 (`f927670`) returned:

- verdict: `ExactMatch`
- runtime: 499 ms
- identical statements, no implication proof needed

This is stronger than the frozen expectation of ordinary equivalence.

After unfolding the packaged normalization predicates, the expanded
claim-shaped reference and comparator-shaped candidate normalize to the
same proposition.

Thus SemantEq did not need to prove

$$
R \Rightarrow C
$$

and

$$
C \Rightarrow R
$$

separately. It identified the statements as structurally identical after
normalization.

$$
\boxed{\text{E17-B: ExactMatch}}
$$

This serves as a clean positive calibration case for the study. The
difference between the two source files is almost entirely definitional
packaging:

$$
Normal(M)
$$

versus its expansion,

$$
\forall N,\neg Beta(M,N),
$$

together with analogous unfolding of weak normalization, strong
normalization, and the corresponding system-wide predicates.

Unlike E15-B and E16-B, no proof-search incompleteness appears here.

Artifacts:

- `src/normalization_ref.lean`
- `src/normalization_candidate.lean`
- `results/E17-B.json`


#### E16-C

from `scientific_audit/openai-math/lean`

```
lake build +OAI.Computability.TypeSystem.Normalization

ls -l \
  .lake/build/lib/lean/OAI/Computability/TypeSystem/Normalization.olean
```

```
AUDIT_ROOT="$(cd ../.. && pwd)"

lake env lean \
  "$AUDIT_ROOT/src/normalization_openai_bridge.lean" 2>&1 \
  | tee "$AUDIT_ROOT/results/E17-C-openai-bridge.txt"
```

e finally checked the selected OpenAI implementation directly.

The pinned theorem is:

`OAI.PureTypeSystem.weak_implies_strong`

from:

`OAI/Computability/TypeSystem/Normalization.lean`.

We constructed an independent bridge from the actual OpenAI theorem to
the fully expanded claim-shaped formulation used in E17-B.

The bridge assumes directly that every legal term in every valid context
has some beta-reduction path to a normal form:

$$
\forall \Gamma,M,\;
ValidContext(P,\Gamma)\land Legal(P,\Gamma,M)
\Rightarrow
\exists N,\;
M\to_\beta^*N
\land
\forall K,\neg(N\to_\beta K).
$$

It then invokes the actual OpenAI theorem and derives that every such term
is accessible under the converse beta-reduction relation:

$$
\forall \Gamma,M,\;
ValidContext(P,\Gamma)\land Legal(P,\Gamma,M)
\Rightarrow
Acc(\leftarrow_\beta,M).
$$

Lean kernel-checked the bridge successfully.

`#print axioms OAI.PureTypeSystem.weak_implies_strong` reported:

```text
[propext, Classical.choice, Quot.sound]
```

#print axioms ScientificAudit.E17C.actual_implementation_implies_expanded
reported the same:
[propext, Classical.choice, Quot.sound]

No sorryAx occurs in either theorem.

Therefore:

$$
\boxed{
\texttt{OAI.PureTypeSystem.weak_implies_strong}
\Rightarrow
\text{expanded weak-normalization-to-strong-normalization claim}
}
$$

Combined with E17-B, where SemantEq returned ExactMatch, this gives a
clean positive-fidelity result:

$$
\boxed{
\text{public/formal scope}
\equiv
\text{neutral reference}
\equiv
\text{comparator}
\longleftarrow
\text{kernel-checked implementation}
}
$$

E17 overall result
E17 is a strong positive control.
- family-level claim coverage: direct
- scope mismatch: none identified
- SemantEq result: ExactMatch
- independent implementation bridge: kernel-checked
- trusted axioms: propext, Classical.choice, Quot.sound
- sorryAx: absent
Unlike E15 and E16, E17 exhibits neither a provenance mismatch nor a
SemantEq proof-search miss.

Artifacts:
- src/normalization_ref.lean
- src/normalization_candidate.lean
- src/normalization_openai_bridge.lean
- results/E17-B.json
- results/E17-C-openai-bridge.txt
- evidence/e17-a/
