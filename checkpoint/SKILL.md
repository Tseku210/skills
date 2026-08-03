---
name: checkpoint
description: Commit current work in logical units, push, optionally open a PR, and leave a resume note so the next session (after /clear or /compact) continues without re-explanation. Use when the user says "commit", "commit and push", "commit and pr", "commit and continue", "checkpoint", or is about to compact/clear a long session.
---

# Checkpoint

Turn "commit and push", "commit and pr", "commit and continue to X" from a
multi-turn ceremony into one command. A checkpoint = clean commits + pushed
branch + a resume note that survives context reset.

Arguments: `$ARGUMENTS` — optional. May include `pr` (open/update a PR),
`continue <task>` (keep working after checkpointing), or a hint about which
changes belong together.

## Steps

### 1. Survey (parallel)

Run together: `git status`, `git diff` (staged + unstaged), `git log
--oneline -5`, current branch name.

- Never commit on `main`/`master` in **client/work repos** (anything under
  `dev/work/`): create a descriptive branch first.
- Personal repos: committing on main is fine unless a PR was requested —
  then branch.
- If the working tree is clean, say so and stop; don't invent a commit.

### 2. Split into logical units

Group the diff into logical commits, not one blob. Unrelated changes
(e.g. a bug fix that rode along with a feature) get separate commits —
stage with `git add <paths>` per unit. When one file mixes concerns,
prefer one honest commit over `git add -p` gymnastics.

Say the plan in one line before executing: "2 commits: fix report-card
dedupe; feat recall-mode UI."

### 3. Commit

Conventional format, per `~/.claude/rules/git-workflow.md`:

```
<type>: <description>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci.
No attribution footer (disabled globally). Body only when the diff doesn't
explain itself.

### 4. Push (and PR only if asked)

- Push; use `-u origin <branch>` for new branches.
- If `$ARGUMENTS` mentions `pr`: analyze `git diff <base>...HEAD` and the
  full commit history (not just the last commit), then `gh pr create` with a
  comprehensive summary and a test-plan checklist. If a PR already exists
  for the branch, push updates and note the PR URL instead of creating one.
- No PR requested → no PR. Don't ask.

### 5. Resume note

Write/update `plans/RESUME.md` in the repo (create `plans/` if missing;
add to `.gitignore` if the repo doesn't track plans). Keep it under ~15
lines — it replaces the hand-written /compact summary:

```markdown
# Resume — <branch> (<date>)
Done: <one line per commit just made>
Next: <the immediate next task, from $ARGUMENTS or conversation>
Verify: <exact commands — e.g. pnpm test, pnpm dev + URL to click>
Gotchas: <anything a fresh session would trip on; omit if none>
```

Then tell the user: "Checkpointed. Safe to /clear — start the next session
with `read plans/RESUME.md`."

### 6. Continue (only if asked)

If `$ARGUMENTS` says `continue <task>`, resume that work immediately after
committing — don't stop for confirmation.

## Anti-patterns

- Don't run builds/tests as a gate here unless the user asked — checkpoint
  is for saving state fast; note untested status in the resume note instead.
- Don't reorder or squash existing commits.
- Don't push to main in work repos, force-push, or merge — ever.
