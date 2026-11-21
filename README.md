# PremiseSelection

Find relevant theorems from libraries and project files, using a local embedding model.

1. No dedicated GPU required.
2. No internet connection required.
3. Precomputed cache for Mathlib (Under 1 GB).
4. Embeddings computed locally for project files.
5. Embedding cache updates as project files update.
6. Under 1 second of latency.

## Installation

Add the following dependency to your `lakefile.toml`:
```
[[require]]
name = "PremiseSelection"
scope = "chasenorman"
```
Or, if you are using a `lakefile.lean`:
```
require "chasenorman" / "PremiseSelection"
```

You should then be prompted to run `lake update PremiseSelection`.

## Usage

Any file that imports `PremiseSelection` will bind `+suggestions` to our selector.

```lean
import PremiseSelection

example (a b : Nat) : a + b = b + a := by premises
```

By clicking on the `premises` tactic, a widget appears in the InfoView, showing download progress for the embedding cache. Once the local server is running, it shows the top suggestions (in this case, commutativity lemmas).

All files saved by `PremiseSelection` are in the `.lake` directory.