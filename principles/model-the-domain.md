# Model the domain

Encode the real domain in a data structure instead of scattering it across conditionals. Scattered booleans, repeated shape assumptions, and branching spread across files are accidental complexity. A structure that matches the domain makes invalid states unrepresentable and deletes branches. Choosing it at write time is cheap; recovering it later reads as a refactor and gets deferred.

Reach for:
- A state machine instead of scattered booleans, phases, or lifecycle checks.
- A typed model instead of loose parameters or repeated shape assumptions.
- A map, registry, lookup table, or discriminated union instead of branching spread across files.
- A reducer or command/event model instead of ad hoc mutations.
- A module organized around one body of domain knowledge instead of a load, validate, transform, save sequence. Execution order is not ownership.
- A queue, cache, index, tree, or normalized collection where the access pattern calls for it.

Don't force it. Boring code stays when the shape is clear, local, and unlikely to grow. Be skeptical of an abstraction that adds indirection without removing branches, duplicated rules, invalid states, or lifecycle risk.

The tells you skipped this: a feature that grows an if/else chain by one more branch, a second boolean that must stay in sync with the first, phase-named modules repeating the same domain rules.
