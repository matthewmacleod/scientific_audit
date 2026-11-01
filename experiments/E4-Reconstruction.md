# E4. Reconstruction threshold: biconditional versus one direction


**Prior expectation:** The exact-threshold claim is stronger than a supercritical reconstruction statement.



## References

- [OpenAI paper: The exact reconstruction threshold for the three-state symmetric channel](https://github.com/openai/math/tree/main/preprints/The-exact-reconstruction-threshold-for-the-three-state-symmetric-channel-September-25-2026)
- [OpenAI math repository](https://github.com/openai/math)
-
- [Wikepedia](https://en.wikipedia.org/wiki/Reconstruction_conjecture)

### Experiment

Compare the advertised exact reconstruction threshold

$$
\operatorname{Reconstructs}\iff d\lambda^2>1
$$

with a formal statement establishing only the supercritical direction,

$$
d\lambda^2>1\;\Longrightarrow\;\operatorname{Reconstructs}.
$$

The exact threshold also requires non-reconstruction at or below the threshold. The experiment should test whether SemantEq correctly distinguishes a biconditional from one of its implications.

This is a logical-completeness case rather than a numerical-bound case.

## Results


```
lake exe semanteq --strict --timeout 0 \
  ../src/reconstruction_exact_ref.lean \
  ../src/reconstruction_supercritical_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T01:55:21Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing reconstruction_exact_ref__vs__reconstruction_supercritical_candidate
── reconstruction_exact_ref__vs__reconstruction_supercritical_candidate
   verdict: LikelyTooWeak   (170071 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.reconstruction_exact_ref, <structural>]
      proof:  fun Reconstructs b hb lam hlam a =>
                And.casesOn hlam fun left right =>
                  Iff.casesOn
                    ((fun Reconstructs b hb lam hlam => Iff.symm (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam))
                      Reconstructs b hb lam hlam)
                    fun mp mpr =>
                    Iff.casesOn (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam) fun mp mpr =>
                      (fun Reconstructs b hb lam hlam => (SemantEqRef.reconstruction_exact_ref Reconstructs b hb lam hlam).mpr)
                        Reconstructs b hb lam ⟨hlam.left, hlam.right⟩ a
   cand ⇒ ref: not proved
      no proof found in 81 attempts
```

there is an issue this is provisional:

We wrote:
theorem reconstruction_exact_ref
    (Reconstructs : ℕ → ℝ → Prop)
    ...

That means Reconstructs is universally quantified as part of the theorem. So the candidate is really something like

$$
\forall R\,\forall b\,\forall\lambda,\quad
P(b,\lambda)\to R(b,\lambda),
$$

rather than a theorem about one fixed reconstruction predicate. If there exists a supercritical admissible pair, choosing $R=\bot$ makes that universal theorem inconsistent. Strict SemantEq did not exploit that inconsistency, which is good, but it means this controlled fixture is not as semantically clean as I thought when I wrote it.

Provisional only: Reconstructs was universally quantified, so this fixture tests syntactic/logical shape but is not used as the canonical E4 strength comparison.


### E4-B2


```
lake exe semanteq --strict --timeout 0 \
  ../src/reconstruction_reduced_exact_ref.lean \
  ../src/reconstruction_reduced_supercritical_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T05:50:50Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing reconstruction_reduced_exact_ref__vs__reconstruction_reduced_supercritical_candidate
── reconstruction_reduced_exact_ref__vs__reconstruction_reduced_supercritical_candidate
   verdict: LikelyTooWeak   (94928 ms)
   ref ⇒ cand: proved
      script: structural solve_by_elim [SemantEqRef.OAI.ThreeStateReduced.regular_exact, <structural>]
      proof:  fun b hb lam h hcrit =>
                And.casesOn (motive := fun x =>
                  SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) →
                    (1 < ↑b * lam ^ 2 ↔
                        SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x)) →
                      (SemantEqRef.OAI.ThreeStateReduced.Reconstructs (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) ↔
                          1 < ↑b * lam ^ 2) →
                        ∃ L,
                          0 < L ∧ Filter.Tendsto (SemantEqRef.OAI.ThreeStateReduced.regularAdvantage b lam x) Filter.atTop (nhds L))
                  h
                  (fun left right h_fwd_0 h_fwd_1 h_fwd_2 =>
                    Iff.casesOn h_fwd_1 fun mp mpr =>
                      Iff.casesOn h_fwd_2 fun mp mpr =>
                        (fun b hb lam h => (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h).mpr) b hb lam ⟨left, right⟩
                          hcrit)
                  ((fun b hb lam h => (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h).mpr) b hb lam h hcrit)
                  ((fun b hb lam h => Iff.symm (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h)) b hb lam h)
                  (SemantEqRef.OAI.ThreeStateReduced.regular_exact b hb lam h)
   cand ⇒ ref: not proved
      no proof found in 71 attempts
```

E4-B2 result: LikelyTooWeak. SemantEq proved the exact-threshold reference implies OpenAI’s selected supercritical reconstruction theorem, but did not prove the converse after 71 attempts. The fixture preserves OpenAI’s actual Reconstructs semantics and threshold expression while replacing the computationally expensive internal construction of regularAdvantage with a fixed opaque symbol. This isolates logical strength rather than implementation details.

### E4-C

```
lake env lean ../src/reconstruction_separation_witness.lean
```

finishes successfully.


E4 is not merely “SemantEq didn’t prove the converse.” We have independently established strict weakening:

$$
\text{Exact threshold} \Rightarrow \text{Supercritical theorem}
$$

but

$$
\text{Supercritical theorem} \nRightarrow \text{Exact threshold}.
$$

That gives us a nice methodological contrast between search incompleteness (E3) and correct strength diagnosis (E4).

---

