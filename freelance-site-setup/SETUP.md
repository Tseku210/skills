# Setup Commands

Run from the parent directory where client projects live. Replace `client-site`
with the real project name everywhere.

## 1. Scaffold Next.js

```bash
npx create-next-app@latest client-site \
  --typescript --tailwind --app --src-dir --turbopack \
  --import-alias "@/*" --use-pnpm --eslint --yes
cd client-site
```

Notes:

- **src dir ON** — the Payload route groups (`(frontend)`/`(payload)`)
  assume `src/`, and both reference projects (ecolab, karcher) use it.
- **pnpm** is the house package manager. If the shell has a guard function
  that refuses pnpm while a `package-lock.json` exists, delete the lockfile
  first. Native deps need approval in `package.json`:
  `"pnpm": { "onlyBuiltDependencies": ["sharp", "esbuild", "unrs-resolver", "workerd"] }`.
- create-next-app generates `AGENTS.md` plus a `CLAUDE.md` pointer
  (`@AGENTS.md`) — keep the pointer, all conventions go in `AGENTS.md`.

**Always use the latest stable Next.js.** `create-next-app@latest` handles new
projects; when returning to an existing client project, check
`npm view next version` against the installed version and propose upgrading
(`npx @next/codemod@latest upgrade latest`) before building new features.

Then — before writing any code — check the installed version's docs (Next.js
ships them inside the package):

```bash
ls node_modules/next/dist/docs/
```

Read the routing/data-fetching guides for the version you actually got.
Do not assume training-data Next.js APIs; heed deprecation notices.

Optional: check whether any dependency ships TanStack Intent agent skills
(`npx @tanstack/intent@latest list`); if so, wire them with
`npx @tanstack/intent@latest install`. As of mid-2026 mostly TanStack's own
libraries — a complement to the docs check above, not a replacement.

## 2. shadcn/ui

The CLI is **preset-based** (shadcn 4.15+): `-b` selects the primitive
library (`radix` | `base` | `aria`) — it is NOT a base color anymore, and
the old style/base-color prompts are gone. Default is **Base UI** (`base`,
the CLI's own default): custom triggers use the `render` prop, not
`asChild` — don't mix the two APIs. Use `radix` (preset `radix-nova`) only
when mirroring a radix sibling project:

```bash
npx shadcn@latest init --preset base-nova
```

Preset colors don't matter — the real palette comes from Figma tokens in
Phase 2. This CLI changes fast: if flags error, check
`npx shadcn@latest init --help` before improvising.

Base components for a typical landing page:

```bash
pnpm dlx shadcn@latest add button card input textarea accordion navigation-menu sheet sonner
```

Add more only when a section needs them — don't pre-install the whole
registry. When re-adding into a project with customized components, decline
overwrites (`yes n | pnpm dlx shadcn@latest add …`) and review every added
file for theme collisions — the registry re-maps `--color-primary` /
`--color-muted` if allowed.

## 3. Motion

```bash
npm install motion
```

Import from `motion/react` (NOT `framer-motion`):

```tsx
import { motion, useReducedMotion } from "motion/react"
```

House motion structure (copy `Reveal.tsx` + `lib/motion.ts` from the newest
sibling project):

- Easing/duration tokens live **twice, mirrored**: CSS `--ease-*` overrides
  in `@theme` and a `src/lib/motion.ts` exporting the same curves as tuples
  plus a `DURATION` map — keep the two in sync (comment says so in both).
- All section entrances go through a shared `Reveal` component (fade + rise,
  `viewport={{ once: true }}`, reduced-motion drops the transform) — not
  per-section ad-hoc `motion.div`s.

## 4. NumberFlow

Animated numbers (stat counters, live prices, percentages) — used by
[barvian/number-flow](https://github.com/barvian/number-flow).

```bash
npm install @number-flow/react
```

`NumberFlow` is an interactive component, so it lives in a Client Component
(`"use client"` at the leaf, never the page). Default import, `value` prop:

```tsx
"use client"
import NumberFlow from "@number-flow/react"

<NumberFlow value={1240} />
```

Use the `format`/`locales` props (passed to `Intl.NumberFormat`) for currency,
percentages, or compact notation — don't pre-format the string yourself:

```tsx
<NumberFlow value={0.42} format={{ style: "percent" }} />
<NumberFlow value={4999} format={{ style: "currency", currency: "USD" }} locales="en-US" />
```

It respects `prefers-reduced-motion` out of the box (`respectMotionPreference`
defaults to `true`). Drive `value` from state — animation happens on change, so
pair it with a `whileInView`/`useInView` trigger for stats that count up on
scroll. Wrap related numbers in `NumberFlowGroup` to sync their timings.

## 5. Backend

Default: **Cloudflare + Payload**. Payload CMS 3 runs in-app on Cloudflare
Workers via OpenNext — D1 (database), R2 (media), admin at `/admin`. Choose
**Supabase** (hosted Postgres/auth/realtime) only when the project genuinely
needs those; deploys target Cloudflare either way — never a personal
Cloudflare account for client work.

**Mirror the newest sibling project** (`~/dev/work/freelance/karcher`,
`ecolab`) instead of wiring from scratch: copy `src/payload.config.ts`,
`src/app/(payload)/`, `wrangler.jsonc`, `open-next.config.ts`,
`src/lib/image-loader.ts`, and pin `payload` + every `@payloadcms/*` package
to the sibling's known-good version **in lockstep** (exact version, no
caret).

```bash
pnpm add payload @payloadcms/next @payloadcms/richtext-lexical \
  @payloadcms/db-d1-sqlite @payloadcms/storage-r2 @payloadcms/ui \
  graphql @opennextjs/cloudflare cross-env
pnpm add -D wrangler
```

Gotchas — all hard-won on ecolab/karcher, none optional:

- **Prod builds MUST use `next build --webpack`** — Turbopack production
  builds break Payload (payloadcms#16470). Dev on Turbopack is fine, but
  its cache can serve stale CSS after `@import` changes (`devsafe` script:
  `rm -rf .next` first).
- **`src/middleware.ts`, never Next 16's `proxy.ts`** — the OpenNext
  Cloudflare adapter only supports edge middleware.
- **`r2Storage` registers via `plugins:`, not `storage:`** — the `storage:`
  key is an unreleased API that crashes the admin on released 3.x.
- **Client account not set up yet?** Use placeholder D1/R2 ids and
  `"remote": false` on every binding in `wrangler.jsonc` — local dev runs
  fully offline via miniflare; flip to real ids + `remote: true` once the
  client's Cloudflare account exists.
- `PAYLOAD_SECRET` must exist in `.env` (generate: `openssl rand -hex 32`)
  or everything Payload-related 500s.
- After config changes: `pnpm payload generate:importmap` +
  `payload generate:types`; `wrangler types` for the env interface.
- i18n on Workers uses `next-intl` with `[locale]` routes under
  `(frontend)` — copy `src/i18n/` and the middleware matcher from the
  sibling.

## 6. Git + GitHub

```bash
git init && git add -A && git commit -m "chore: scaffold Next.js + Tailwind + shadcn + motion"
gh repo create client-site --private --source=. --push
```

## Design system

All of this goes in `app/globals.css` (Tailwind v4 is CSS-first config — use
`@theme`, there is no `tailwind.config.ts` unless you add one).

### Fonts

Load via `next/font` in `app/layout.tsx`, expose as CSS variables:

```tsx
const sans = Inter({ subsets: ["latin"], variable: "--font-sans" })
// <body className={`${sans.variable} font-sans`}>
```

Map in `@theme`:

```css
@theme {
  --font-sans: var(--font-sans), ui-sans-serif, system-ui, sans-serif;
}
```

Two traps:

- **The `variable:` name must match the `@theme` mapping.** create-next-app
  emits `--font-geist-sans`/`--font-geist-mono` while shadcn's generated
  theme maps `--font-sans`/`--font-mono` — the mismatch fails *silently* to
  the fallback stack. Always verify computed `font-family` in the browser.
- **Subsets must cover every script the copy uses** — e.g. add `cyrillic`
  for Mongolian, or the client's language renders in the fallback font.

### Tokens

Define brand colors, radius, and spacing rhythm as `@theme` tokens from the
start — components reference tokens, never raw hex values:

```css
@theme {
  --color-brand: oklch(0.55 0.2 260);
  --color-brand-foreground: oklch(0.98 0 0);
  --radius-card: 1rem;
}
```

If a Figma file exists, extract these with the Figma MCP (`get_variable_defs`)
instead of inventing them — and **name tokens traceably to the Figma
variables**, with the original Figma name in a comment next to each value
(`--color-primary: #fff100; /* "Primery" — brand yellow */`). Future
sessions can then map design ↔ code without re-opening Figma.

### Layout & type principles

Deliberately unopinionated — derive all concrete values (sizes, max-widths,
gutters) from the client's design, not from this skill. Whatever the design,
follow these practices:

- **Tokens over raw values.** If a size or color appears twice, promote it to
  an `@theme` token. Avoid arbitrary values (`text-[28px]`, `px-[73px]`) —
  they breed inconsistency and duplicated breakpoint variants.
- **Prefer Tailwind's standard scale** (4px grid: `pt-30`, `gap-12`, `h-100`)
  before reaching for custom values — these are real v4 utilities.
- **Define the type scale once.** Headings come from `@theme` type tokens.
  If the design scales headings continuously, use `clamp()`-based fluid
  tokens (anchor the min/max to the design's mobile and desktop artboards);
  if it uses fixed sizes per breakpoint, standard responsive variants are
  fine. Either way: one definition, no per-section ad-hoc sizes.
- **One container convention: a `Container` component**
  (`src/components/Container.tsx`), not a CSS utility — copy it from the
  newest sibling project. Pattern: `max-w` = Figma content width + 2×gutter
  (e.g. 1224px + 48 → `max-w-[1272px] px-6`), so desktop content is exactly
  the Figma width and the padding only bites below the max. Never copy-paste
  `mx-auto max-w-* px-*` wrappers. Full-bleed backgrounds go on the outer
  section, the `Container` on an inner div.
- **The page owns vertical rhythm, not the sections.** Pages compose
  sections inside one `flex flex-col gap-*` wrapper (with responsive gap
  steps); sections carry zero outer `py-*` — colored full-bleed bands pad
  internally. Never add margin/padding to a section to space it from a
  neighbor.
- **Layout by ratios, not pixels.** Use `flex-1` / grid fractions instead of
  forcing design-tool pixel widths (`w-[602px]`) into CSS. Exception: the
  Figma content max-widths inside `Container`.
