# Sequence work into verifiable units

Order work as a sequence of small units, each ending in a state you can check, and don't advance until the current one is green. A break caught at the unit that caused it is cheap to localize; a break caught after a batch is buried under work built on a broken base.

Execution: in a sweep, migration, or run of similar edits, verify each change before starting the next. Never batch the edits and verify once at the end. Each unit is known-good state, one change, run the check, proceed. Rebase onto clean main first so every check measures against the real baseline. When a script does the edits, the per-unit check is nearly free; run it anyway.

Delivery: stack commits and PRs in the order that proves the work. The canonical shape is the failing test first, then the fix on top, so a reviewer sees red then green. Other story orders: subtraction before reshape, baseline capture before treatment, scaffold before feature. Each commit lands on its own and the sequence reads as an argument.

Pick the smallest unit that ends in a check. Verify before advancing. Order the units so the sequence builds confidence for you while executing and for a reviewer reading the stack.
