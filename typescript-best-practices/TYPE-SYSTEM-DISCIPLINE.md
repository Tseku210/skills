# Type system discipline

The type checker is a proof assistant. Use it to eliminate impossible states, mismatched primitives, and unhandled variants at compile time. Prefer defining errors and special cases out of existence over adding handlers.

- Make illegal states unrepresentable. Model variants as discriminated unions (or enums with payloads in Swift), not a bag of optional fields where contradictory combinations compile. `{ completed: boolean; completedAt?: Date }` admits nonsense; use `{ kind: 'open' } | { kind: 'done'; at: Date }` or derive the boolean from one source.
- Types are constructions, not restrictions. Build the type from the values you want instead of carving them out of a looser type with checks. A non-empty list is a head plus a rest; a valid time range is a start plus a duration.
- Brand semantic primitives. `UserId` and `OrderId` are strings underneath but must not be interchangeable. Validate once at creation, trust downstream.
- External data is untyped until parsed. JSON, CMS payloads, form input, env vars, DB rows: a parse function at every boundary turns them into the typed model.
- Don't lie to the type system. `as`, `!`, and `any` are runtime crashes waiting to happen. If the compiler can't prove a fact, prove it (narrow, validate, refine the model) or name the cast as a hazard.
- Exhaustive matching is the compiler's job. A `never`-typed default so a new variant fails compilation, not production.
- Derive types from authoritative schemas (Payload generated types, wrangler types, zod schemas) instead of hand-rolling a parallel shape that drifts.
- Strengthen a type only where partiality appears. A "this should never happen" throw marks a type that is too weak; push the check into the type, then stop. Prefer total functions. Extra precision beyond that costs reuse and buys no safety.

Tests: can you write a comment explaining when this combination of fields is valid? Then split it. Do two arguments share a primitive but mean different things? Brand them. Where did this `as` come from? Trace it to the boundary. Will the compiler tell the next agent where to add a case? If not, the match isn't exhaustive.
