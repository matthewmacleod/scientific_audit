# E15. Shelah: family-level coverage and the prescribed-threshold obstruction

**Prior expectation:** The selected OpenAI Lean theorem should faithfully support the CH prescribed-threshold obstruction, but it should not cover the separate eventual-categoricity theorem presented as the headline result of family 240. We therefore expect partial family-level formalization coverage, followed by positive fidelity within the theorem that is actually targeted.

## References

- [OpenAI Result 240: Shelah's eventual categoricity and the prescribed-threshold obstruction](https://lance.fortnow.com/openai-math-tcs.htm#f240)
- [OpenAI formalization scope: `240.md`](https://github.com/openai/math/blob/main/lean/docs/240.md)
- [OpenAI Comparator: `CHObstruction.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/CHObstruction.lean)
- [OpenAI Comparator configuration: `CHObstruction.json`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/CHObstruction.json)
- [OpenAI implementation: `OAI/ModelTheory/Categoricity/Main.lean`](https://github.com/openai/math/blob/main/lean/OAI/ModelTheory/Categoricity/Main.lean)

## Background

This result family concerns categoricity in abstract elementary classes (AECs). Roughly, a class is categorical in a cardinal when it has, up to isomorphism, exactly one model of that size.

Shelah's eventual categoricity conjecture says that, once an AEC is categorical sufficiently high in the cardinal hierarchy, categoricity should persist throughout the tail above some threshold. Result family 240 presents a proof of this eventual-categoricity phenomenon in ZFC.

The same family also contains a different result about where such a threshold can be placed. Under the continuum hypothesis, the prescribed Hanf threshold can fail: there is an AEC with two nonisomorphic models at the Hanf point while the class is categorical throughout a later tail.

These are related model-theoretic results, but they are not two formulations of the same theorem.

That distinction matters for the audit. OpenAI's Lean scope explicitly says that the formalization covers the CH prescribed-threshold obstruction and that the separate eventual-categoricity theorem is not included.

E15 therefore has two parts.

E15-A asks a provenance question: which claims in the public result family are actually represented by the selected Lean artifact?

E15-B then asks the ordinary semantic-fidelity question within the claim that is represented: does the formal CH-obstruction theorem faithfully express the stated prescribed-threshold obstruction?

This lets us separate two relations that can otherwise be conflated:

$$
\text{claim coverage} \neq \text{semantic fidelity}.
$$

A formal theorem can be completely faithful to the theorem it formalizes while still covering only part of the scientific result family to which it is attached.

## Experiment

### E15-A

Decompose OpenAI Result 240 into its two substantive claims:

- **C1:** eventual categoricity in ZFC;
- **C2:** the CH prescribed-threshold obstruction.

Then inspect the formalization scope, comparator configuration, and selected Lean theorem to determine which of those claims is represented by the formal artifact.

This is a source-to-artifact coverage audit, not a SemantEq comparison. C1 and C2 are companion theorems rather than competing formalizations of the same proposition, so testing them for semantic equivalence would answer the wrong question.

The frozen source evidence shows:

- C1 is the headline eventual-categoricity result;
- C2 is the companion CH obstruction;
- `lean/docs/240.md` explicitly excludes the separate eventual-categoricity theorem;
- `CHObstruction.json` selects `OAI.CHObstruction.main`.

We therefore distinguish `TARGETED` from `VERIFIED`: E15-A establishes only which claim the Lean artifact targets. Semantic fidelity of that target is deferred to E15-B.

## Results

### E15-A

**Result:** `PartialFormalizationCoverage / FamilyScopeMismatch`

The result-family-to-artifact mapping is:

$$
C_1 \longrightarrow \varnothing
$$

$$
C_2 \longrightarrow \texttt{OAI.CHObstruction.main}.
$$

Thus:

- **C1 eventual categoricity:** `NOT_INCLUDED`
- **C2 CH prescribed-threshold obstruction:** `TARGETED`

The family-level formalization coverage is therefore partial.

This is not evidence that the selected Lean theorem is too weak or incorrect. OpenAI explicitly documents the scope boundary. The finding is instead that the formal artifact attached to Result 240 covers the companion CH-obstruction result but not the family's headline eventual-categoricity theorem.

This gives us a new audit phenomenon:

$$
\boxed{\text{family-level claim coverage can be partial even when within-scope formalization fidelity is high}.}
$$


```
mkdir -p evidence/e15-a

OPENAI_MATH_SHA=$(
  git ls-remote https://github.com/openai/math.git refs/heads/main |
  awk '{print $1}'
)

echo "$OPENAI_MATH_SHA"

BASE="https://raw.githubusercontent.com/openai/math/$OPENAI_MATH_SHA"

curl -L "$BASE/overview.tex" \
  -o evidence/e15-a/overview.tex

curl -L "$BASE/lean/docs/240.md" \
  -o evidence/e15-a/240.md

curl -L "$BASE/lean/ComparatorChallenges/CHObstruction.json" \
  -o evidence/e15-a/CHObstruction.json

curl -L "$BASE/lean/ComparatorChallenges/CHObstruction.lean" \
  -o evidence/e15-a/CHObstruction.lean

shasum -a 256 evidence/e15-a/*
```

```
shasum -a 256 evidence/e15-a/*
4eaee87548250b2682affda7d05d947c05554bae
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  315k  100  315k    0     0  1205k      0 --:--:-- --:--:-- --:--:-- 1208k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1123  100  1123    0     0   6464      0 --:--:-- --:--:-- --:--:--  6454
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   313  100   313    0     0   1817      0 --:--:-- --:--:-- --:--:--  1819
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3654  100  3654    0     0  20955      0 --:--:-- --:--:-- --:--:-- 21000
27e8169666e3b3fc26a80938e7ab0b7e65648ae2a68086ade757446eb2a715eb  evidence/e15-a/240.md
95484776acae3d7176ec20898817a23910dff1282e064fac9c74a68f1beac4f9  evidence/e15-a/CHObstruction.json
b58c11900fa0d3873614f086562b2d46acd5f8d47e67b7d79a1220a274ed9b3b  evidence/e15-a/CHObstruction.lean
39de58f1bf2185eb11d444a58aec4c7c7530419f3127deb9261fa46e044a4135  evidence/e15-a/overview.tex
```

### E15-B



No SemantEq or Lean run is needed for E15-A because there is no same-claim semantic comparison to perform. The evidence consists of the pinned and hashed source files in the E15-A evidence bundle.


Compare a neutral restatement of the CH prescribed-threshold obstruction with a formulation corresponding to the selected OpenAI comparator.

The first probe tests whether SemantEq recognizes the equivalence between two ways of packaging the same obstruction data, particularly the transport between `TwoModels K hanf` and `TwoModels K endpoint` under the equality `endpoint = hanf`.

**Prior expectation:** Equivalent after equality transport and reordering of conjuncts.

A separate kernel-checked bridge will test the stronger directional claim that OpenAI's selected theorem implies the advertised failure of categoricity transfer at the Hanf point.


```
 lake exe semanteq --strict --timeout 0 \
  ../src/shelah_ch_scope_ref.lean \
  ../src/shelah_ch_scope_candidate.lean
semanteq v1.4.0  git f927670 (dirty)  2026-11-02T21:12:37Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing shelah_ch_scope_ref__vs__shelah_ch_scope_candidate
── shelah_ch_scope_ref__vs__shelah_ch_scope_candidate
   verdict: Inconclusive   (549178 ms)
   ref ⇒ cand: not proved
      no proof found in 57 attempts
   cand ⇒ ref: not proved
      no proof found in 57 attempts
```

SemantEq v1.4.0 returned:

- verdict: `Inconclusive`
- reference -> candidate: not proved after 57 attempts
- candidate -> reference: not proved after 57 attempts
- runtime: 549178 ms

This was contrary to the frozen prior expectation of equivalence.

We therefore constructed an independent Lean bridge over the same abstract signature. Lean kernel-checked both implications:

$$
R \Rightarrow C
$$

and

$$
C \Rightarrow R,
$$

and hence proved:

$$
R \leftrightarrow C.
$$

The only semantic transformation required is equality transport under

$$
\texttt{endpoint = hanf},
$$

together with reordering of conjunctions. In particular,

$$
\texttt{TwoModels K hanf}
$$

and

$$
\texttt{TwoModels K endpoint}
$$

are interchangeable under the supplied endpoint equality.

`#print axioms ShelahCHScopeBridge.equivalent` reported only the abstract vocabulary axioms used to define the fixture:

[AEC, CH, Categorical, CountableLanguage, HasLS0, IsAEC,
 Language, TwoModels, endpoint, hanf, tailThreshold]

No sorryAx occurs in the bridge theorem.

Independent Lean result: Equivalent

SemantEq result: Inconclusive

Interpretation: SemantEq produced a proof-search false negative. The two statements are kernel-verified equivalent, but SemantEq failed to discover either direction after 57 attempts per direction.

This is a useful calibration result because the hidden equivalence is comparatively shallow: it requires conjunction repackaging and equality transport rather than a substantive mathematical lemma.

Artifacts:
- src/shelah_ch_scope_ref.lean
- src/shelah_ch_scope_candidate.lean
- src/shelah_ch_scope_bridge.lean
- results/E15-B.json
- results/E15-B-bridge.txt

### E15-B2

```
# E15-B2 — OpenAI CHObstruction.main -> prescribed-transfer failure
# Run from scientific_audit/

# ----------------------------------------------------------------------
# 1. Pin and record the OpenAI/math source revision
# ----------------------------------------------------------------------

cd openai-math

git checkout --detach 4eaee87548250b2682affda7d05d947c05554bae
git rev-parse HEAD
git status --short


# ----------------------------------------------------------------------
# 2. Freeze the actual implementation source used by the audit
# ----------------------------------------------------------------------

mkdir -p ../evidence/e15-b

cp lean/OAI/ModelTheory/Categoricity/Main.lean \
  ../evidence/e15-b/Main.lean

shasum -a 256 \
  lean/OAI/ModelTheory/Categoricity/Main.lean \
  ../evidence/e15-b/Main.lean

# Expected SHA-256 for both:
# 194d9a878ae95564b93ae648c3b3d562ded04034ef22df977891b21c22ffe8f4


# ----------------------------------------------------------------------
# 3. Enter the OpenAI Lean environment and install/build dependencies
# ----------------------------------------------------------------------

cd lean

lake update
lake exe cache get


# ----------------------------------------------------------------------
# 4. Build the actual OAI module as an importable .olean
#
# IMPORTANT:
# "lake lean OAI/.../Main.lean" typechecks the file but does not
# necessarily create the .olean needed by our external bridge.
# The module-target build below is the critical step.
# ----------------------------------------------------------------------

lake build +OAI.ModelTheory.Categoricity.Main

ls -l .lake/build/lib/lean/OAI/ModelTheory/Categoricity/Main.olean


# ----------------------------------------------------------------------
# 5. Compile our independent audit bridge against OpenAI's environment
# ----------------------------------------------------------------------

AUDIT_ROOT="$(cd ../.. && pwd)"

mkdir -p "$AUDIT_ROOT/results"

lake env lean "$AUDIT_ROOT/src/shelah_ch_openai_bridge.lean" 2>&1 \
  | tee "$AUDIT_ROOT/results/E15-B-openai-bridge.txt"


# ----------------------------------------------------------------------
# 6. Inspect the archived result
# ----------------------------------------------------------------------

cat "$AUDIT_ROOT/results/E15-B-openai-bridge.txt"
```

We have independently kernel-checked:

$$
\mathrm{CH}
\Longrightarrow
\exists K,\lambda>h(\aleph_0):
\operatorname{Categorical}(K,\lambda)
\land
\neg\operatorname{Categorical}(K,h(\aleph_0)).
$$

The noncategoricity step is particularly clean:

$$
\operatorname{TwoModels}(K,\mu)
\Rightarrow
\neg\operatorname{Categorical}(K,\mu),
$$

because OpenAI defines TwoModels as two models of size $(\mu)$ with no isomorphism, while Categorical μ demands an isomorphism between every such pair.

Combined with E15-B1, this shows that the selected OpenAI formalization
faithfully supports the CH prescribed-threshold obstruction even though
SemantEq failed to recognize a shallow equivalent restatement of that
scope.

Combined with E15-A, the overall result is therefore:

$$
\boxed{
\text{partial family-level coverage}
\quad+\quad
\text{positive within-scope formal fidelity}
}
$$

The audit finding is consequently a scope/provenance mismatch rather than a weakness or defect in the formalized CH-obstruction theorem.

Artifacts:
- src/shelah_ch_scope_ref.lean
- src/shelah_ch_scope_candidate.lean
- src/shelah_ch_scope_bridge.lean
- src/shelah_ch_openai_bridge.lean
- results/E15-B.json
- results/E15-B-bridge.txt
- results/E15-B-openai-bridge.txt
- evidence/e15-a/
- evidence/e15-b/Main.lean



