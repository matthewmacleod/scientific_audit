# Scientific Audit of OpenAI Results

We test various results from [Working with academic communities to build scientific understanding](https://openai.com/index/building-scientific-understanding-with-academic-communities/)


This repo audits whether formalized scientific results support the human-facing claims associated with them. We distinguish semantic equivalence, one-way entailment, and weaker or stronger formalizations using SemantEq-Eval and SemantEq-ProofAudit.

We use the ![SemantEq](https://arxiv.org/abs/2610.32919) approach to determining these probes.


## Kakeya / SemantEq-ProofAudit experiment

[Background Wikipedia](https://en.wikipedia.org/wiki/Kakeya_set)

This package compares OpenAI's current Lean Kakeya target against an independently
maintained trusted Lean formulation from `leanprover/lean-eval`.

### Probe A: geometry identity

`oai_to_standard.lean` and `standard_to_oai.lean` compare:

- OpenAI: centered segment `x + t • ω`, `t ∈ [-1/2,1/2]`;
- independent standard geometry: `x + t • ω`, `t ∈ [0,1]`.

Both quantify over arbitrary subsets, so this isolates the geometric representation
choice. The bridge shifts the base point by `ω/2`.

Run both directions (see [INSTALL.md](./INSTALL.md):
```
lake exe semanteq --strict --proof oai_to_standard.lean standard_to_oai.lean
```

A semantic-equivalence certification requires PASS in both directions.

### Probe B: exact independent trusted statement

`oai3_to_trusted_compact.lean` compares the n=3 OpenAI theorem to the trusted
lean-eval Wang--Zahl formulation. lean-eval additionally requires compactness.

Run:
```
lake exe semanteq --strict --proof oai3_to_trusted_compact.lean
```


If this passes, it certifies that OpenAI's $(n=3)$ arbitrary-set theorem entails an independently maintained compact $(n=3)$ Kakeya formulation,
through an explicit segment reparameterization and restriction to compact sets.

There is intentionally no trivial reverse ProofAudit fixture. Going from the compact
conjecture to the arbitrary-set conjecture requires a substantive mathematical reduction,
not merely the local semantic rewrite being tested here. Keleti--Máthé (2022) proves the
standard compact/Borel/arbitrary formulations equivalent mathematically, but importing
that result as a black-box bridge would defeat the purpose of a SemantEq-style audit.

### Results

Probe A passes in both directions; Probe B passes in the audited OAI → trusted direction.

### Toolchain caveat

SemantEq is currently pinned to Lean 4.30.0-rc1 / Mathlib v4.30.0-rc1. The independent
lean-eval target was on Lean 4.32.2, and OpenAI's current math repository is on Lean
4.34.1. These fixtures transcribe only the exact statement-level geometry into SemantEq's
pinned Mathlib environment rather than importing either project directly.

For archival evidence, record the exact source commits and compiler-check these fixtures
in the SemantEq environment before interpreting the ProofAudit verdicts.

Observed results: both geometry-direction ProofAudit fixtures PASS, and the OAI \(n=3\) → trusted compact Wang–Zahl fixture PASS. All runs used SemantEq v1.4.0, git f927670, in strict mode.

## MUB (Mutually unbiased basis) and Result 266

## Background

What is a mutually unbiased basis?  Take two orthonormal bases of $\mathbb C^d$


$$
B=\{e_1,\dots,e_d\},
\qquad
C=\{f_1,\dots,f_d\}.
$$

They are mutually unbiased if
$$
|\langle e_i,f_j\rangle|^2=\frac1d
$$
for every $(i,j)$.

Operationally, if a quantum state is known perfectly in basis $(B)$, then measuring it in basis $(C)$ gives a completely uniform distribution. The two measurements reveal maximally complementary information.

Wootters and Fields showed in 1989 that there can be at most
$$
d+1
$$
pairwise mutually unbiased bases, and that this maximum is achieved whenever $(d)$ is a prime power.

So:
$$
d=2\Rightarrow3,
\qquad
d=3\Rightarrow4,
\qquad
d=4\Rightarrow5,
\qquad
d=5\Rightarrow6,
$$
and so on.

Then comes:
$$
\boxed{d=6}
$$
which is not a prime power.

That is the first mysterious case.
Why six became famous
For $\mathbb C^6$, the general upper bound gives

$$
N(6)\le7.
$$
Three mutually unbiased bases are known to exist.

But for decades nobody could construct four.  Gerhard Zauner conjectured, originally in work going back to his 1991 master's thesis and his 1999 dissertation, that four MUBs in dimension six do not exist:

$$
\boxed{N(6)=3.}
$$

His later English translation explicitly describes the dimension-six construction of infinite families of MUB triples and the conjecture that four do not exist. This is generally called the dimension-six MUB conjecture or Zauner's MUB conjecture.  And it has resisted a remarkable variety of attacks.


## Experiment
The associated Lean formalization does not prove $N(6)=3$ OpenAI's own Lean scope documentation says this explicitly.  The manuscript claims:

$$
N(6)\le3.
$$ 

The associated MUB Lean result proves only:

$$
\boxed{N(6)\le5}
$$

in its formal MUB model. OpenAI's scope document says plainly that the Lean statement does not establish the upper bound of three or the computer-assisted exclusion of four arbitrary bases.  MathVet consequently classifies result 266 as a weaker-statement formalization. This is the exact semantic gap we're poking.

### MUB References


- Wootters & Fields (1989), “Optimal state-determination by mutually unbiased measurements.” The foundational $(d+1)$ bound and prime-power construction. [ScienceDirect Paper](https://www.sciencedirect.com/science/article/abs/pii/0003491689903229)
- Zauner, Quantum Designs. Historical source for the dimension-six conjecture and early MUB triples. 
 [Gerhard Zauner 1999 dissertation](https://www.gerhardzauner.at/documents/gz-quantendesigns.pdf)
- Durt, Englert, Bengtsson & Życzkowski (2010), “On mutually unbiased bases.” Classic broad review and the relationship to Hadamard matrices and quantum information. [arXiv](https://arxiv.org/abs/1004.3348)
- McNulty & Weigert (2026), “Mutually Unbiased Bases in Composite Dimensions — A Review.” Probably the best background source for us now; 104 pages, fourteen equivalent formulations, extensive treatment of $(d=6)$. [arXiv](https://arxiv.org/abs/2410.23997)
  Current review
- Jaming, Matolcsi & Móra, “The problem of mutually unbiased bases in dimension 6.” Good history of the computational/discretization attack. [arXiv](https://arxiv.org/abs/1201.0640)
- OpenAI (Sept. 24, 2026), “The maximum number of mutually unbiased bases in dimension six.” The new claimed resolution. [Math Community OpenAI preprint record](https://mathcommunity.github.io/oai-math-revised/papers/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026/)
- OpenAI Lean scope note, result 266. This is the crucial reference for our experiment: it explicitly says the Lean family bound is five rather than three
  [Lean scope for result 266](https://github.com/openai/math/blob/main/lean/docs/266.md)
- MathVet result 266. Independent classification of the Lean formalization as a weaker statement. [MathVet fidelity table](https://math.vet/openai-math/)

### Results

Run:
```
lake exe semanteq --strict --timeout 0 \
   ../mub_headline_ref.lean \
   ../mub_oai_candidate.lean
```
and see results here [raw results](./results/mub.json)

Results:
```
lake exe semanteq --strict --timeout 0 \
  ../mub_headline_ref.lean \
  ../mub_oai_candidate.lean
semanteq v1.4.0  git f927670  2026-10-27T22:35:59Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mub_headline_ref__vs__mub_oai_candidate
── mub_headline_ref__vs__mub_oai_candidate
   verdict: LikelyTooWeak   (335903 ms)
   ref ⇒ cand: proved
      script: simp only [Nat.le_succ_iff] at hyps/h_ante; simp only [SemantEqRef.headline_at_most_three]; <structural close>
      proof:  fun n =>
                Eq.mpr
                  (id
                    (implies_congr
                      (Eq.refl (∃ B, ∀ (r s : Fin n), r ≠ s → ∀ (i j : Fin 6), Complex.normSq (inner ℂ ((B r) i) ((B s) j)) = 1 / 6))
                      (Eq.trans _simp_1
                        (congrFun'
                          (congrArg Or
                            (Eq.trans _simp_1
                              (congrFun'
                                (congrArg Or
                                  (Eq.trans _simp_1
                                    (congrFun' (congrArg Or (Eq.trans _simp_1 (congrFun' (congrArg Or _simp_1) (n = Nat.succ 1))))
                                      (n = Nat.succ 2))))
                                (n = Nat.succ 3))))
                          (n = Nat.succ 4)))))
                  fun a =>
                  Or.inl
                    (Or.inl
                      (Eq.mp
                        (forall_congr fun n =>
                          implies_congr (Eq.refl (SemantEqRef.RefAttainable n))
                            (Eq.trans _simp_1
                              (congrFun' (congrArg Or (Eq.trans _simp_1 (congrFun' (congrArg Or _simp_1) (n = Nat.succ 1))))
                                (n = Nat.succ 2))))
                        SemantEqRef.headline_at_most_three n a))
   cand ⇒ ref: not proved
      no proof found in 87 attempts
```



This is our first clean negative SemantEq result:
$$
\boxed{\texttt{LikelyTooWeak}}
$$
rather than EquivalentRestricted.


The restricted search established the expected direction $(N(6)\le3\Rightarrow N(6)\le5$, but did not establish the reverse direction.

This is very important because SemantEq did not prove that the reverse implication is false. It performed 87 restricted proof attempts and found none. And because these are closed propositions involving the actual Attainable predicate, substantive mathematics about MUBs could in principle establish the stronger proposition. Indeed, that is exactly what the OpenAI manuscript claims to do.


With unlimited time, it found a cleaner route:
```text
simp only [Nat.le_succ_iff]
...
<structural close>
```

`Nat.le_succ_iff` is itself an iff-grade rewrite, so it fits SemantEq's permitted transformation vocabulary. SemantEq explicitly allows logical rearrangement, equality/iff rewriting, changes of variables, and structural weakening, while refusing arbitrary theorem proving as evidence of semantic equivalence. GitHub

So it effectively transformed:
$$
n\le3
$$

into the corresponding finite disjunctive structure and then structurally weakened that to:
$$
n\le5.
$$
That is not being treated as equivalence. It is being recognized as a legitimate one-way weakening.

That's exactly why the final classification is:
$$
\boxed{\text{candidate was classified LikelyTooWeak}}
$$
rather than 'these mean the same thing.' And the reverse result is almost prettier
```
cand ⇒ ref: not proved
    no proof found in 87 attempts
```

So SemantEq tried 87 restricted transformation routes from
$$
n\le5
$$
to
$$
n\le3
$$
and found none.

Important epistemic caveat: LikelyTooWeak is deliberately called likely, because SemantEq's search is incomplete. Failure to find the reverse transformation isn't a theorem that no such transformation exists. Its verdict table explicitly distinguishes these directional diagnoses from machine-proven bidirectional equivalence.


And there's one important limitation of our experiment to keep straight: we transcribed the documented OpenAI bound and headline into controlled fixtures sharing the same MUB definitions. We have shown:

$$
\boxed{
\text{SemantEq-Eval classified }(\le5)\text{ as LikelyTooWeak relative to }(\le3).
}
$$
It did not certify bidirectional restricted equivalence.

We have not yet run SemantEq directly over OpenAI's actual project theorem because of the Lean/Mathlib-version mismatch. OpenAI's own scope note is what establishes that its Lean artifact proves the ≤5 bound rather than the ≤3 headline; our experiment tests the semantic consequence of that documented mismatch.

Still, this is a wonderfully clean result. SemantEq did exactly what we'd want a semantic-fidelity checker to do: it did not confuse “the stronger theorem implies this weaker theorem” with “these are two ways of saying the same thing.”

Also, 335,903 ms is about 5 minutes 36 seconds. So apparently it really did need to rummage around before discovering the permitted one-way bridge.

## Results summary

| Pair | Ref ⇒ Cand | Cand ⇒ Ref | Observed result |
|---|---:|---:|---|
| centered vs \([0,1]\) Kakeya segment | ProofAudit PASS | ProofAudit PASS | bidirectionally audited restricted transformation |
| OAI \(n=3\) arbitrary Kakeya → trusted compact theorem | ProofAudit PASS | not tested | audited one-way implication |
| MUB \(\le3\) vs Lean \(\le5\) | established | not established in 87 attempts | `LikelyTooWeak` |


