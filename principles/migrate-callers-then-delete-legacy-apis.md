# Migrate callers, then delete legacy APIs

When a new API is the right design, migrate callers and remove the old API in the same wave instead of preserving compatibility layers.

- Don't keep legacy paths alive only because internal callers still exist. Inventory callers, migrate them, delete the old API immediately.
- Temporary adapters are exceptional and time-boxed, not default architecture.
- Update tests to assert the new contract; delete tests that only protect pre-refactor implementation details.

Applies when no external users depend on backward compatibility, the project can absorb coordinated breaking changes, and the new API is part of a simplification. That is every repo here. Keeping both paths creates dual-path complexity and makes the codebase feel append-only.
