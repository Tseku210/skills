# Build the lever

When the work isn't trivial, build the tool that does it instead of doing it by hand.

Why: a codemod, generator, or script does the work the same way every time and reruns for free, and it is one artifact a reviewer can read and rerun. Hand-done changes can only be re-verified by redoing them. A deterministic script turns "trust me" into "run this".

- Do the first unit by hand to learn the recipe, then build the tool. Prove it by rerunning on that unit and diffing against your hand-done version. Make it safe to rerun.
- Codemod or script for edits, generator for repetitive files, a query for analysis, a rerunnable check for verification.
- A deterministic lever beats fan-out. If a script can process every unit in one pass, run it yourself; don't fan out delegates to hand-apply what a script can do.
- When you do fan out, write the recipe, the verification contract, and the do-not-touch fences as one artifact every delegate reads, outside their write scope.
- Applying this principle produces a file. If you cited it and there is no script in the diff, you didn't apply it.
- Commit the lever when the work outlives the session.

The bar is triviality, not repetition. Build the smallest script that does or proves the job, never a framework.
