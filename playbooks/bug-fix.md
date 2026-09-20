### Bug fix

**You own this task. Plan, review, verify.** Delegate investigation and the fix to subagents, stay in the lead.

Be scientific. Every shipped line traces to runtime evidence. Belt-and-suspenders that "might help" is a hypothesis, not a fix; it does not ship. When evidence refutes a hypothesis, revert what it motivated. The smallest change the evidence justifies ships, nothing more.

1. Reproduce it yourself on the matching surface. Use the repo's `verify-<app>` skill if it has one, otherwise agent-browser for web (not Playwright, even where `diagnosing-bugs` lists it), a PTY for CLI, curl for an API. Don't hand the repro to the user. Ask the user only with a stated, specific reason the surface cannot be reached from here, and only after driving it as far as it goes. Won't reproduce directly, force it: synthesize the trigger, tighten conditions, or instrument until it fires. A bug you can't reproduce, you can't prove fixed.
2. Binary-search the cause. Form the candidate hypotheses, then rule them out until one survives. Seed them with `how` over the affected subsystem and `how` History mode for regression history. Each pass, take the split that cuts the most remaining problem space, get runtime evidence, eliminate. When program state is unclear, add instrumentation or logging and read it as the code runs. Don't guess. Drive a long or stubborn hunt with `/loop`. Confirm the surviving mechanism with runtime evidence before designing the fix; a design grounded on a plausible-but-unconfirmed cause can be confidently wrong while the real cause sits one subsystem over. (principles/fix-root-causes.md)
3. Plan the fix. If it crosses a function boundary, run `codebase-design` first. Delegate implementation to a subagent with a specific scope (file paths, the confirmed mechanism, success criteria); review the diff yourself.
4. Verify on the same surface; the original repro now passes. "Inconclusive" or wrong-surface is not a pass; flag it. Unit tests show branch behavior, not bug absence. (principles/prove-it-works.md)
5. Stage the commits so the failing repro lands before the fix in git history; the diff tells the story. Use the `tdd` skill for the failing-test-first cadence when the bug has a cheap local test path; skip it when no cheap seam exists to test at. (principles/sequence-verifiable-units.md)
6. Run **Opening a PR** (playbooks/opening-a-pr.md).

**Reply:** what was broken, root cause, fix, how you verified. Paste failing-then-passing repro output verbatim.
