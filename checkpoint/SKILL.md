---
name: checkpoint
description: Commit current work in logical units and push, optionally open a PR or leave a resume note. Use when the user asks to commit, push, or checkpoint, or wants a resume note before /clear or /compact.
---

# Checkpoint

Turn "commit and push" and "commit and pr" from a multi-turn ceremony into
one command. A checkpoint = clean commits + pushed branch.

Arguments: `$ARGUMENTS` — optional. May include `pr` (open/update a PR),
`merge` (merge the PR after opening it), `resume` (leave a resume note), or
a hint about which changes belong together.

## Steps

### 1. Survey (parallel)

Run together: `git status`, `git diff` (staged + unstaged), `git log
--oneline -5`, current branch name.

- If the working tree is clean, say so and stop; don't invent a commit.
- If the current branch is already merged into the default branch, run the
  post-merge cleanup from `~/.claude/rules/git-workflow.md` first, then put
  the new work on a fresh branch.
- On the default branch: branch first when the repo lands work through PRs
  (`gh pr list --state merged -L 1` returns one) or a PR was requested.
  Otherwise committing on the default branch is fine.

### 2. Split into logical units

Group the diff into logical commits, not one blob. Unrelated changes
(e.g. a bug fix that rode along with a feature) get separate commits —
stage with `git add <paths>` per unit. When one file mixes concerns,
prefer one honest commit over `git add -p` gymnastics.

Say the plan in one line before executing: "2 commits: fix report-card
dedupe; feat recall-mode UI."

### 3. Commit

Format per `~/.claude/rules/git-workflow.md`. Body only when the diff
doesn't explain itself.

### 4. Push (and PR only if asked)

- Push; use `-u origin <branch>` for new branches.
- If `$ARGUMENTS` mentions `pr`: read [OPENING-A-PR.md](OPENING-A-PR.md)
  and follow it. If a PR already exists for the branch, push updates and
  note the PR URL instead of creating one.
- No PR requested → no PR. Don't ask.
- Merge only when `$ARGUMENTS` says `merge`.

### 5. Resume note (only if asked)

Only when `$ARGUMENTS` mentions `resume`, or the user says they are about
to /clear or /compact. Write/update `plans/RESUME.md` in the repo. If the
repo doesn't track `plans/`, add it to `.git/info/exclude`, not
`.gitignore`. Keep it under ~15 lines:

```markdown
# Resume — <branch> (<date>)
Done: <one line per commit just made>
Next: <the immediate next task, from $ARGUMENTS or conversation>
Verify: <exact commands and what to look at>
Gotchas: <anything a fresh session would trip on; omit if none>
```

## Anti-patterns

- Don't run builds/tests as a gate here unless the user asked — checkpoint
  is for saving state fast; say the work is untested in the reply instead.
- Don't reorder or squash commits that are already pushed.
