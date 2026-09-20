---
name: reflect
description: Spawn three parallel review subagents over the current session's transcript, surface durable learnings, and route each to a concrete edit on an existing skill, rules file, or CLAUDE.md. Use when the user says reflect.
disable-model-invocation: true
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

## When to invoke

- The user said "reflect" or "/reflect".
- A complex task (5+ tool calls) just landed cleanly and the recipe is worth keeping.
- The agent hit dead ends, found the working path, and the path generalizes.
- The user corrected the agent's approach mid-task.
- A non-trivial workflow emerged that isn't captured anywhere.

Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## Process

### 1. Locate the active transcript

Transcripts live under `~/.claude/projects/<slug>/`, where `<slug>` is the working directory with every `/` turned into `-`, leading slash included (`/Users/you/proj` becomes `-Users-you-proj`). The session id is the UUID segment of this session's scratchpad path, named in the system prompt (`.../<slug>/<session-id>/scratchpad`).

```
~/.claude/projects/<slug>/<session-id>.jsonl                      this conversation
~/.claude/projects/<slug>/<session-id>/subagents/agent-<id>.jsonl  each subagent it spawned
~/.claude/projects/<slug>/<session-id>/tool-results/*.txt          tool outputs too large to inline
```

Read only this project's directory. Do not glob across `~/.claude/projects/*/`. That crosses workspace boundaries and reads private chats from unrelated projects.

Confirm the file: the first line whose `type` is `user` carries the conversation's opening prompt in `message.content` (a string, or a list of blocks with a `text` field). Lines also carry `timestamp`, `cwd`, and `gitBranch`. If no path resolves, write a tight digest of the session and pass that instead.

### 2. Spawn three reviewers in parallel

One message, three `Agent` calls, `subagent_type: general-purpose`. They run on Opus; do not set a model. The prompt forbids file writes; the parent applies edits. Reviewers keep their MCP tools so they can look up context the transcript references (a GitHub PR through `gh`, a Cloudflare log, a Figma frame).

| Lens | Prompt template |
|---|---|
| Judgment | `references/judgment-reviewer.md` |
| Tooling | `references/tooling-reviewer.md` |
| Divergent | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings in the `Agent` response body.

### 3. Synthesize

One `Agent` call, `subagent_type: general-purpose`, using `references/synthesizer.md` verbatim with each reviewer's full output inlined where marked. The synthesizer spot-verifies citations, so it keeps its tools too. It returns a structured Accepted / Rejected / Backlog list.

### 4. Structural enforcement check

Sanity-check the synthesizer's Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. The synthesizer already applies this criterion; this is a final pass before edits land.

### 5. Apply

Before applying any Accepted edit, present the synthesizer's full Accepted / Rejected / Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. A skill edit changes every future session; do not auto-apply.

Backlog items append to `~/dev/personal/my-skills/BACKLOG.md` automatically, one bullet each with the pattern, what was hit, and the suggested mechanism. Those are notes, not skill edits. Only the Accepted list waits for approval.

Edit sources, never symlinks. A skill under `~/.claude/skills/<name>` is a symlink into `~/dev/personal/my-skills/<name>`; edit the repo copy. Plugin skills under `~/.claude/plugins/` are not yours to edit; a finding that routes there becomes a note in the relevant rules file or CLAUDE.md instead.

For each approved Accepted item, follow the Routing field exactly:

- Trivial edit (a one-line bullet, a tightened sentence, a stale fact corrected) to a skill, a `~/.claude/rules/*.md` file, or a project CLAUDE.md / AGENTS.md: parent does directly.
- Substantive skill edit (a new section, a new pattern table, more than ~10 lines): run the `write-a-skill` skill's draft / test / iterate loop against the existing skill.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): rewrite the `description` line so it front-loads the trigger phrases, then check it against the transcript moment that should have fired it.
- `new skill via write-a-skill: <kebab-name>`: hand creation to `write-a-skill`, in `~/dev/personal/my-skills/<kebab-name>/`, then run `./link.sh`. Do not invent the shape ad hoc.

Nothing here commits. Leave the repo dirty for the user to review.

### 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<path>`. What changed, one line each.
- New skills created: `<path>`. One line each (rare).
- Backlog appended: `<title>`. One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
