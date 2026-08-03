---
name: tech-vocabulary
description: Precise technical vocabulary beyond design — git & shipping, React/Next.js, CSS/layout mechanics, backend & data (incl. Cloudflare KV/D1/R2/DO), testing & debugging, and working with AI agents. Use when a technical concept is described loosely and needs its proper name ("the thing where the page jumps when images load" → layout shift), when choosing between confusable near-synonyms (rebase vs merge, mock vs stub, re-render vs remount, padding vs margin vs gap, SSR vs SSG vs ISR), when the user reaches for a word they can't find, or when writing specs, commits, or prompts and vague phrasing should become exact terminology. For design/UI aesthetics terms (kerning, badge vs tag, easing), use the `vocabulary` skill instead.
---

# Technical Vocabulary

A reverse dictionary for the engineering half of the work — the companion to
the `vocabulary` skill (index.how design terms). Goal: go from a fuzzy
description to the precise term, and know the boundary between words that look
interchangeable but aren't.

## Source of truth

One file per domain, bundled next to this file. Load only the relevant one(s):

| File | Covers |
|---|---|
| `git-shipping.md` | Commits, branches, merge/rebase, PRs, landing code |
| `react-nextjs.md` | Rendering, RSC boundaries, state, hydration, bundling |
| `css-layout.md` | Box model, flex/grid sizing, stacking, overflow, CLS |
| `backend-data.md` | Migrations, transactions, races, caching, Cloudflare primitives |
| `testing-debugging.md` | Test kinds, doubles, flakiness, repro, root-causing |
| `ai-agents.md` | Contract language for directing Claude Code: scope, verification, context |

`terms-index.md` is a flat list of every term by domain, for fast scanning when
you don't yet know which word you're looking for.

## How to use it

**Reverse lookup ("what's the word for…?")** — the main job.

1. Read the loose description; it usually points at one domain (page jumps
   around → css-layout; "runs twice sometimes" → backend-data or
   testing-debugging).
2. Scan `terms-index.md` for candidates, then read the definition(s) in the
   domain file.
3. Answer with **the term**, its definition, and any contrasting term the
   definition names — teach the boundary, not just the word.

**Forward lookup ("what does X mean / am I using it right?")** — find the term,
give the definition, surface the nearest confusable neighbor.

**Disambiguation ("is this a mock or a stub?")** — quote both definitions and
state the distinguishing rule in one line.

**Precise usage in review** — when reviewing prompts, specs, commits, or PR
descriptions, swap vague phrasing for the exact term where one exists ("make
sure it can't run twice" → "make it idempotent"). Don't force jargon where
plain language is clearer — precision is the goal, not density.

**Live translation** — when the user's ask uses a fuzzy phrase this vocabulary
can sharpen, restate it precisely in one line before acting ("reading 'the
page jumps' as: layout shift from unreserved image space"), then proceed. One
line, not a lecture.

## Near-synonyms worth disambiguating

Name the distinction proactively when a request touches one of these:

- **Merge vs rebase** — tie histories together vs replay commits on a new base;
  never rebase what's already shared.
- **Revert vs reset** — new commit that undoes (safe, shared-friendly) vs
  moving the branch pointer backwards (rewrites).
- **Re-render vs remount** — function re-runs, state survives vs component
  destroyed and recreated, state resets.
- **Server Component vs Client Component** — no JS shipped, no interactivity vs
  bundled and interactive; the `"use client"` line is a *boundary*, not a flag.
- **SSR vs SSG vs ISR** — per-request vs at build vs stale-while-revalidate
  pages. The question is "how stale can this be?"
- **Padding vs margin vs gap** — inside the border vs outside it vs between
  siblings (owned by the container).
- **min-content vs max-content** — narrowest without overflow vs width if
  nothing wrapped.
- **Mock vs stub vs spy vs fake** — asserts calls vs canned answers vs records
  real calls vs working lightweight substitute.
- **Unit vs integration vs e2e** — one piece vs pieces together vs the app as a
  user drives it.
- **Root cause vs symptom** — the decision that was wrong vs the crash it
  eventually caused; fixes aimed at symptoms come back.
- **Idempotent vs atomic** — safe to run twice vs all-or-nothing. Retries need
  the first; invariants need the second.
- **Optimistic vs pessimistic** — detect conflicts at write time vs lock first.
- **Acceptance criteria vs non-goals** — what done looks like vs what must not
  be touched. Every substantial prompt benefits from both.
- **Spike vs feature** — throwaway code answering a question vs code that
  ships. Naming it licenses the shortcut and forbids shipping it.
- **Compaction vs checkpoint** — summarizing the *conversation* vs saving the
  *work* (commit + resume note). Do the second before the first.

## Examples

**Reverse lookup**

> User: "what do you call it when the test passes alone but fails when the
> whole suite runs?"

Read testing-debugging.md. Answer:

> That's a **flaky test** — more precisely, **order-dependence** through shared
> state: some earlier test leaves state behind that yours inherits. Distinct
> from timing flakiness (races, real network), which fails randomly even alone.

**Live translation**

> User: "make sure the import script can't mess things up if i run it twice"

> Making the import **idempotent** — re-running it will detect already-imported
> rows (upsert on natural key) instead of duplicating them.

**Precise usage in prompts**

> User draft: "build the export feature but don't go overboard"

> Sharper contract: "build CSV export. **Acceptance criteria:** exports current
> filter set, handles 10k rows, mn/en headers. **Non-goals:** no PDF, no
> scheduling, **minimal diff** elsewhere."

## Guidelines

- Quote definitions from the domain files rather than paraphrasing.
- Always surface the contrasting term when one exists — the value is in the
  boundaries.
- Don't invent terms. If nothing listed fits, say so and describe the concept
  plainly.
- Design/UI aesthetics (kerning, badge vs tag, ease-out) belong to the
  `vocabulary` skill — hand off rather than duplicate.
- These files are living documents: when a real correction round reveals a
  missing term, add it to the right domain file (keep the one-entry format:
  **Term** — definition with a decision rule).
