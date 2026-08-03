# Git & Shipping Vocabulary

*How code moves from your editor to production.*

**Working tree** — The actual files on disk you're editing. "Dirty" means it differs from the last commit; "clean" means nothing to commit.

**Staging area (index)** — The holding pen between edits and a commit. `git add` moves changes here; a commit records only what's staged, which is what makes split commits possible.

**Atomic commit** — One logical change per commit: a fix and a feature that happen to be in the same file still get two commits. The unit you want when reverting or reviewing.

**HEAD** — The commit you're currently standing on. "Detached HEAD" means you're standing on a commit directly instead of a branch — new commits there are easy to lose.

**Merge vs rebase** — Merge ties two histories together with a merge commit; rebase replays your commits on top of the new base as if you'd started there. Rebase gives linear history but rewrites commits — never rebase what's already pushed and shared.

**Fast-forward** — A "merge" that needs no merge commit because the target branch simply hasn't moved. What happens when you `git pull` and nothing diverged.

**Merge-base** — The common ancestor of two branches. `git diff main...HEAD` (three dots) diffs from the merge-base — "everything this branch adds" — which is what a PR shows.

**Squash** — Collapsing several commits into one. Right for "wip, wip, fix typo" chains; wrong when the commits are genuinely separate decisions.

**Cherry-pick** — Copying a single commit onto another branch without bringing its history along. For "I need just that fix on main."

**Stash** — A quick shelf for uncommitted changes when you need a clean tree *right now*. Stashes are easy to forget; a WIP commit on a branch is more durable.

**Worktree** — A second checkout of the same repo in another directory, on its own branch. Lets an agent or experiment run in isolation without touching your working copy.

**Revert vs reset** — Revert adds a new commit that undoes an old one (safe on shared history). Reset moves the branch pointer backwards: `--soft` keeps changes staged, `--mixed` keeps them in the tree, `--hard` deletes them. "Put it back" usually means revert.

**Amend** — Rewriting the most recent commit (message or content). Fine before pushing; after pushing it's history rewriting.

**Force-push vs force-with-lease** — Both overwrite the remote branch. `--force-with-lease` refuses if someone else pushed meanwhile; plain `--force` doesn't check. If you must overwrite, use the lease.

**Reflog** — Git's local journal of everywhere HEAD has been. The recovery tool when a reset or rebase "lost" commits — they're almost never actually gone.

**Upstream / tracking branch** — The remote branch your local branch pushes to and compares against. `git push -u` sets it on first push; after that, bare `git push` knows where to go.

**Fetch vs pull** — Fetch downloads remote changes without touching your work; pull is fetch + merge (or rebase) into your branch. "Let me see what changed" is fetch.

**Bisect** — Binary search through history to find the commit that introduced a bug. Turns "sometime in the last 60 commits" into ~6 checkouts.

**Blame** — Line-by-line "which commit last touched this." For finding *why* a line exists, not who to blame — read the commit message it points to.

**Conventional commit** — The `type: description` message format (feat, fix, refactor, chore…). The type answers "would a changelog care, and how?"

**Draft PR** — A pull request marked not-ready-for-review. The right default for agent-opened PRs and work you want CI on before humans look.

**Merge conflict — ours vs theirs** — During a merge, "ours" is the branch you're on, "theirs" is the branch coming in. During a *rebase* they flip, which is why people pick the wrong side.

**Trunk-based / feature branch** — Trunk-based: everyone commits to main in small slices behind flags. Feature branches: work diverges until a PR lands it. Solo projects drift toward trunk-based naturally; client work wants branches and PRs.

**Land** — A change "lands" when it reaches the main branch, however it got there. "It should land on main" = the end state, agnostic about merge vs rebase vs squash.

**Checkpoint** — Commit + push + a resume note, so work survives a context reset or machine change. Cheap insurance before risky steps.

**Hotfix** — A minimal fix taken straight to production outside the normal cadence. Its defining property is smallness — a hotfix that refactors is not a hotfix.

**Shallow clone** — A clone with truncated history (`--depth 1`). Fast for CI and one-off inspection; wrong when you need blame, bisect, or full log.

**Monorepo** — Many projects, one repository, shared tooling. The opposite trade of polyrepo: atomic cross-project changes, but heavier tooling to keep builds scoped.
