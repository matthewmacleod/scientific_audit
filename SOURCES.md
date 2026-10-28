# Sources and provenance for audit targets

## OpenAI comparator

Current `ComparatorChallenges/LocalSmoothing.lean` defines:

- `Space n := EuclideanSpace ℝ (Fin n)`
- `unitSegment ω x := { y | ∃ t ∈ [-1/2,1/2], y = x + t • ω }`
- `IsKakeyaSet F := ∀ ω, ‖ω‖ = 1 → ∃ x, unitSegment ω x ⊆ F`
- `kakeya : ∀ n ≥ 2, ∀ F, IsKakeyaSet F → dimH F = n`

OpenAI Lean toolchain at retrieval: Lean 4.34.1.

## Independent trusted formalization

leanprover/lean-eval commit:
`3f3786f3b4d9a4b64a5859b3036aca190cd25613`

`generated/wang_zahl_kakeya_dimH/ChallengeDeps.lean` defines in dimension 3:

- `Space := EuclideanSpace ℝ (Fin 3)`
- `IsKakeya K := IsCompact K ∧ ∀ v, ‖v‖ = 1 → ∃ x, ∀ t ∈ [0,1], x + t • v ∈ K`

and the challenge theorem is:

- `wang_zahl_kakeya_dimH {K} (hK : IsKakeya K) : dimH K = 3`

lean-eval toolchain at that commit: Lean 4.32.2.

## Why there are two probes

The exact trusted reference includes compactness; OpenAI's comparator explicitly does not.
The literature contains compact, Borel, and arbitrary-set formulations, and Keleti--Máthé
(2022) proves these forms of the Kakeya conjecture equivalent. That equivalence is
substantive mathematics, however, not merely a local change of notation or segment
parameterization. Therefore:

1. the geometry-only fixtures remove compactness to test semantic identity of the
   two segment parameterizations; and
2. `src/oai3_to_trusted_compact.lean` tests the exact one-way authorization from the
   stronger OpenAI statement to lean-eval's trusted compact statement.


## MUB / Result 266 sources

### OpenAI manuscript claim

OpenAI's September 24, 2026 manuscript:

`The maximum number of mutually unbiased bases in dimension six`

claims that the maximum number of pairwise mutually unbiased orthonormal bases in
$(\mathbb C^6)$ is three:

$$
N(6)=3.
$$

The upper bound is computer-assisted. The manuscript states that its verification
pipeline excludes four arbitrary complex bases under the specified binary64
arithmetic and compiler conditions.

Source:

- https://mathcommunity.github.io/oai-math-revised/papers/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026/

Three MUBs in dimension six were already known to exist, so the novel part relevant
to the upper bound is:

$$
N(6)\le 3.
$$

### OpenAI Lean scope

OpenAI's scope note for family 266 is:

`lean/docs/266.md`

It explicitly distinguishes the manuscript claim from the associated Lean
formalization. The scope note states that the manuscript claims at most three
mutually unbiased orthonormal bases in \(\mathbb C^6\), while the linked Lean
formalization proves the weaker family bound:

$$
N(6)\le 5.
$$

It further states that the selected Lean statement does **not** establish either:

- the manuscript's upper bound of three; or
- the computer-assisted exclusion of four arbitrary bases.

Source:

- https://github.com/openai/math/blob/main/lean/docs/266.md

### OpenAI comparator statement

The relevant comparator is:

`lean/ComparatorChallenges/MUBSix.lean`

It defines:

```text
Coord := Fin 6
Space := EuclideanSpace ℂ Coord
Basis := OrthonormalBasis Coord ℂ Space
```

and:

```text
IsMUBFamily {n} (B : Fin n → Basis) :=
    ∀ r s, r ≠ s → ∀ i j,
      Complex.normSq (inner ℂ (B r i) (B s j)) = 1 / 6
```

with:

```text
Attainable (n : ℕ) :=
    ∃ B : Fin n → Basis, IsMUBFamily B
```

The MUB-family component of `fourier_and_family_bound` is:

```text
∀ n : ℕ, Attainable n → n ≤ 5
```

The complete comparator theorem conjoins this bound with a separate Fourier
character-sum vanishing result for order-six complex Hadamard matrices.

Source:

- https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MUBSix.lean

OpenAI Lean toolchain at retrieval:

```text
leanprover/lean4:v4.34.1
```

Source:

- https://github.com/openai/math/blob/main/lean/lean-toolchain

The comparator file is the challenge specification and therefore contains `sorry`;
our audit uses the proposition being specified, not the `sorry` as evidence of a
completed proof.

### Separate computer-assisted evidence

The $(\le 3)$ manuscript claim should not be conflated with the weaker Lean
$(\le 5)$ theorem.

OpenAI's current repository history states that the C++ source and saved numerical
records for the computation excluding a fourth mutually unbiased basis were later
restored, together with a Python checker for consistency and coverage of the saved
records.

Source:

- https://github.com/openai/math/blob/main/history.md

Accordingly, this SemantEq experiment audits the documented mismatch between the
headline/manuscript upper bound and the associated Lean family-bound statement. It
does **not** audit the separate computer-assisted exclusion of four MUBs.

### Controlled SemantEq probe

To isolate statement strength from ontology or representation differences, the two fixtures use the same MUB definitions.

`src/mub_headline_ref.lean` represents the manuscript/headline upper bound:

$$
\forall n,\; Attainable(n)\rightarrow n\le3.
$$

`src/mub_oai_candidate.lean` represents the documented Lean family bound:

$$
\forall n,\; Attainable(n)\rightarrow n\le5.
$$

The fixtures transcribe the statement-level MUB model into SemantEq's pinned
Lean/Mathlib environment. They do not directly import OpenAI's Lean 4.34.1 project.

This probe therefore asks a deliberately narrow question:

> Does the formal $(\le5)$ bound express the same claim as the manuscript's
> $(\le3)$ upper bound under SemantEq's restricted transformation relation?

### Observed SemantEq result

Run:

```bash
lake exe semanteq --strict --timeout 0 \
  ../src/mub_headline_ref.lean \
  ../src/mub_oai_candidate.lean
```

Observed with:

```text
SemantEq v1.4.0
git f927670
strict mode
timeout disabled
```

Result:

```text
verdict: LikelyTooWeak

ref ⇒ cand: proved
cand ⇒ ref: not proved
    no proof found in 87 attempts
```

The accepted forward transformation rewrites the natural-number bound using
`Nat.le_succ_iff` and then performs structural weakening. Thus SemantEq establishes the expected one-way relationship:

$$
N(6)\le3
\Longrightarrow
N(6)\le5.
$$

It does not certify the reverse restricted transformation. The correct interpretation is therefore:

$$
\boxed{
\text{SemantEq-Eval classifies the }\le5\text{ candidate as LikelyTooWeak
relative to the }\le3\text{ reference.}
}
$$

Because SemantEq's search is incomplete, failure to find the reverse transformation
is not a proof that no mathematical implication can exist. The result means that
bidirectional restricted semantic equivalence was **not certified**.

Raw result:

- [`results/mub.json`](./results/mub.json)

### Independent fidelity reference

MathVet independently classifies OpenAI family 266's Lean formalization as weaker than the associated headline/manuscript claim.

Source:

- https://math.vet/openai-math/
