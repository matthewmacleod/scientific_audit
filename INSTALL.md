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

## Install OAI lean

```
mkdir -p ../src/OAI/NumberTheory/PiExponent

curl -L \
  https://raw.githubusercontent.com/openai/math/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/NumberTheory/PiExponent/Statement.lean \
  -o ../src/OAI/NumberTheory/PiExponent/Statement.lean
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   865  100   865    0     0   4635      0 --:--:-- --:--:-- --:--:--  4650
(base) [Sun Nov 01-16:24:34][mkm@mactop SemantEq]$ shasum -a 256 ../src/OAI/NumberTheory/PiExponent/Statement.lean
7287b5651b7d76ad871ab60de3e2ff65f9e68e6f36223a3ff8e6b764784d3f7d  ../src/OAI/NumberTheory/PiExponent/Statement.lean
```
