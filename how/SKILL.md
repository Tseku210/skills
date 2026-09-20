---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, placement / ownership / layering questions (\"where should this live\", \"is this the right layer\"), and \"why is it built this way\" history questions. Explains subsystem architecture, runtime flow, onboarding mental models, and cited design history."
---

# How

Explore the codebase to answer "how does X work?" questions. Produce clear architectural explanations at the level of a senior engineer onboarding onto a subsystem. Enough to build a working mental model, not annotated source code.

Two modes:

1. **Explain** (default). Explore the codebase and produce a clear explanation.
2. **History.** For "why was it built this way", "why did we pick X over Y", "what's the story behind this". Dig through git, PRs, and local docs, and answer with citations and calibrated confidence.

Both modes are read-only. Nothing here edits the repo.

## Explain mode

### Step 1. Understand the question and assess complexity

Parse what the user is asking about:

- "How does the location endpoint work?", a subsystem
- "How do we handle bilingual content?", a feature flow
- "How is the Payload config structured?", an architectural overview
- "Walk me through what happens when a user submits the form", a runtime trace

Identify the scope. If ambiguous, state your best-guess interpretation before exploring. Don't ask. Let the user redirect if you're off.

Assess complexity to decide the approach:

- **Simple** (a single module, a small utility, "how does function X work"): no subagents. Explore and explain yourself in one pass. Go to Step 2b.
- **Complex** (a subsystem spanning multiple files or services, a cross-cutting feature, a full architectural overview): spawn parallel explorers first, then hand off to an explainer. Go to Step 2a.

When in doubt, lean simple. You can always spawn explorers if you hit a wall.

### Step 2a. Explore (complex questions only)

Decompose the question into 2-4 parallel exploration angles, each a distinct slice of the subsystem so explorers don't duplicate work. Example split for "how does the shop checkout work?":

- Explorer 1: data model and Payload collections
- Explorer 2: request path from cart to payment callback
- Explorer 3: i18n, pricing, and formatting

Narrow questions: 2 explorers. Broad subsystems: up to 4. Never more; every runner lands on this laptop.

Spawn all explorers in a single message with the Agent tool, `subagent_type: "Explore"`. Each explorer gets the base prompt from `references/explorer-prompt.md` plus its exploration angle. Each explorer should:

- Start broad: Glob for relevant directories, Grep for key types, interfaces, class names
- Follow the thread from an entry point: callers, callees, data flow, type definitions
- Read the actual code, don't guess from file names
- Stop when it can describe the full path from input to output without hand-waving any step
- Note things that are surprising, non-obvious, or that a newcomer would get wrong

Each explorer returns structured findings. Overlap is fine; the explainer reconciles.

### Step 2b. Direct explain (simple questions)

Explore with Glob, Grep, and Read, then write the explanation yourself. Read `references/explainer-prompt.md` for the communication style and output format. Same structure, no explorer findings as input. Proceed to Step 4.

### Step 3. Synthesize (complex questions only)

Once all explorers return, spawn one `general-purpose` subagent with the prompt in `references/explainer-prompt.md`, the explorers' findings, and the original question. It reconciles overlapping findings, resolves contradictions by checking the code, and weaves the slices into one picture.

### Step 4. Present

Present the explanation. You may lightly edit for clarity or add context from the conversation, but don't substantially rewrite. When the user asked for a visual, or the flow has three or more moving parts, hand the finished explanation to `show-me` to render it as an artifact. Build diagrams up one part at a time, not one crowded diagram at the end.

### Output format

Follow this structure, adapted to the question. Not every section is needed for every question.

**Overview.** 1-2 paragraphs. What it is, what it does, why it exists. Enough to decide whether to keep reading.

**Key concepts.** The important types, services, or abstractions. Brief definition of each. Not exhaustive, just the ones needed to understand the rest.

**How it works.** The core of the explanation. Walk through the flow: what triggers it, what happens step by step, where data goes, the decision points. Prose, not pseudocode. Reference specific files and functions so the reader can go look, but don't dump code blocks unless a snippet is genuinely necessary.

**Where things live.** A brief map of the relevant files and directories. Not every file, just the ones needed to start working in this area.

**Gotchas.** Non-obvious or surprising things that would trip someone up. Historical context that explains why something looks weird. Known sharp edges.

## History mode

Triggered by "why is it built this way", "why did we choose X", "what's the history of this", or a postmortem question. Not for "why is this broken", which is Explain mode or `diagnosing-bugs`.

The code tells you what it does, rarely why it exists. Don't infer intent from code shape. Go to the record.

### Sources

Two sources exist on this machine. Search both, in this order, and report a null result from either as a finding.

1. **Source control.** Blame the target lines, follow the file history through renames, read the PR bodies and review threads, and read test names, which encode the motivating edge cases.

   ```bash
   git blame -L <start>,<end> <file>
   git log --follow --oneline -- <file>
   git log -1 --format=%B <commit>
   gh pr view <number> --json title,body,author,createdAt,comments,reviews
   ```

2. **Local docs.** Grep the repo for ADRs (`docs/adr`, `docs/decisions`), `RESUME.md`, `CONTEXT.md`, `plans/`, `CLAUDE.md`, and `AGENTS.md`. These hold decisions that never made it into a PR body.

For a narrow question, do this yourself. For a broad sweep, spawn one `Explore` subagent per source, in a single message, and synthesize.

### Rules of evidence

- **Cite everything.** Every claim about intent references a commit hash, PR number, doc path, or code comment with `file:line`. A claim you can't cite is inference and is labeled as such.
- **Prefer "appears to" over "because".** Reserve confident language for direct, explicit evidence.
- **Surface contradictions.** If two sources disagree, show both.
- **Name the gaps.** If neither source answers the question, say so. "We couldn't find out why" beats a confident guess.
- **Multiple hypotheses are valid.** When the evidence fits several stories, present them all with the evidence for each.
- **Beware rationalization.** Code that makes sense today may have been written for reasons that no longer apply. Don't retrofit intent.
- **Don't confirm the user's guess.** If they suggest a reason, treat it as a hypothesis and check it against the record.

### Output format

**The question.** Restated, concisely.

**The code in question.** File paths, line ranges, key symbols.

**What we found.** Direct evidence only, each bullet cited.

**What we can reasonably infer.** Indirect evidence with the inference chain spelled out. Hedged language.

**Competing hypotheses.** Only when the evidence fits more than one story.

**What we don't know.** Specific gaps and searches that came back empty.

**Sources consulted.** One line per source: what was searched, what was found or "no relevant results".

If the question is a precursor to changing the code, end with a Preserve / Change / Avoid / Risk list for the change.
