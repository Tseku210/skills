# Working-with-AI-Agents Vocabulary

*The contract language for directing Claude Code and similar agents. The highest-leverage words per character you can type.*

**Context window** — The agent's working memory: everything it can currently see. Finite; when it fills, something must be summarized away. Long sessions aren't free — they trade sharpness for history.

**Compaction** — Summarizing the conversation to reclaim context space. Lossy by nature: decisions survive, texture doesn't. A resume note written *before* compacting beats hoping the summary keeps what mattered.

**Checkpoint** — Commit + push + resume note, so the work (not just the chat) survives a context reset. The physical-world complement to compaction.

**Session** — One conversation with its own context. State that must outlive it goes in files, memory, or CLAUDE.md — "I told you last week" doesn't exist unless it was written down.

**CLAUDE.md / rules** — Standing instructions loaded into every session. The place for anything you've said twice; a preference repeated in chat is a preference you'll repeat forever.

**Memory** — The agent's persistent notes across sessions (distinct from CLAUDE.md, which you author). Good for durable facts: account IDs, decisions, gotchas.

**Skill** — A packaged workflow the agent loads when relevant or when you invoke it (`/checkpoint`). The difference between hoping the agent remembers your process and encoding it.

**Hook** — A script the *harness* runs on events (before a tool call, on stop). Deterministic where skills are advisory: a hook can block a dangerous git command; a skill can only recommend against it.

**Subagent** — A worker spawned with its own fresh context for a scoped task, returning only findings. Buys parallelism and keeps noise out of the main conversation — at the cost of tokens and of context the worker doesn't share.

**Worktree isolation** — Running an agent in a separate git checkout so parallel work can't trample your working copy. The safety prerequisite for letting agents edit while you also work.

**Plan mode** — The agent proposes an approach for approval before touching anything. Worth it when the task is ambiguous or expensive to redo; overhead when the task is mechanical.

**Effort / model tier** — How hard the model thinks, and which model does it. Vocabulary for cost control: "low effort," "use a small model for the mechanical parts" — said up front, not complained about after.

**Token budget** — Spend ceiling for a task ("keep this under 100k"). Makes "it's taking too much tokens why??" a constraint instead of a post-mortem.

**Prompt caching** — Reusing the processed conversation prefix within a time window. Why rapid follow-ups are cheap and a message after a long pause re-reads everything.

**One-shot vs iterative** — Full spec upfront, one deliverable — versus short steer-correct loops. One-shot when you can state acceptance criteria; iterative when you'll know it when you see it. Mismatched mode is the root of most frustration.

**Batching intent** — Packing sequencing into one prompt: "build X; when tests pass, checkpoint; then start Y; verify in browser before reporting done." Each pre-answered decision is a round-trip you don't wait on.

**Acceptance criteria** — The checkable list defining done, given *before* work starts. The single best antidote to "still not working" loops — it tells the agent what to verify itself.

**Non-goals** — Explicit out-of-scope: "don't touch mobile, don't refactor, ignore i18n for now." Agents fill silence with initiative; non-goals aim it.

**Minimal diff / surgical change** — Touch only what the task requires; match surrounding style; no drive-by refactors. Two words that replace a paragraph of scope-creep pushback.

**Spike** — Throwaway code to answer a question ("can Deepgram do streaming here?"). Naming it a spike licenses ugliness and forbids shipping it — evaluate the *answer*, not the code.

**Scope creep** — The delta between asked and delivered: extra features, bonus refactors, "improved" copy. In agents it's a default, not a character flaw — countered by non-goals and minimal-diff, stated upfront.

**Grounding** — Making the agent derive claims from checked sources (the actual file, the installed version's docs) instead of memory. "Read it before you cite it" — training data is a lower tier of evidence.

**Hallucination** — Confident output unbacked by anything: invented APIs, imagined file contents. Reduced by grounding and by asks that are *verifiable* — an agent that must run the code can't invent its output.

**Verify-before-done** — The agent must exercise the real flow (browser, curl, run it) before claiming completion. "Tests pass" is a lesser claim than "I drove it and watched it work" — say which one you require.

**Guardrail** — A hard limit that holds even if the agent errs: permission modes, blocked commands, protected branches. Guardrails are for *when* judgment fails; instructions are for guiding it.

**Handoff** — The context package one session (or agent) leaves the next: state, decisions, next step, verify commands. Written for a reader with zero shared memory — because that's literally the situation.

**Headless / background job** — An agent running without you watching, reporting when done. Changes the contract: it must guess-and-note instead of ask, and its result message is the whole interface.

**Autonomy level** — How much the agent does before checking in: every step / at decision points / only when blocked. Set it explicitly per task; the default is rarely what you meant either way.
