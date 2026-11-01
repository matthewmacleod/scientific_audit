
## E5. Mass-action permanence: quantifier order

**Prior expectation:** The class-uniform statement is stronger than the trajectory-dependent statement.

### References

- [OpenAI formalization scope: classwise permanence for weakly reversible mass-action systems](https://github.com/openai/math/blob/main/lean/docs/149.md)
- [OpenAI Comparator: `MassAction.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/MassAction.lean)
- [OpenAI paper: Uniform Permanence in Weakly Reversible Mass-Action Systems](https://github.com/openai/math/tree/main/preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026)

- [arXiv review](https://arxiv.org/abs/1010.3050)
- [Wikipedia Chemical reaction network theory](https://en.wikipedia.org/wiki/Chemical_reaction_network_theory)
- [A blog on reaction network theory](https://johncarlosbaez.wordpress.com/2011/11/12/network-theory-part-17/)

### Background

This is about whether a certain kind of reaction network can make a chemical species vanish or let its concentration grow without bound over time.

In a mass-action model, a reaction such as A+B→C proceeds at a rate proportional to the product of the reactant concentrations, k[A][B]. A network is weakly reversible if every reaction lies on a directed cycle in the reaction graph: starting from its product complex, there’s a path back to its reactant complex.

The conjectures ask whether, for any finite weakly reversible network with positive rate constants and positive starting concentrations, the resulting concentrations stay bounded and stay away from zero. The linked OpenAI note says its Lean formalization proves those claims: there’s an ε>0 such that every concentration stays between ε and 1/ε for all future time. That ε can depend on the network, rate constants, and initial concentrations.

This is not a claim that the system settles down to equilibrium; concentrations could keep varying while staying within those bounds. And because the bounds can depend on the starting concentrations, it’s weaker than a uniform guarantee shared by every starting point in a whole stoichiometric class.


### Experiment

Compare a classwise permanence claim in which one common compact absorbing set, or one common positive bound, works for every trajectory in a positive stoichiometric compatibility class with a statement in which the bound may depend on the initial state.

The semantic distinction is approximately:

$$
\exists \varepsilon>0\;\forall x\;P(x,\varepsilon)
$$

versus

$$
\forall x\;\exists \varepsilon_x>0\;P(x,\varepsilon_x).
$$

The first implies the second, while the reverse does not follow in general. This is intended as a direct test of whether SemantEq preserves quantifier scope rather than matching only local predicates and vocabulary.

#### Experimental refinement

E5-A — Uniformity only. Hold everything else fixed and compare

$$
\exists\varepsilon\,\forall x_0\,P(\varepsilon,x_0)
$$

against

$$
\forall x_0\,\exists\varepsilon\,P(\varepsilon,x_0).
$$


E5-B — Time only. Fix one $(x_0,\varepsilon)$ and compare eventual bounds

$$
\exists T\,\forall t\ge T,\;P(t)
$$

against all-time bounds

$$
\forall t\ge0,\;P(t).
$$

Here the direction reverses:

$$
\text{all-time}\Rightarrow\text{eventual},
$$

but not conversely. This isolates the part where Lean is actually stronger.

E5-C — Combined reduced claim. Compare

$$
\exists\varepsilon\;\forall x_0\;\exists T(x_0)\;\forall t\ge T(x_0)
$$

against

$$
\forall x_0\;\exists\varepsilon(x_0)\;\forall t\ge0.
$$

E5-D — Source-faithful reduced mass-action model. Restore positive states, classes, global solutions, species-indexed concentrations, $(\varepsilon\in(0,1))$, and reciprocal upper bounds, while keeping the ODE itself opaque. This tells us whether the conclusions above survive a much closer representation of MassAction.lean.

E5-E — Geometry bridge. Formalize the connection between a compact absorbing set in the positive orthant and common positive lower/finite upper coordinate bounds. This is the mathematical bridge from the headline’s geometric permanence language to an $(\varepsilon)$-style formulation.

E5-F — Full-source stress test. Only after we know all the pieces separately do we throw a headline-faithful permanence formulation and the actual comparator structure at SemantEq. Then if it gets stuck, we know why.


### Results


#### E5-A

```
lake exe semanteq --strict --raw --timeout 0 \
  ../src/mass_action_uniform_ref.lean \
  ../src/mass_action_pointwise_candidate.lean > ../results/E5-A.json
```

SemantEq result: LikelyTooWeak; reference ⇒ candidate proved, candidate ⇒ reference not proved. Prior directionality confirmed by automated search. Strict non-implication to be independently established by E5-A separation witness.


```
lake env lean ../src/mass_action_uniformity_separation_witness.lean
```

The pointwise candidate preserves per-trajectory boundedness but does not preserve the classwise uniform witness required by permanence.

#### E5-B

```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_eventual_ref.lean \
  ../src/mass_action_all_time_candidate.lean
semanteq v1.4.0  git f927670  2026-10-31T18:50:32Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_eventual_ref__vs__mass_action_all_time_candidate
── mass_action_eventual_ref__vs__mass_action_all_time_candidate
   verdict: Inconclusive   (202846 ms)
   ref ⇒ cand: not proved
      no proof found in 37 attempts
   cand ⇒ ref: not proved
      no proof found in 37 attempts
```

E5-B: Eval returned Inconclusive in both directions, although a direct kernel-checked proof establishes candidate ⇒ reference by choosing \(T=0\), and a separate Lean countermodel proves reference ⇏ candidate.


```
lake env lean ../src/mass_action_time_bridge.lean
lake env lean ../src/mass_action_time_separation_witness.lean
```
clean.



#### E5-C

This sets up E5-C beautifully. We now combine the two opposing changes:

Reference-like permanence:

$$
\exists \varepsilon>0\;
\forall x_0>0\;
\exists T\ge0\;
\forall t\ge T,\;
P(\varepsilon,x_0,t)
$$

versus Lean-like trajectorywise bounds:

$$
\forall x_0>0\;
\exists \varepsilon>0\;

$$


```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_uniform_eventual_ref.lean \
  ../src/mass_action_pointwise_all_time_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T00:00:17Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_uniform_eventual_ref__vs__mass_action_pointwise_all_time_candidate
── mass_action_uniform_eventual_ref__vs__mass_action_pointwise_all_time_candidate
   verdict: Inconclusive   (230419 ms)
   ref ⇒ cand: not proved
      no proof found in 49 attempts
   cand ⇒ ref: not proved
      no proof found in 49 attempts
```

This is clean:
```
lake env lean ../src/mass_action_combined_separation_witnesses.lean
```

E5-C Eval: Inconclusive; neither implication proved in 49 attempts. Frozen prior was logical incomparability because the reference strengthens uniformity across initial states while the candidate strengthens temporal scope.

#### E5-D

Checked the pinned OpenAI comparator again. Its conclusion really does preserve these features: positive species-indexed initial concentrations; an $(\varepsilon\in(0,1))$; existence of a global forward solution; every global forward solution bounded for every $(t\ge0)$; and, for every species $(i)$,

$$
\varepsilon\le x_i(t)\le\varepsilon^{-1}.
$$

Crucially, $(\varepsilon)$ comes after $(x_0)$, and OpenAI's scope note explicitly says it may depend on the initial state.

For D, we preserve all of that conclusion structure, plus an explicit compatibility class, while abstracting only the internal reaction-network/ODE machinery.

Frozen E5-D prior
Because D retains the same crossed quantifiers as C, our prior remains:

$$
\boxed{\text{logically incomparable}}
$$

Reference wins on classwise uniformity:

$$
\exists\varepsilon\;\forall x_0\in C
$$

while candidate wins on temporal scope:

$$
\forall t\ge0
$$

instead of trajectory-dependent eventual entry.


```
lake exe semanteq --strict --timeout 0 \
  ../src/mass_action_source_reduced_ref.lean \
  ../src/mass_action_source_reduced_candidate.lean
semanteq v1.4.0  git f927670  2026-11-01T02:28:43Z
[semanteq] warm-up: importing the batch's most frequent set #[Init, Mathlib]
[semanteq] importing (cache miss #1): #[Init, Mathlib]
[semanteq] processing mass_action_source_reduced_ref__vs__mass_action_source_reduced_candidate
── mass_action_source_reduced_ref__vs__mass_action_source_reduced_candidate
   verdict: Inconclusive   (318375 ms)
   ref ⇒ cand: not proved
      no proof found in 67 attempts
   cand ⇒ ref: not proved
      no proof found in 67 attempts
```

Reduced source-shaped probe: Inconclusive. Neither direction proved. Because the fixture leaves trajectory regularity and positivity opaque, it preserves the logical incomparability of E5-C and is not yet treated as the final source-level relationship.


#### E5-D1

Rather than making another countermodel, I’d add precisely the fact we omitted:
A positive continuous trajectory that is eventually contained in a reciprocal box admits some trajectory-specific reciprocal box valid from time zero.

That is a real-analysis lemma, independent of reaction-network details.

Schematically:

$$
\begin{aligned}
&x:[0,\infty)\to(0,\infty)^d,\\
&x\text{ continuous},\\
&\exists T,\varepsilon_C>0:
  \forall t\ge T,\,
  \varepsilon_C\le x_i(t)\le\varepsilon_C^{-1}
\\[3pt]
&\qquad\Longrightarrow\\[3pt]
&\exists\delta>0:
  \forall t\ge0,\,
  \delta\le x_i(t)\le\delta^{-1}.
\end{aligned}
$$

If we kernel-prove that, it resolves the question we just uncovered: the “all-time” part of OpenAI's theorem is not actually stronger than permanence once positivity and continuity are restored; it is obtainable by absorbing the finite transient into an $(x_0)$-dependent constant.  Then the only substantive lost strength is the one you’d expect chemically:

$$
\boxed{\text{uniformity over the stoichiometric class}.}
$$


```
lake env lean ../src/mass_action_transient_bridge.lean
```

This is an important result.

E5-D1 now kernel-proves:

$$
\boxed{
\text{positive continuous trajectory}
+
\text{eventual reciprocal box}
\Rightarrow
\text{some trajectory-specific all-time reciprocal box}
}
$$

So the earlier E5-C incomparability really was caused by abstracting away physical/analytic structure. Once continuity and strict positivity return, the apparent temporal strengthening can be absorbed into the finite transient.

That changes the emerging E5 story:

- E5-A: $(\exists\varepsilon\,\forall x_0)$ is strictly stronger than $(\forall x_0\,\exists\varepsilon)$.
- E5-B: abstractly, all-time is stronger than eventual.
- E5-C/D: with no trajectory regularity, those opposing changes produce incomparability.
- E5-D1: for actual positive continuous trajectories, eventual $(\Rightarrow\)$ trajectory-specific all-time bounds, so the temporal opposition disappears.

Which suggests the source-level relationship may really be:


$$
\boxed{
\text{classwise permanence}
\Rightarrow
\text{OpenAI's trajectorywise bound}
}
$$

with the lost information concentrated in classwise uniformity, not temporal scope.  That is a much subtler and better conclusion than simply reading the quantifier surface.

The natural E5-D2 now is to lift D1 from one concentration coordinate to finitely many species and obtain one common $(\delta)$ for all $(i\in\mathrm{Fin}\,d)$:

$$
\exists\delta>0\;
\forall i,\forall t\ge0,\qquad
\delta\le x_i(t)\le\delta^{-1}.
$$

Because the species set is finite, we should be able to take the minimum of the finitely many coordinatewise $(\delta_i)$'s.


#### E5-D2

```
lake env lean ../src/mass_action_transient_bridge_fin.lean
```
clean.

D2 passes, and we have formally established the chemically relevant statement

$$
\begin{aligned}
&\forall i,\quad x_i(t)>0
\quad\text{and}\quad x_i \text{ continuous},\\
&\exists T,\varepsilon_C>0:\quad
t\ge T
\Rightarrow
\forall i,\;
\varepsilon_C\le x_i(t)\le\varepsilon_C^{-1}
\\
&\qquad\Longrightarrow\\
&\exists\delta(x_0)>0:\quad
\forall t\ge0,\forall i,\;
\delta(x_0)\le x_i(t)\le\delta(x_0)^{-1}.
\end{aligned}
$$


We now have the finite-species version of the transient bridge. So the apparent “eventual vs from $(t=0)$” mismatch really can be absorbed into a trajectory-specific \(\delta\) once we restore continuity, positivity, and finitely many species.

#### E5-E1

This is the scalar compact-set bridge.  This one is pleasantly direct because Mathlib has exactly the compactness fact we want: a continuous function that is strictly above $(0)$ on a compact set has a uniform positive lower bound.

We prove:

$$
K\subset(0,\infty),\quad K\text{ compact}
$$

implies

$$
\exists \varepsilon\in(0,1)\;
\forall x\in K,\qquad
\varepsilon\le x\le\varepsilon^{-1}.
$$

```
lake env lean ../src/mass_action_compact_scalar_bridge.lean
```

E5-E1 passed, we've formally connected the geometric language to the comparator-style language in one dimension:

$$
\boxed{
\text{compact + strictly positive}
\Rightarrow
\text{uniform positive lower and finite upper bounds}
}
$$

The nice part is that this proof doesn't even need $(K)$ to be explicitly nonempty; the compactness lemmas handle the vacuous empty-set case too.

#### E5-E2

```
lake env lean ../src/mass_action_compact_species_bridge.lean
```


We have the exact finite-dimensional geometric bridge we wanted:

$$
\boxed{
K\subset(\mathbb R_{>0})^d,\quad K\text{ compact}
\Rightarrow
\exists\varepsilon\in(0,1)\;
\forall x\in K,\forall i,\;
\varepsilon\le x_i\le\varepsilon^{-1}
}
$$

And the chain is formally getting very strong:

$$
\text{compact positive absorbing set}
\overset{\text{E5-E2}}{\Longrightarrow}
\text{uniform eventual reciprocal box}
$$

followed by

$$
\text{uniform eventual reciprocal box}
\overset{\text{E5-D2}}{\Longrightarrow}
\text{trajectory-specific all-time reciprocal box}.
$$

#### E5-F

```
lake env lean ../src/mass_action_final_composition_bridge.lean
```

The clean kernel check now gives us a formal composition:

$$
\boxed{
\text{headline-style classwise permanence}
\Rightarrow
\text{OpenAI-style trajectorywise all-time bounds}
}
$$

provided the ordinary dynamical background assumptions we made explicit hold: forward continuity, positivity, uniqueness, and compatibility-class membership.

And that changes the interpretation of the whole experiment in an important way.

At first, the surface quantifiers suggested two competing differences:

$$
\text{uniform but eventual}
\quad\text{vs}\quad
\text{pointwise but all-time}.
$$

Our abstract E5-C really was incomparable. But once we restored the analytic structure of positive continuous mass-action trajectories, the temporal difference collapsed:

$$
\text{eventual common box}
\Rightarrow
\text{trajectory-specific all-time box}.
$$

So the substantive loss is the uniformity:

$$
\exists\varepsilon_C\,\forall x_0\in C
$$

becomes

$$
\forall x_0\in C\,\exists\varepsilon(x_0).
$$

That is exactly the kind of thing a superficial logical comparison could misdiagnose.

E5-F is a source-faithful reduced composition theorem, not yet literally a theorem about every definition in OpenAI’s full MassAction.lean. We explicitly stated the dynamical properties we needed rather than deriving all of them from OpenAI’s ODE implementation.

#### E5 Summary

The important thing is to distinguish what SemantEq reported on the reduced E5 probes from what we ultimately proved mathematically.  For the source-shaped E5-D comparison, SemantEq itself said:

$$
\texttt{Inconclusive}
$$

with

$$
\text{ref}\to\text{cand}: \text{not proved}
$$

and

$$
\text{cand}\to\text{ref}: \text{not proved}.
$$

But that was not the final mathematical relationship.  After restoring the structure that the reduced fixture had hidden — positivity, continuity, finite species, compactness, and forward uniqueness — E5-F gave us a clean Lean proof of:

$$
\boxed{\text{reference}\to\text{candidate}}
$$

So SemantEq missed that implication in the reduced comparison.

The reverse direction is different. The candidate only gives an \(x_0\)-dependent bound:

$$
\forall x_0\,\exists \varepsilon(x_0),
$$

while the reference claims classwise uniformity:

$$
\exists\varepsilon_C\,\forall x_0\in C.
$$

Our E5-A separation witness proved that the pointwise form does not logically recover the uniform form in general.

So the best current summary is:

$$
\boxed{\text{ref}\to\text{cand}}
$$

is formally established by E5-F, while

$$
\boxed{\text{cand}\to\text{ref}}
$$

is not supported, and the controlled uniformity counterexample shows why it cannot follow merely from the comparator's pointwise-bound structure.

One precision point: we have not constructed an actual mass-action reaction network satisfying OpenAI's comparator theorem while violating permanence. So we  shouldn't yet write the strongest possible source-level claim

$$
\text{cand}\nrightarrow\text{ref}
$$

as a theorem specifically about genuine mass-action systems. What we have proved is that the logical information present in the candidate is insufficient to recover classwise uniformity.

So E5 summary is:

$$
\boxed{
\text{SemantEq D: neither direction discovered}
}
$$

but our audit subsequently found

$$
\boxed{
\text{Reference}\Rightarrow\text{Candidate}
}
$$

and identified loss of classwise uniformity as the remaining reason the candidate should be regarded as weaker.


| Probe | Finding |
|---|---|
| E5-A | Loss of classwise uniformity is a genuine weakening |
| E5-B | Abstract all-time is stronger than eventual; SemantEq missed the easy implication |
| E5-C | With dynamics abstracted away, combined statements are genuinely incomparable |
| E5-D | Source-shaped but opaque dynamics still look incomparable |
| E5-D1/D2 | Positivity + continuity + finite species eliminate the temporal conflict |
| E5-E1/E2 | Compact positive absorbing set gives a common reciprocal concentration box |
| E5-F | Full reduced composition proves headline-style permanence ⇒ comparator-style bound |

### E5-G — Provenance and formalization-target alignment

#### Audit question

Does the loss of classwise uniformity observed in the Lean comparator represent an incorrect formalization of the theorem it was intended to formalize, or does the comparator target a different result within OpenAI result family 149?

#### Source revision

OpenAI math repository:

`fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`

Relevant sources:

- `overview.tex`, result family 149
- `lean/docs/149.md`
- `lean/ComparatorChallenges/MassAction.lean`
- `preprints/Boundedness-and-persistence-of-weakly-reversible-mass-action-systems-September-25-2026/`
- `preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026/`

#### Provenance result

The source record distinguishes two related results.

The family-level catalogue entry, **“Permanence for weakly reversible reaction networks,”** states the stronger classwise result. For each positive stoichiometric compatibility class, including an unbounded class, there is one common compact convex forward-invariant absorbing set. Consequently, all positive trajectories in the class eventually share positive lower and finite upper concentration bounds.

The same catalogue entry links two manuscripts:

1. *Boundedness and persistence of weakly reversible mass-action systems* (September 25, 2026).
2. *Uniform Permanence in Weakly Reversible Mass-Action Systems* (October 5, 2026).

The Lean scope document `lean/docs/149.md`, however, identifies the formalized result specifically with the earlier *Boundedness and persistence* paper. Its conclusion is pointwise in the initial state: for every strictly positive initial state, there exists an $\varepsilon\in(0,1)$ bounding every species concentration of every global forward solution between $\varepsilon$ and $\varepsilon^{-1}$ for all nonnegative times. The scope document explicitly states that this bound may depend on the network, rates, and initial state.

The later uniform-permanence proof strengthens this structure. For a fixed positive stoichiometric class $P$, it constructs a common absorbing set $K_P$. Its class-dependent scale $\varepsilon_P$ is fixed independently of the choice of initial point $x^0\in P$; only the finite entry time may depend on $x^0$.

Thus the relevant quantifier distinction is genuinely present in the source provenance:

$$
\text{earlier pointwise result:}
\qquad
\forall x^0\in P\;\exists\varepsilon(x^0),
$$

whereas the later permanence result establishes

$$
\text{later uniform result:}
\qquad
\exists\varepsilon_P\;\forall x^0\in P,
$$

with trajectory-dependent entry time allowed.

#### Relation to E5-A–F

The provenance audit agrees with the formal experiments.

**E5-A** showed independently that

$$
\exists\varepsilon\;\forall x^0
\quad\Longrightarrow\quad
\forall x^0\;\exists\varepsilon,
$$

while the reverse implication fails in general. Thus the pointwise quantifier structure does not itself encode classwise uniformity.

**E5-B–D** initially exposed an apparent competing temporal distinction between eventual bounds and bounds valid from time zero. When trajectory regularity was left abstract, the combined reduced propositions could even become logically incomparable.

**E5-D1/D2** showed why that abstraction was misleading for genuine positive finite-dimensional dynamics: positivity and continuity allow an eventual reciprocal box to be extended backward across the compact finite transient to a trajectory-specific reciprocal box valid from time zero.

**E5-E1/E2** established that a compact subset of the positive orthant lies in a common reciprocal concentration box.

Finally, **E5-F** composed these facts, under explicit forward-continuity, positivity, uniqueness, and compatibility-class assumptions, to prove

$$
\text{headline-style classwise permanence}
\Longrightarrow
\text{comparator-style pointwise all-time bounds}.
$$

The remaining fidelity difference is therefore the loss of classwise uniformity, not the superficial eventual-versus-all-time distinction.

#### Interpretation

The Lean comparator should **not** be described as an incorrect formalization of the theorem it explicitly targets. Its own scope documentation identifies the earlier boundedness-and-persistence result, and its initial-state-dependent bound is consistent with that target.

Relative to the **family-level headline**, however, the Lean artifact does not formalize the stronger classwise-uniform permanence conclusion supplied by the later companion result.

The most precise classification is therefore:

**formalization-target / provenance mismatch**

rather than:

**incorrect formalization**.

Schematically,

$$
\text{family headline}
=
\text{later uniform-permanence result},
$$

while

$$
\text{Lean comparator}
=
\text{earlier pointwise boundedness-and-persistence result}.
$$

The comparator is therefore a faithful formalization of a genuine weaker companion result, while being weaker than the stronger result used to characterize the family as a whole.

#### E5-G status

**Confirmed provenance / target-alignment distinction.**

No SemantEq classification is assigned to E5-G because this subexperiment audits source selection and theorem provenance rather than running a proposition-equivalence comparison.
