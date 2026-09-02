# Laziness protocol

Writing code is cheap for you, which makes over-engineering easy. Counter it by borrowing a human maintainer's fatigue. Aim for the most result with the least code and complexity.

- Prefer deletion. When asked to refactor or improve, look for removals before additions.
- Keep the call hierarchy flat. If answering a question means tracing more than three files or layers, flatten it. A rich interface hiding substantial work is fine; a chain of pass-throughs is not.
- Consolidate decisions. One source of truth, pass the result as a simple flag.
- Minimize the diff. The smallest change that solves the problem. Fewer lines beat "elegant" boilerplate.
- Question the threading. If a task means passing a new signal through types, schemas, and layers, look for a more direct path.
- Sweat the small leaks. Remove tiny pass-throughs and duplicated choices before they spread.

If a human developer would find the code exhausting to maintain, it is a bad solution. Be lazy. Stay simple.
