# Make operations idempotent

Design operations so they converge to the correct state regardless of how many times they run or where they start from. Applies to seeds, migrations, sync scripts, build steps, scheduled jobs, and anything that runs amid crashes and retries.

- Convergent startup: scan for existing state, clean stale artifacts, adopt what's live.
- Content-based cleanup: compare by content, not creation order.
- Self-healing locks: detect stale locks by PID or age.
- Failed work respawns cleanly; fresh input regenerated each cycle.

The test: what happens if this runs twice in a row? What happens if the previous run crashed at every possible point? Does re-execution converge to the same end state? If any answer is "depends on what was left behind", it needs a reconciliation step.
