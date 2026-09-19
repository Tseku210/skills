# Foundational thinking

Structural decisions protect option value. Code-level decisions protect simplicity. Over-engineering is usually a premature decision that closes doors; the right foundational data structure keeps them open.

- Data structures first. Get the shape right before writing logic. Define core types early, trace every access pattern, choose structures that match the dominant paths. A data-structure change late is a rewrite; early, a one-line diff.
- DRY the structure, not every line. Types and models converge; three similar statements still beat a premature abstraction. Explicit over clever.
- Concurrency: before sharing state between actors, ask what happens if another actor modifies it concurrently. If the answer isn't "nothing", isolate.
- Scaffold first. If something helps every later phase (checks, types, test infra), do it first. Setup before features, tests before fixes.
- Each increment lands a coherent abstraction or deepens one. Don't spread a new capability across callers as special-case coordination.
- Subtraction comes before scaffolding: remove dead weight, then lay foundations.
