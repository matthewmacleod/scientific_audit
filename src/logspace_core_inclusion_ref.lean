import Mathlib

namespace LogspaceDerandomization

axiom Language : Type
axiom L : Set Language
axiom RL : Set Language
axiom BPL : Set Language

theorem logspace_core_inclusion_ref :
    L ⊆ RL →
      RL ⊆ BPL →
        BPL ⊆ L := by
  sorry

end LogspaceDerandomization
