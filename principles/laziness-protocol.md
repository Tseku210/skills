# Laziness protocol

Aim for the most result with the least code and complexity. Over-engineering is the default failure here, not under-building.

- Prefer deletion. When asked to refactor or improve, look for removals before additions.
- Keep the call hierarchy flat. If answering a question means tracing more than three files or layers, flatten it. A rich interface hiding substantial work is fine; a chain of pass-throughs is not.
- Consolidate decisions. One source of truth, pass the result as a simple flag.
- Minimize the diff. The smallest change that solves the problem. Fewer lines beat "elegant" boilerplate.
- Question the threading. If a task means passing a new signal through types, schemas, and layers, look for a more direct path.
- Sweat the small leaks. Remove tiny pass-throughs and duplicated choices before they spread.

If a human maintainer would find the code exhausting to read six months from now, it is a bad solution.
