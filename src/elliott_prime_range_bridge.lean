import Mathlib

theorem prime_range_eq (N : ℕ) :
    (Finset.Icc 2 N).filter Nat.Prime =
      (Finset.range (N + 1)).filter Nat.Prime := by
  ext p
  simp only [Finset.mem_filter, Finset.mem_Icc, Finset.mem_range]
  constructor
  · rintro ⟨⟨hp2, hpN⟩, hpPrime⟩
    exact ⟨Nat.lt_succ_of_le hpN, hpPrime⟩
  · rintro ⟨hpN, hpPrime⟩
    exact ⟨⟨hpPrime.two_le, Nat.le_of_lt_succ hpN⟩, hpPrime⟩
