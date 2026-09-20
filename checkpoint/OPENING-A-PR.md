# Opening a PR

**Branch.** Work on a branch off main. Use a worktree only when the work runs in parallel with another session on the same repo, or the user asks for one. Small fixes stay in the main checkout. Dirty branch with unrelated work: stash or patch out, don't mix it in.

**Commits.** Commit liberally; rebase into small, ordered commits before opening the PR. Each commit is landable on its own and ordered to tell the story: the failing repro before the fix, the subtraction before the reshape. Amend when the fix belongs in a just-made commit; new commit when separable. Format per `~/.claude/rules/git-workflow.md`: `<type>: <description>`, types feat, fix, refactor, docs, test, chore, perf, ci. No trailing period. Write the body with `technical-writing`, then `unslop`.

**Description.** Base it on everything the branch adds, not the last commit: `git log main..HEAD` for intent, `git diff main...HEAD` for scope. Use these sections in order and drop a section when it is empty.

- `## Why`. The intent and why this approach fits.
- `## Scope`. Facts from the diff. Real symbols and paths. Both sides of a rename. What is in and out when the boundary matters.
- `## Tradeoffs`. Real choices only.
- `## Risk`. Who and what the change touches outside the diff, and why it is safe or risky.
- `## Verification`. How you ran each check and its outcome, not only the command name. Name the real path: the `verify-<app>` skill, agent-browser, the targeted tests. Remaining manual checks go here as `- [ ]` items.

Attach screenshots when they prove a claim. No `## Summary` boilerplate. End the body with the attribution line the session requires.

**Forge.** `gh` only. Push with `-u` for a new branch. Open the PR ready, not draft, unless the user asked for a draft. Run `gh pr view <number>` before referring to PR status.

**Size.** Prefer several narrow PRs to one large one. Branch from main for independent work.

**After.** Post the URL and stop. Opening a PR does not start a watch loop. Once merged, run the post-merge cleanup in git-workflow.md: remove the worktree if any, delete the local branch, delete the remote branch.
