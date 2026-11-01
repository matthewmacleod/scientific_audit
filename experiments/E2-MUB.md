# E2. Mutually unbiased bases in dimension six: numerical weakening

**Prior expectation:** The headline/reference statement is strictly stronger than the selected Lean candidate.

## References

- [OpenAI formalization scope: exactly three mutually unbiased bases in dimension six](https://github.com/openai/math/blob/main/lean/docs/266.md)
- [OpenAI Comparator: `MUBSix.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MUBSix.lean)
- [OpenAI paper: The maximum number of mutually unbiased bases in dimension six](https://github.com/openai/math/tree/main/preprints/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026)

## Experiment

Compare the scientific claim that every family of mutually unbiased bases in $\mathbb C^6$ has at most three members with the selected formal statement establishing an upper bound of five.

Abstractly, the central comparison is:

$$
N\le 3
$$

versus

$$
N\le 5.
$$

We expect the stronger bound to imply the weaker bound, but not conversely. This is the clean numerical-weakening control case.

## Results


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


