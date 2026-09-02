# Subtract before you add

When evolving a system, remove complexity first, then build. Deletion gives a simpler base, which makes the next addition smaller and less brittle. Default to subtraction, and leave the design slightly simpler behind the same or smaller surface than you found it.

- Sequence removal before construction.
- Cut before you polish: get to the minimum before investing in quality.
- Design for observed usage, not speculative edge cases.
- No speculative validators, parsers, or guards beyond what the spec demands. Out-of-spec features drag validators behind them.
- Simplify prompts, skills, and docs the same way: remove redundant instructions and stubs with no novel content.
