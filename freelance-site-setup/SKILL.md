---
name: freelance-site-setup
description: Bootstrap a new freelance client website repo (usually a landing page) with the preferred stack — Next.js, Tailwind v4, shadcn/ui, Motion, NumberFlow, design tokens, and coding rules. Use when starting a new client site or landing page project, or when the user says "new client project", "set up a landing page", or "scaffold the site".
---

# Freelance Site Setup

Bootstrap a client website repo with the full preferred stack, ready to build.
Instructions only — run each step interactively and adapt to the client.

## Phase 0 — Gather project info (ask before scaffolding)

Ask the user (skip anything already stated):

1. **Project/client name** → becomes repo + directory name (kebab-case)
2. **Design input**: Figma file provided, or design-from-scratch?
3. **Sibling project to mirror?** — an existing client repo with the same
   architecture (e.g. `~/dev/work/freelance/ecolab`, `karcher`) is the single
   highest-value input: copy its decisions, pinned versions, configs, and
   documented gotchas instead of re-deriving them. Ask even if the user
   didn't mention one.
4. **Backend** — default is **Cloudflare** (Workers via OpenNext, D1
   database, R2 storage; Payload CMS runs in-app). Pick **Supabase** only
   when hosted Postgres/auth/realtime is a genuinely better fit. Deploys
   target Cloudflare either way.
5. **Site features** — ask as checkboxes (AskUserQuestion with
   `multiSelect: true`), never as an open-ended "anything beyond a landing
   page?" question. AskUserQuestion caps a question at 4 options, so split
   into two multiSelect questions:

   **Content & reach:**
   - [ ] **CMS** — client-editable content. Default **PayloadCMS 3**,
     self-hosted in-app (admin at `/admin`, storage per backend choice) —
     no hosted CMS unless the client explicitly demands one
   - [ ] **Forms** — contact form, newsletter signup, feedback (Resend, email setup)
   - [ ] **Internationalization (i18n)** — multi-language support
   - [ ] **Analytics** — tracking, conversion pixels (Vercel Analytics, Posthog)

   **Commerce & data:**
   - [ ] **E-commerce** — product catalog, shopping cart, checkout (Stripe for
     simple payments; MedusaJS if it's a full store — no Shopify)
   - [ ] **Authentication** — user login, profiles, gated content
   - [ ] **Database** — persistent data (D1 on the Cloudflare backend,
     Supabase Postgres otherwise)
   - [ ] **File uploads** — image/document storage (R2 on Cloudflare,
     Supabase Storage otherwise)

   Nothing selected = plain landing page. Selections affect install flags,
   Phase 2 planning, and which skills/tools to activate; record the chosen
   features (and the concrete service picked for each) in the project's
   `CLAUDE.md` during Phase 3.

## Phase 1 — Scaffold the repo (or audit an existing one)

Follow [SETUP.md](SETUP.md) top to bottom. Summary:

1. `create-next-app@latest` — always latest stable Next.js (TypeScript,
   Tailwind v4, App Router, **src dir ON**, **pnpm**). It generates
   `AGENTS.md` plus a `CLAUDE.md` pointer (`@AGENTS.md`) — keep that pattern.
2. **Verify the installed Next.js version's docs** in `node_modules/next/dist/docs/`
   before writing code — APIs may differ from training data
3. `shadcn init` — the CLI is **preset-based** now; `-b` selects the
   primitive library (`radix`|`base`|`aria`), NOT a base color. Default is
   **Base UI** (`base`) — custom triggers use the `render` prop, not
   `asChild`. Use `radix` only when mirroring a radix sibling project
   (e.g. ecolab/karcher). Then add the base components a landing page needs.
4. Install `motion` (Motion for React — the Framer Motion successor)
5. Install `@number-flow/react` (animated numbers for stats, counters, prices)
6. **Backend wiring** per Phase 0 (default Cloudflare + Payload) — see
   [SETUP.md § Backend](SETUP.md#5-backend). Mirror the sibling project's
   configs and pin Payload to its known-good version.
7. `git init`, first commit, create GitHub repo with `gh repo create`

**Existing project?** Run this phase as an audit rather than a scaffold:

- Next.js: installed version vs `npm view next version`; propose the upgrade
- Tailwind v4 present and CSS-first (`@theme` in globals, no legacy config)
- shadcn initialized (`components.json`) — `npx shadcn@latest info` to confirm
- `motion` installed; imports use `motion/react`, not `framer-motion`
- `@number-flow/react` installed if the design has animated stats/counters/prices
- **Features from Phase 0** — check each selected feature and verify dependencies:
  - **CMS**: CMS client library + env config present
  - **Forms**: form library (react-hook-form + zod) + email setup (Resend, SendGrid)
  - **E-commerce**: Stripe SDK for simple checkout; MedusaJS backend + storefront
    SDK for a full store (never Shopify) + cart state management
  - **Analytics**: tracking script/MCP installed + events configured
  - **i18n**: next-intl or similar + translation files set up
  - **Auth**: auth library (NextAuth, Clerk, Supabase Auth) + callbacks
  - **Database**: client library + migrations / schema (if required)
  - **File uploads**: upload handler + storage service config
- Companion skills & MCP table below — verify and install missing ones
- `CLAUDE.md` conventions present (Phase 3); add if missing

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

Copy the template from [CONVENTIONS.md](CONVENTIONS.md) into the new repo's
`AGENTS.md`, filling in the project-specific header. create-next-app already
generates `CLAUDE.md` as an `@AGENTS.md` pointer — keep the pointer, put all
content in `AGENTS.md` (append below the generated `nextjs-agent-rules`
block). This encodes:

- Clean CSS convention (tokens + utilities, no arbitrary-value soup)
- Component and file structure for landing pages
- Motion/animation rules (respect `prefers-reduced-motion`)

## Companion skills & MCP

Check each against the session's available-skills list (and `claude mcp list`
for MCPs) and install what's missing before the build starts — the build
assumes them, and substituting a different tool mid-project costs more than
the install.

| Dependency | Used for | Install if missing |
| --- | --- | --- |
| shadcn MCP | registry tools in every project | `claude mcp add shadcn --scope user -- npx -y shadcn@latest mcp` |
| **shadcn** skill | auto-triggers on shadcn work | `npx skills add shadcn/ui --skill shadcn -g` |
| **vercel-react-best-practices** | writing/refactoring React & Next.js code, data fetching, performance | `npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices -g` |
| **vercel-composition-patterns** | component API design: compound components, no boolean-prop soup | `npx skills add vercel-labs/agent-skills --skill vercel-composition-patterns -g` |
| **web-design-guidelines** | UI/accessibility audit before client handoff | `npx skills add vercel-labs/agent-skills --skill web-design-guidelines -g` |
| **web-animation-design** | *deciding* animations: easing, duration, when not to animate | `npx skills add vercel-labs/open-agents --skill web-animation-design` — project-level, run inside the repo (`-g` fails: PromptScript skills don't support global install) |
| **motion-react** | *implementing* animations in Motion (`motion/react`, exits, layout morphs, springs, drag) | local copy in `~/.claude/skills/motion-react` (animations.dev skill set, alongside `animate`) |

Timing rule when both animation skills apply: marketing sections (hero
entrances) may use longer 0.6–0.8s durations in motion-react; interactive
UI follows web-animation-design's under-300ms rule.

## Phase 4 — Verify

- `pnpm dev` starts clean, no console errors
- `pnpm build` passes (with Payload this MUST be `next build --webpack` —
  see SETUP.md § Backend)
- shadcn button renders, tokens apply
- **Fonts actually apply** — check computed `font-family` in the browser,
  don't trust the code. The `next/font` `variable:` names must match the
  `@theme` font mappings: create-next-app emits `--font-geist-sans`/`--font-geist-mono`
  while shadcn's theme maps `--font-sans`/`--font-mono`; the mismatch fails
  silently to the fallback stack.
- If a backend is wired: `/admin` responds, `pnpm typecheck` passes
- Commit: `chore: scaffold project with stack and conventions`

**Verification tooling:** use Claude Code's built-in `preview_*` tools
(snapshot, console logs, click/fill, resize) during the build — do NOT add a
Playwright MCP. If `preview_*` calls fail or time out, fall back to the
`agent-browser` CLI (snapshot + console + eval covers the same checks). Add
Playwright as a dev dependency (with checked-in tests) only when the project
justifies CI-run E2E: form-heavy or transactional sites, not simple landing
pages.

## Checklist (copy into first message of the project)

```
[ ] Phase 0: name, design input, sibling project, backend, features (checkbox)
[ ] Phase 1: scaffold + deps + backend wiring + git + GitHub repo
[ ] Phase 2: fonts (verified applying), tokens, type scale, Container
[ ] Phase 3: AGENTS.md conventions in repo (CLAUDE.md stays a pointer)
[ ] Phase 4: dev + build verified, committed
```
