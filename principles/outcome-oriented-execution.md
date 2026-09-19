# Outcome-oriented execution

Optimize for the intended, verifiable end state rather than preserving smooth intermediate states. Keeping every intermediate step fully stable creates temporary compatibility code that becomes long-lived debt.

- Prioritize end-state integrity over transitional stability.
- Intermediate breakage is acceptable when it is planned, scoped, and reversible. Declare where.
- Keep high-signal checks on the areas actively being touched while migrating.
- Run full static and runtime verification at plan completion, always, before declaring done.

For planned rewrites and migrations with explicit phase boundaries. Not a license to leave main broken between sessions.
