# Boundary discipline

Place validation, type narrowing, and error handling at system boundaries. Trust internal code unconditionally. Business logic lives in pure functions; the shell is thin and mechanical.

Why: scattered validation is noisy, redundant, and gives a false sense of safety. Validate once at the boundary. Keep logic out of framework wiring so it can be tested without the framework.

- At boundaries (CLI args, config, external APIs, form input, CMS payloads, DB rows): validate, return errors, handle defensively.
- Inside the system: typed data, error propagation, no re-validation. Trust the types.
- Across the boundary: expose domain concepts, not the transport's private representation. Don't re-export wire, storage, or framework types through the public surface.
- Business logic in pure functions with no framework dependencies. Parse functions are pure transforms from raw input to typed state.

Tests: "Is this data crossing a system boundary right now?" If not, validation is redundant. "Can this be a pure function the shell just calls?" If yes, extract it.
