# Fix root causes

When debugging, do not paper over symptoms. Trace every problem to its root cause and fix it there.

Why: symptom fixes accumulate. Each workaround makes the system harder to reason about, and the real bug remains.

- Reproduce first. If you can't reproduce it, you can't verify your fix.
- Ask why until you hit the root cause.
- Resist adding guards. A null check that silences a crash is a symptom fix.
- If a workaround needs a paragraph of comment to justify it, the code is wrong. Fix the code.
- Check for the pattern, not just the instance. Grep for the same shape and fix all of them.
- When stuck, instrument. Add logging, read the actual error. Don't guess.

Restart bugs: suspect state before code. Code doesn't change between runs; state does. "Fails after restart" means stale config, cache, lock file, `.wrangler` or `.next` state. If clearing it restores behavior, the fix is state validation.
