### Feature

**You own the design. Plan, review, verify.** Delegate implementation; stay in the lead.

1. `how` over the affected subsystem.
2. `codebase-design` for design exploration when the change crosses a function boundary or admits more than one shape. Skipping stays as `codebase-design skipped: <reason>`; do not fold the design decision silently into implementation.
3. Write the throughput checkpoint as four todo items. A dimension that genuinely does not apply (single file, no fan-out) keeps its item with `n/a: <reason>` rather than being dropped:
   - **Blocking first steps.** Gates run before fan-out.
   - **Independent workstreams.** Disjoint files, services, or layers parallelize. Shared writes serialize.
   - **Shared mutable state.** Default to splitting the target. Serialize only for real invariants. (principles/separate-before-serializing-shared-state.md)
   - **Smallest safe decomposition.** If one worker is best, name why. Usually it is; this laptop runs the workers.
4. Name the data shape and its organizing structure before any logic is written: a state machine over scattered booleans, a table or registry over branching, a typed model over repeated shape assumptions. (principles/model-the-domain.md) Delegate code-writing to a subagent with a specific scope (file paths, the named data shape, success criteria); review its diff yourself. When the implementation admits multiple valid shapes (error handling, abstraction layer, test structure), spawn two delegates with the same brief and pick, rather than one delegate deciding silently. Surgical edits; re-ground against the source for generated files. Port shared-primitive improvements to all consumers and verify each. Commit liberally.
5. Verify on the matching surface. "Inconclusive" or wrong-surface is not a pass; flag it. For a bilingual surface, both locales. (principles/prove-it-works.md)
6. Rebase into small, ordered commits; stack follow-ups. Build, verify, and commit each small unit before the next. (principles/sequence-verifiable-units.md)
7. If the design is contested, run `code-review` before shipping.
8. Run **Opening a PR** (playbooks/opening-a-pr.md).

Code-coupled work (one feature, one migration) goes to a single owner with the checkpoint inline; that owner fans out internally after the blocking phase. Parent-level fan-out is for slices that produce independent artifacts (audits, cross-subsystem investigations, competing experiments). Rewrite the checkpoint at phase boundaries; spawn a fresh owner rather than chaining interrupts.

**Reply:** what you built, what you chose and why, open decisions. Tables for design alternatives.
