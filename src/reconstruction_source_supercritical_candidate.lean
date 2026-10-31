import Mathlib

namespace OAI
namespace ThreeState

abbrev Spin := Fin 3

def Admissible (lam : ℝ) : Prop :=
  -(1 / 2 : ℝ) ≤ lam ∧ lam ≤ 1

noncomputable def channel (lam : ℝ) (i j : Spin) : ℝ :=
  if i = j then (1 + 2 * lam) / 3 else (1 - lam) / 3

def Observation : ℕ → Type
  | 0 => Spin
  | n + 1 => Multiset (Observation n)

theorem channel_nonneg {lam : ℝ} (h : Admissible lam) (i j : Spin) :
    0 ≤ channel lam i j := by
  unfold channel
  split_ifs
  · dsimp [Admissible] at h
    linarith [h.1]
  · dsimp [Admissible] at h
    linarith [h.2]

theorem channel_sum (lam : ℝ) (i : Spin) :
    ∑ j, channel lam i j = 1 := by
  fin_cases i <;> simp [channel, Fin.sum_univ_succ] <;> ring

noncomputable def channelPMF
    (lam : ℝ) (h : Admissible lam) (i : Spin) : PMF Spin :=
  PMF.ofFintype
    (fun j => ENNReal.ofReal (channel lam i j))
    (by
      rw [← ENNReal.ofReal_sum_of_nonneg
        (fun j _ => channel_nonneg h i j)]
      simp [channel_sum])

noncomputable def iidList {α : Type*} (p : PMF α) :
    ℕ → PMF (List α)
  | 0 => PMF.pure []
  | n + 1 =>
      p.bind fun a =>
        (iidList p n).map (List.cons a)

noncomputable def observedLaw
    (offspring : PMF ℕ)
    (lam : ℝ)
    (h : Admissible lam) :
    (n : ℕ) → Spin → PMF (Observation n)
  | 0, i => PMF.pure i
  | n + 1, i =>
      offspring.bind fun k =>
        (iidList
          ((channelPMF lam h i).bind
            (observedLaw offspring lam h n))
          k).map
          (fun xs : List (Observation n) =>
            (xs : Multiset (Observation n)))

noncomputable def uniformSpin : PMF Spin :=
  PMF.ofFintype
    (fun _ => 1 / 3)
    (by
      simp
      exact ENNReal.mul_inv_cancel
        (by norm_num)
        (by finiteness))

noncomputable def marginal {α : Type*}
    (law : Spin → PMF α) : PMF α :=
  uniformSpin.bind law

noncomputable def posterior {α : Type*}
    (law : Spin → PMF α)
    (y : α)
    (i : Spin) : ℝ :=
  if marginal law y = 0 then 1 / 3
  else
    (law i y).toReal /
      (3 * (marginal law y).toReal)

noncomputable def advantage {α : Type*}
    (law : Spin → PMF α) : ℝ :=
  ∑' y,
    (marginal law y).toReal *
      ((∑ i : Spin,
        |posterior law y i - 1 / 3|) / 2)

noncomputable def regularLaw
    (b : ℕ)
    (lam : ℝ)
    (h : Admissible lam)
    (n : ℕ) :=
  observedLaw (PMF.pure b) lam h n

noncomputable def regularAdvantage
    (b : ℕ)
    (lam : ℝ)
    (h : Admissible lam)
    (n : ℕ) : ℝ :=
  advantage (regularLaw b lam h n)

def Reconstructs (a : ℕ → ℝ) : Prop :=
  ∃ L : ℝ,
    0 < L ∧
      Filter.Tendsto a Filter.atTop (nhds L)

/-- E4-B candidate:
    OpenAI's selected regular-tree supercritical theorem. -/
theorem regular_supercritical
    (b : ℕ)
    (hb : 2 ≤ b)
    (lam : ℝ)
    (h : Admissible lam)
    (hcrit : 1 < (b : ℝ) * lam ^ 2) :
    Reconstructs (regularAdvantage b lam h) := by
  sorry

end ThreeState
end OAI
