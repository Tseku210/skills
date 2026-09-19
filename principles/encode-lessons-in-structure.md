# Encode lessons in structure

Encode recurring fixes in mechanisms (lint rules, types, runtime checks, scripts) instead of textual instructions. Every correction is a learning signal. Capture it, route it, close the loop.

Why: textual instructions require the reader to notice, remember, and comply. A mechanism enforces the rule without cooperation.

When you catch yourself writing the same instruction a second time:
1. Ask whether it can be a lint rule, a type, a runtime check, or a script.
2. If yes, encode it and delete the instruction.
3. If no (it needs judgment), make the instruction more prominent and add an example of the failure.

Pick the strongest rung available: an unrepresentable state that cannot compile, then a lint or banned API that fails the check script, then a canonical helper, then a runtime check. Agents copy whatever surrounding code does, so a weak guard becomes the next template.

Route each correction to the right layer: one-off, a note; recurring, a skill or lint rule; systemic, a principle. Then apply it now or create a concrete todo. "I'll keep that in mind" does not persist.
