# Minimize reader load

Maintainability is the work a reader must do to understand code. Track two independent axes: layers to trace (indirections between question and answer) and state to hold (hidden or mutable context the reader must keep in their head). A flat file with fifty globals is as hard as a six-layer adapter stack. Guard both.

- Collapse layers that don't earn their keep: wrappers with one caller, adapters with no second implementation, indirection for a future that never came.
- Adjacent layers must change the abstraction. A layer that repeats the same methods and arguments is pass-through; collapse it.
- Prefer boundaries that hide meaningful decisions over broad interfaces that hide little.
- Shrink state scope: returns over mutations, locals over fields, fields over module state, module state over globals. Derive instead of sync.
- Name the invariant at the boundary, not in every consumer.
- Before adding a layer or a piece of state: does it reduce reader load somewhere else by at least as much?

The test: can a new reader answer "where does X come from?" and "what can change X?" in under thirty seconds? If not, cut layers or cut state.
