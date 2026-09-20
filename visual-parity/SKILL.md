---
name: visual-parity
description: "Own pixel-exact equivalence, proven by image diff and not by eye: baseline screenshots first, one component at a time, a nonzero diff is a fail. Use for \"make X match Y exactly\", matching a Figma frame, styling-system migrations, porting a UI across frameworks."
---

# Visual parity

**You own pixel-exact equivalence. The baseline is the spec; you do not touch it.** For "make X match Y exactly", "match the Figma", styling-system migrations, porting a UI across frameworks. Equivalence is verified by image diff, not by eye.

1. Establish the baseline first, before any change: screenshots of the current component across its states (and both locales when copy length differs), plus the target. For a Figma target, export the frame at the same viewport width. No baseline, no parity claim. A blocking prerequisite, not a follow-up.
2. Anti-shortcut clauses, stated and held: no harness modifications, no baseline tampering, no component restructuring to make a diff pass. If the baseline looks wrong, stop and ask, don't edit it.
3. Migrate one component at a time. Shared primitives (tokens, Container, type scale) migrate first as a blocking phase. Parallelize across worktrees only when there are several independent components; otherwise serial.
4. Verify each component against its baseline via image diff on the matching surface (agent-browser screenshot at the fixed viewport, then a pixel diff). A nonzero diff is a fail; investigate the pixel delta, don't wave it through. `/loop` per component until the diff is zero or the residual is named and accepted by the user.
5. Run **Opening a PR** (`~/dev/personal/my-skills/playbooks/opening-a-pr.md`) per component or per safe batch.

**Reply:** components migrated, the diff result for each, the baseline location, what's left.
