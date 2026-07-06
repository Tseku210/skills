---
name: freelance-site-setup
description: Bootstrap a new freelance client website repo (usually a landing page) with the preferred stack — Next.js, Tailwind v4, shadcn/ui, Motion, design tokens, and coding rules. Use when starting a new client site or landing page project, or when the user says "new client project", "set up a landing page", or "scaffold the site".
---

# Freelance Site Setup

Bootstrap a client website repo with the full preferred stack, ready to build.
Instructions only — run each step interactively and adapt to the client.

## Phase 0 — Gather project info (ask before scaffolding)

Ask the user (skip anything already stated):

1. **Project/client name** → becomes repo + directory name (kebab-case)
2. **Design input**: Figma file provided, or design-from-scratch?
3. **Anything beyond a landing page?** (CMS, forms, i18n, payments) — affects scaffold flags

## Phase 1 — Scaffold the repo

Follow [SETUP.md](SETUP.md) top to bottom. Summary:

1. `create-next-app@latest` — always latest stable Next.js (TypeScript,
   Tailwind v4, App Router, src dir off)
2. **Verify the installed Next.js version's docs** in `node_modules/next/dist/docs/`
   before writing code — APIs may differ from training data
3. `shadcn init` + the base components a landing page needs
4. Install `motion` (Motion for React — the Framer Motion successor)
5. `git init`, first commit, create GitHub repo with `gh repo create`

## Phase 2 — Design system

Set up tokens BEFORE building sections, per [SETUP.md § Design system](SETUP.md#design-system):

- Fonts via `next/font` with CSS variables
- Color/spacing/radius tokens in `globals.css` under `@theme`
- Type scale defined once in `@theme`, derived from the design — no
  arbitrary-value font sizes scattered across components
- One container/gutter convention defined once and reused by every section

**Design input paths:**

- **Figma provided** → pull tokens first: use the Figma MCP (`get_variable_defs`,
  `get_design_context`) to extract colors/type/spacing into `@theme` before
  implementing any section
- **No design** → design phase first: gather 2–3 reference sites from the client,
  define a style guide (palette, type pairing, spacing rhythm), get client sign-off
  on a hero mockup before building the rest

## Phase 3 — Coding rules

Copy the template from [CONVENTIONS.md](CONVENTIONS.md) into the new repo as
`CLAUDE.md`, filling in the project-specific header. This encodes:

- Clean CSS convention (tokens + utilities, no arbitrary-value soup)
- Component and file structure for landing pages
- Motion/animation rules (respect `prefers-reduced-motion`)

## Companion skills & MCP (verify, and INSTALL anything missing)

Never assume these are installed. Check each against the session's
available-skills list (and `claude mcp list` for MCPs). Anything missing MUST
be installed before the build starts — do not skip or substitute.

| Dependency | Used for | Install if missing |
| --- | --- | --- |
| shadcn MCP | registry tools in every project | `claude mcp add shadcn --scope user -- npx -y shadcn@latest mcp` |
| **shadcn** skill | auto-triggers on shadcn work | `npx skills add shadcn/ui --skill shadcn -g` |
| **vercel-react-best-practices** | writing/refactoring React & Next.js code, data fetching, performance | `npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices -g` |
| **vercel-composition-patterns** | component API design: compound components, no boolean-prop soup | `npx skills add vercel-labs/agent-skills --skill vercel-composition-patterns -g` |
| **web-design-guidelines** | UI/accessibility audit before client handoff | `npx skills add vercel-labs/agent-skills --skill web-design-guidelines -g` |
| **web-animation-design** | *deciding* animations: easing, duration, when not to animate | `npx skills add vercel-labs/open-agents --skill web-animation-design -g` |
| **motion-animation** | *implementing* animations in Motion (`motion/react`, scroll reveals, springs) | personal repo: `git clone git@github.com:Tseku210/skills.git ~/dev/personal/my-skills && ~/dev/personal/my-skills/link.sh` |

Timing rule when both animation skills apply: marketing sections (hero
entrances) may use motion-animation's longer 0.6–0.8s durations; interactive
UI follows web-animation-design's under-300ms rule.

## Phase 4 — Verify

- `npm run dev` starts clean, no console errors
- `npm run build` passes
- shadcn button renders, fonts load, tokens apply
- Commit: `chore: scaffold project with stack and conventions`

**Verification tooling:** use Claude Code's built-in `preview_*` tools
(snapshot, console logs, click/fill, resize) during the build — do NOT add a
Playwright MCP. Add Playwright as a dev dependency (with checked-in tests)
only when the project justifies CI-run E2E: form-heavy or transactional
sites, not simple landing pages.

## Checklist (copy into first message of the project)

```
[ ] Phase 0: name, design input, scope confirmed
[ ] Phase 1: scaffold + deps + git + GitHub repo
[ ] Phase 2: fonts, tokens, fluid type, container-page
[ ] Phase 3: CLAUDE.md conventions in repo
[ ] Phase 4: dev + build verified, committed
```
