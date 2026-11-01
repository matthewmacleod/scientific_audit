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

