---
name: recall
description: "Reconstruct your recent working context from your own Claude Code session history, live git/gh state, and the repo's shared record (PRs, issues, docs), then hand back a tight current-state brief. Use for 'recall my work on X', 'catch me up', 'what have I been working on', 'where did I leave off', 'what did we decide about X', before starting or resuming work."
disable-model-invocation: true
---

# Recall

**Before you start or resume work, you rebuild the user's recent working context and hand back a tight capsule of where things stand now and what to do next.** Use for "recall my work on X", "catch me up", "what have I been working on", "what did we decide about X", or "where did I leave off".

Keep it tight and on-topic. Read only what the in-scope threads need, then stop. The heavy reading fans out to parallel subagents. The main thread keeps only their findings and the final brief.

Your context lives in two records. Your own session history holds what you did and decided. The shared record holds everything that happened around the same code under other names: the PRs that merged and reverted, the issues still open, the decisions written into docs and CLAUDE.md. That second record is what the `how` skill's History mode searches, across git, `gh`, and local docs. A feature with a long bug tail keeps most of its story there, so don't reconstruct it from your transcripts alone.

## Where transcripts live

`~/.claude/projects/<slug>/`, where `<slug>` is the workspace path with every `/` turned into `-`, leading slash included (`/Users/you/proj` becomes `-Users-you-proj`).

```
<slug>/<session-id>.jsonl                       one main conversation per file
<slug>/<session-id>/subagents/agent-<id>.jsonl  that session's subagents
<slug>/<session-id>/tool-results/*.txt          oversized tool outputs
```

Every line is one JSON object with `type` (`user`, `assistant`, `system`, plus housekeeping types to skip), `timestamp` (ISO), `cwd`, `gitBranch`, and `message` (`role` plus `content`, a string or a list of blocks). Order sessions by file mtime (`ls -t`), never by UUID. The current session's id is the UUID segment of the scratchpad path in the system prompt; skip it. Skip `subagents/` files unless a finding hinges on what a subagent actually ran.

1. Classify, then route. Resuming one specific prior chat is `claude --resume`, or the repo's RESUME.md written by the `checkpoint` skill, not this. A human-readable summary of your work is a different task. Recall loads working context across recent chats before you act. If the user already gave you a full state capsule (paths, branch, the change), use it and skip the mining.
2. Lock the scope before searching. Pin the window ("recent" is a real range, default the last 7 days by file mtime), the topic if named, and the workspace (default the active one; never read another project's transcripts without being asked). State the scope back. Never quietly turn "all" into "recent N".
3. Fan out across your session history. Spawn parallel `Explore` subagents, each taking a slice of the corpus, at most three at once; searching transcripts is grunt work and the laptop runs the workers. Tell every subagent to order candidates by mtime, grep the topic first and then read only the matching sessions and only their relevant regions, and skip the current session plus obvious noise (subagent files, housekeeping line types). Each returns the same schema, one block per session: topic, the user's goal, decisions, open threads, struggles and corrections, and artifacts (PRs, branches, files), each citing the session id. For one or two sessions, skip the fan-out and search directly. The raw transcripts stay in the subagents. The main thread gets only their findings.
4. Sweep the shared record whenever the topic names a feature, file, subsystem, area, or bug. This is the default, not a judgment call, and "my work on X" does not exempt it. A named target carries history you never see in your own transcripts, and that history is the point of the sweep. Run the `how` History mode source investigators (git log and blame, `gh pr list` and `gh issue list` with `--search`, local docs and CLAUDE.md), but steer their question from "why was this built this way" to "what's the current state, what's been tried and didn't hold, and what is still open". Run them in parallel with the history mining and inherit its posture: one investigator per source, null results are findings, an unavailable source is skipped and named. Fold what comes back into the brief. Skip this step only for pure activity recall with no named target ("what did I do this week"), where your own history and live state are the entire answer.
5. Verify against live state. A transcript is history, not current truth, so take the PRs, branches, and files that the mining and the sweep surfaced and check them with `git` and `gh`. When the answer hinges on what an agent actually did (the tools it ran, files it read, errors it hit), read the full transcript, not just a summary line.
6. Write the brief to the contract below. Group by thread. Stay on the named topic.

## Output contract

Lead with the capsule, then the thread status, then the problems, then the next move. Deeper detail goes below or gets cut.

- **Capsule.** At most 5 bullets. What this work is and where it stands overall.
- **Threads.** One line each, prefixed with exactly one status tag: `[merged #N]`, `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`, `[reverted #N]`, or `[planned, not started]`. A thread with no tag is not done yet, so tag it.
- **Problems.** At most 5, the recurring ones. Include any fix that shipped and was reverted, so the next attempt starts where the last one failed.
- **Next move.** The single most useful next action, concrete.

An adjacent feature or ticket stays out unless it blocks this one. When the capsule and thread lines outgrow a screen, cut detail before you cut threads. Write the brief through the `unslop` skill, cite session findings by session id and shared-record findings by their source (PR #, issue #, file path), and sanitize private context before any public output.

**Reply:** the brief, to the contract above.
