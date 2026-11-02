import Mathlib

namespace HeilbronnAsymptoticBridge

open Filter

def PowerLowerSubsequence
    (delta : ℝ)
    (Valid : ℕ → ℝ → Prop) : Prop :=
  0 < delta ∧
    ∃ n : ℕ → ℕ,
      ∃ a : ℕ → ℝ,
        Tendsto n atTop atTop ∧
          ∀ j : ℕ,
            3 ≤ n j ∧
            Valid (n j) (a j) ∧
            Real.rpow (n j : ℝ) (-2 + delta) ≤
              a j

def EventualAlmostUpperBound
    (epsilon : ℝ)
    (Valid : ℕ → ℝ → Prop) : Prop :=
  ∃ C : ℝ,
    0 < C ∧
      ∃ n0 : ℕ,
        ∀ n : ℕ,
          n0 ≤ n →
            3 ≤ n →
              ∀ a : ℝ,
                Valid n a →
                  a ≤
                    C *
                      Real.rpow
                        (n : ℝ)
                        (-2 + epsilon)


/--
A power-improved lower bound along an unbounded subsequence
contradicts an eventual universal upper bound with half the
improvement exponent.
-/
theorem powerLowerSubsequence_refutes_eventualAlmostUpperBound
    {delta : ℝ}
    {Valid : ℕ → ℝ → Prop}
    (h :
      PowerLowerSubsequence delta Valid) :
    0 < delta / 2 ∧
      ¬ EventualAlmostUpperBound
          (delta / 2)
          Valid := by

  rcases h with
    ⟨hdelta, n, a, hn, hdata⟩

  have hdelta2 :
      0 < delta / 2 := by
    linarith

  constructor

  · exact hdelta2

  · rintro ⟨C, hC, n0, hupper⟩

    have hcast :
        Tendsto
          (fun j : ℕ => (n j : ℝ))
          atTop
          atTop :=
      tendsto_natCast_atTop_atTop.comp hn

    have hgrow :
        Tendsto
          (fun j : ℕ =>
            Real.rpow
              (n j : ℝ)
              (delta / 2))
          atTop
          atTop :=
      (tendsto_rpow_atTop hdelta2).comp hcast

    have hlarge :
        ∀ᶠ j : ℕ in atTop,
          C <
            Real.rpow
              (n j : ℝ)
              (delta / 2) :=
      hgrow.eventually
        (eventually_gt_atTop C)

    have hn0 :
        ∀ᶠ j : ℕ in atTop,
          n0 ≤ n j :=
      hn.eventually
        (eventually_ge_atTop n0)

    rcases
        (hlarge.and hn0).exists
      with
        ⟨j, hjlarge, hjn0⟩

    rcases hdata j with
      ⟨h3, hvalid, hlower⟩

    have hupp :
        a j ≤
          C *
            Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) :=
      hupper
        (n j)
        hjn0
        h3
        (a j)
        hvalid

    have hnpos_nat :
        0 < n j := by
      omega

    have hnpos :
        0 < (n j : ℝ) := by
      exact_mod_cast hnpos_nat

    have hfactor :
        Real.rpow
            (n j : ℝ)
            (-2 + delta)
          =
        Real.rpow
            (n j : ℝ)
            (-2 + delta / 2) *
          Real.rpow
            (n j : ℝ)
            (delta / 2) := by

      calc
        Real.rpow
            (n j : ℝ)
            (-2 + delta)
            =
          Real.rpow
            (n j : ℝ)
            ((-2 + delta / 2) +
              delta / 2) := by
                congr 1
                ring

        _ =
          Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) *
            Real.rpow
              (n j : ℝ)
              (delta / 2) := by
                exact
                  Real.rpow_add
                    hnpos
                    (-2 + delta / 2)
                    (delta / 2)

    have hbase_pos :
        0 <
          Real.rpow
            (n j : ℝ)
            (-2 + delta / 2) :=
      Real.rpow_pos_of_pos
        hnpos
        _

    have hproduct :
        Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) *
            Real.rpow
              (n j : ℝ)
              (delta / 2)
          ≤
        Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) *
            C := by

      calc
        Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) *
            Real.rpow
              (n j : ℝ)
              (delta / 2)
            =
          Real.rpow
            (n j : ℝ)
            (-2 + delta) :=
              hfactor.symm

        _ ≤ a j :=
          hlower

        _ ≤
          C *
            Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) :=
          hupp

        _ =
          Real.rpow
              (n j : ℝ)
              (-2 + delta / 2) *
            C := by
              ring

    have hgrow_le_C :
        Real.rpow
            (n j : ℝ)
            (delta / 2)
          ≤ C :=
      (mul_le_mul_iff_of_pos_left hbase_pos).mp
        hproduct

    exact
      (not_lt_of_ge hgrow_le_C)
        hjlarge

end HeilbronnAsymptoticBridge
