# E20. Parity is not in QAC^0

**Prior expectation:** Positive-fidelity control. The current Result 274
family claim, Lean scope, general comparator, and selected implementation
appear to state the same measured-output parity obstruction.

The main semantic difference is presentational: the human-readable claim
says that every sufficiently large circuit family has some input on which
success falls below the claimed advantage, while the comparator expresses
this as the negation of uniform success on every input.

## References

- OpenAI Result 274: Moore's parity conjecture for QAC^0
- `lean/docs/274.md`
- `ComparatorChallenges/QACParity.lean`
- `ComparatorChallenges/QACParity.json`
- `ComparatorChallenges/RegularParity.lean`
- `ComparatorChallenges/RegularParity.json`
- `OAI/InformationTheory/QuantumCircuit/Parity.lean`
- `OAI/InformationTheory/QuantumCircuit/Main.lean`

## Background

The family result concerns constant-depth quantum circuits built from
arbitrary one-qubit gates and unbounded-arity Toffoli gates.

Ancillary qubits begin in zero, one output qubit is measured, and the
remaining output registers may be discarded.

For every fixed depth, polynomial total-qubit bound, and fixed positive
worst-case advantage epsilon, sufficiently large input sizes contain an
input on which measured-output parity success is less than

$$
\frac12+\varepsilon.
$$

The general Lean comparator quantifies over

$$
0<\varepsilon\le\frac12
$$

and expresses the conclusion as the impossibility of success at least
$(1/2+\varepsilon)$ on every input.

A separate specialization gives success strictly below $(2/3)$ for
ordinary polynomial-size bounds.

## Experiment

### E20-A — source and scope alignment

The current family-level claim and pinned Lean scope agree on the core
result:

- constant circuit depth;
- arbitrary one-qubit gates;
- unbounded-arity Toffoli gates;
- polynomially many total qubits;
- zero-initialized ancillas;
- one measured output qubit;
- unrestricted final garbage;
- no fixed positive worst-case parity advantage.

`QACParity.json` selects:

`OAI.QAC.parity_lower_bound`

from:

`OAI.InformationTheory.QuantumCircuit.Parity`.

`RegularParity.json` separately selects:

`OAI.QAC.parity_lower_bound_polynomial_size`

from:

`OAI.InformationTheory.QuantumCircuit.Main`.

**Prior E20-A classification:** `DirectClaimCoverage`

### E20-B — existential bad input versus negated uniform success

The human-readable formulation says that every admissible sufficiently
large circuit has some input whose success probability is below the
threshold:

$$
\exists x,\quad
Success(x)<\frac12+\varepsilon.
$$

The comparator instead states:

$$
\neg\forall x,\quad
\frac12+\varepsilon\le Success(x).
$$

Over the real numbers these are logically equivalent.

**Prior expectation:** Equivalent.


### E20-B results

SemantEq returned:

```text
verdict: Inconclusive
ref ⇒ cand: not proved
  no proof found in 87 attempts
cand ⇒ ref: not proved
  no proof found in 87 attempts
```

The SemantEq result alone does not establish non-entailment in either
direction.

An independent Lean bridge proved both implications:

$$
R\Rightarrow C
$$

and

$$
C\Rightarrow R.
$$

Thus:

$$
\boxed{R\leftrightarrow C}.
$$

Lean kernel-checked:

```text
QACParityBridge.ref_implies_candidate
QACParityBridge.candidate_implies_ref
QACParityBridge.equivalent
```

with no `sorryAx`.

The reference expresses the parity obstruction as existence of a bad
input:

$$
\exists x,\quad Success(x)<\frac12+\varepsilon,
$$

while the candidate expresses the same claim as failure of uniform
success:

$$
\neg\forall x,\quad
\frac12+\varepsilon\le Success(x).
$$

The two forms are classically equivalent.

Accordingly, both SemantEq failures are proof-search false negatives.

**E20-B classification:** `Equivalent`

### E20-C — actual OpenAI implementation

We checked the actual pinned implementation behind Result 274.

The general theorem is:

`OAI.QAC.parity_lower_bound`.

An independent bridge converted the selected negated-universal conclusion
into the human-readable existential bad-input form.

Lean kernel-checked:

```text
OAI.QAC.parity_lower_bound
ScientificAudit.E20C.actual_implementation_implies_general_existential
```

Both depend only on:

```text
[propext, Classical.choice, Quot.sound]
```

with no `sorryAx`.

We also checked the polynomial-size specialization:

`OAI.QAC.parity_lower_bound_polynomial_size`.

The corresponding bridge established that for sufficiently large input
sizes, every admissible fixed-depth polynomial-size circuit has some input
on which parity success is strictly below

$$
\frac23.
$$

Lean kernel-checked:

```text
OAI.QAC.parity_lower_bound_polynomial_size
ScientificAudit.E20C.actual_implementation_implies_two_thirds
```

again with only:

```text
[propext, Classical.choice, Quot.sound]
```

and no `sorryAx`.

### E20 overall result

Result 274 is a positive-fidelity case.

The public family claim, Lean scope, selected comparator statement, and
actual implementation agree on the core parity lower bound.

The apparent difference between:

$$
\exists x,\quad Success(x)<\frac12+\varepsilon
$$

and:

$$
\neg\forall x,\quad
\frac12+\varepsilon\le Success(x)
$$

is purely logical presentation. Independent Lean proofs establish their
equivalence.

The actual implementation also kernel-checks against the ordinary
polynomial-size \(2/3\) specialization.

Therefore:

$$
\boxed{
\text{family claim}
\;\Longleftrightarrow\;
\text{selected formal statement}
\;\Longleftarrow\;
\text{actual implementation}
}
$$

**Classifications:**

- `DirectClaimCoverage`
- `Equivalent`
- `PositiveFidelityControl`

Artifacts:

- `src/qac_parity_ref.lean`
- `src/qac_parity_candidate.lean`
- `src/qac_parity_bridge.lean`
- `src/qac_parity_openai_bridge.lean`
- `results/E20-B.json`
- `results/E20-B-bridge.txt`
- `results/E20-C-openai-bridge.txt`
- `evidence/e20-a/`

