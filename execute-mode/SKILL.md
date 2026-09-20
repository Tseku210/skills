---
name: execute-mode
description: "Implement the tickets from /to-tickets with nobody in the loop. Implementer subagents take one ticket each in their own worktree, the main session reads every diff and merges, then proves the result on the real app, runs code review, marks the PR ready and gets CI green."
disable-model-invocation: true
argument-hint: "<tickets or spec reference> [max N] [dry-run] [merge when green]"
---

# Execute mode

Turn approved tickets into a proven, reviewed, ready PR while the user is away. Planning was the human part. `/grill-with-docs`, `/to-spec` and `/to-tickets` settled the design and the seams, so from here to a ready PR nothing asks.

## Input

Tickets from `/to-tickets` and nothing else: a `.scratch/<feature-slug>/issues/` directory, or a spec issue on the tracker, whose tickets are its sub-issues and the issues that say "Part of #N". The spec itself is never a ticket. A plan file or a chat description stops with "run `/to-tickets` first". One ticket is a valid set.

Check the shape before anything else. An implementation ticket has "What to build" and acceptance criteria. Wayfinder tickets share the same directory layout but carry a `Type:` line and a question, and their product is a decision. Those stop with "these are wayfinder tickets, resolve them with `/wayfinder`". A ticket with no acceptance criteria stops the same way, naming the ticket.

One exception. When the conversation holds a grilled, agreed design that fits one context window and no tickets exist, write it as a single ticket in the `/to-tickets` local template at `.scratch/<feature-slug>/issues/01-<slug>.md`, then carry on.

Arguments in `$ARGUMENTS`:

- `max N` caps concurrent implementers. Default is no cap, the whole frontier at once.
- `dry-run` prints the ticket graph, the frontier order and the implementer briefs, and changes nothing.
- `merge when green` merges the PR once CI passes.

## Roles

The main session orchestrates, reads diffs, merges and proves. It writes no feature code. Implementer subagents write all of it. An implementer's summary is a claim. Its diff and the running app are the evidence.

## Steps

1. Read every ticket, and the spec when one exists (`.scratch/<feature-slug>/spec.md` locally, the parent issue on a tracker). Build the graph from the "Blocked by" edges. A ticket is done when its local `Status:` is `resolved` or its tracker issue is closed. The frontier is every `ready-for-agent` ticket whose blockers are all done. Tickets in any other state are reported and left alone.
2. If the tickets leave the affected code unclear, run `how` once and save the notes to the scratchpad, outside the repo. Every implementer gets the path.
3. Fetch, create the PR branch `<type>/<feature-slug>` off the remote default branch, push it, and open a draft PR. The slug is the `.scratch` directory name, or one you pick from the spec title. On a tracker, the PR closes the spec issue and the tickets. The body follows `~/dev/personal/my-skills/playbooks/opening-a-pr.md` and carries a section `## Decisions made without you`.
4. Work the frontier. With the main session on the PR branch, spawn one implementer per frontier ticket in a single message, each with `isolation: "worktree"` and its own branch `<feature-slug>/<ticket id>-<slug>`, the id being the file number or the issue number. With `max N`, keep N running and start the next as one returns. The brief is the ticket verbatim, the spec reference, the notes path, and these rules: use `tdd` at the seams the spec names, commit small units per `~/.claude/rules/git-workflow.md`, stay inside the ticket, return the branch name and every assumption you had to make.
5. As each implementer returns, read its diff against the ticket's acceptance criteria and run the repo's gates on its branch: the check CI runs when there is one, otherwise typecheck, lint and tests. A repo with none gets that fact stated in the PR body. A failure goes back to the same implementer with the specifics. A pass gets merged into the PR branch and pushed. Resolve mechanical conflicts yourself and return the rest to the implementer. Mark the ticket done (local tickets get `Status: resolved`, tracker issues close with the PR), copy its assumptions into the decisions section, recompute the frontier, and repeat from 4 until no tickets remain.
6. Prove it on the real app from the PR branch. Use the repo's `verify-<app>` skill. If there is none, drive the matching surface yourself: agent-browser for web, a PTY for a CLI, curl for an API. Walk every acceptance criterion and record what you saw. "Inconclusive" or the wrong surface is a fail. If the work has no runnable surface at all, say so in the PR body and claim no proof. A failure goes to one implementer, then prove again. (principles/prove-it-works.md)
7. If the diff changed code that callers outside the tickets share, run `blast-radius` on it.
8. Run `mattpocock-skills:code-review` on the PR branch. The built-in `/code-review` is a different tool. Give every accepted finding to a single implementer, one round. Rejected findings go in the PR body with the reason.
9. Finish the PR body: what was built, the proof from step 6, the decisions section. Mark the PR ready.
10. Watch CI. On a failure, read the log, hand it to one implementer, push, and watch again. Three rounds at most, then stop and report the failing job.
11. With `merge when green`, merge (the flag covers the deploy that merging triggers, nothing beyond it) and run the post-merge cleanup from `~/.claude/rules/git-workflow.md`. Without it, remove the implementer worktrees and their merged branches (`git branch -d`, never `-D`) and leave the PR for the user.

## Deciding without the user

A question a ticket leaves open gets the answer that best fits the spec, `CONTEXT.md` and the ADRs, plus one line under `## Decisions made without you`: the question, the choice, and what changes if the user disagrees. Reversible choices never wait. (principles/never-block-on-the-human.md)

Stop and ask only before merging (unless `merge when green` was given), deploying, force-pushing or deleting data, or when a ticket contradicts the spec in a way that changes what gets built. A blocked ticket does not stop the run. Log it, finish every ticket that does not depend on it, and report it.

**Reply:** the PR link, status per ticket, the proof, the decisions made without you, anything blocked.
