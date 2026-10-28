# Installation Instructions


## Lean

```
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
```

## SemantEq

```
git clone https://github.com/hlxr89/SemantEq.git
cd SemantEq
```


## now build
```
lake exe cache get
lake build semanteq
```

NB! don’t run lake update, because the authors explicitly warn that the judgments are tied to their pinned Lean 4.30.0-rc1 + Mathlib revision.


## Kakeya Conjecture

Prove the centered unit is equal to the [0,1] segment
```
lake exe semanteq --strict --proof \
  ../src/oai_to_standard.lean \
  ../src/standard_to_oai.lean
```


Prove arbitrary subset Kakeya is equal to the compact Kakeya

```
lake exe semanteq --strict --proof \
  ../src/oai3_to_trusted_compact.lean
```

## MUB Result 266 mutually unbiased bases in C^6

```
lake exe semanteq --strict \
  ../src/mub_headline_ref.lean \
  ../src/mub_oai_candidate.lean
```

We can give Lean a perfectly valid proof that the headline theorem implies OpenAI's weaker theorem:

```
lake exe semanteq --strict --timeout 0 \
  ../src/mub_headline_ref.lean \
  ../src/mub_oai_candidate.lean
```

Results:
```
lake exe semanteq --strict --timeout 0 \
  ../src/mub_headline_ref.lean \
  ../src/mub_oai_candidate.lean
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


