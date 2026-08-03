# Coding Rules Template

Copy everything below the line into the new repo's `AGENTS.md` (append below
the generated `nextjs-agent-rules` block — create-next-app makes `CLAUDE.md`
an `@AGENTS.md` pointer; keep it that way), then fill in the bracketed
header fields and delete lines that don't apply to the project.

---

# [Client Name] — [Landing Page / Site]

Stack: Next.js (App Router) + Tailwind v4 + shadcn/ui (base) + Motion.
[If backend in scope: + Payload CMS 3 + next-intl, deployed to Cloudflare
Workers via OpenNext (D1 database, R2 media). Architecture mirrors
`[sibling project path]` — when in doubt, check how it solved it.]
Keep Next.js on the latest stable when possible (upgrade via
`npx @next/codemod@latest upgrade latest`). Check
`node_modules/next/dist/docs/` before using an API you haven't verified in
the installed version.

When writing frontend code, load the Vercel Labs skills. Don't assume they're
installed — check the skills list, and install any missing one via
`npx skills add vercel-labs/agent-skills --skill <name> -g` before continuing:

- `vercel-react-best-practices` — when writing/refactoring React or Next.js code
- `vercel-composition-patterns` — when designing component APIs
- `web-design-guidelines` — when reviewing UI before handoff

## CSS conventions

- **Tokens over raw values.** Colors, radii, and type sizes come from `@theme`
  tokens in the global stylesheet, named traceably to the Figma variables
  (original Figma name in a comment next to each value). Never hardcode hex
  values or arbitrary font sizes in components.
- **No arbitrary-value soup.** `text-[4.2rem]`, `px-[13px]`, `mt-[7px]` are
  code smells. If a value is needed twice, it's a token; if once, question it.
- **Headings use the project's type tokens.** The scale is defined once in
  `@theme` (fluid `clamp()` or responsive variants — whichever matches the
  design), never ad-hoc sizes per section.
- **One container convention owns page gutters and max-width:** the
  `Container` component (`max-w` = Figma content width + 2×gutter), used by
  every section. Full-bleed backgrounds on the outer wrapper, `Container`
  on an inner div. No per-section bespoke padding.
- **The page owns vertical rhythm, not the sections.** Pages compose
  sections inside one `flex flex-col gap-*` wrapper; sections carry zero
  outer `py-*` (colored bands pad internally). Never add margin/padding to
  a section to space it from a neighbor.
- **Layout by ratios, not pixels.** `flex-1` / grid fractions, not
  design-tool pixel widths (exception: Figma content max-widths in
  `Container`).

## Component structure

- One file per landing section in `src/components/home/`; layout chrome
  (Header, Footer) in `src/components/layout/`; per-page folders as pages
  appear
- Shared primitives live in `src/components/ui/` (shadcn-managed, Base UI
  primitives — custom triggers use the `render` prop, not `asChild`; edit
  freely, they're owned code, but keep the shadcn structure. If the project
  mirrors a radix sibling, flip this line to radix/`asChild`)
- Server Components by default; add `"use client"` only where interaction
  or Motion requires it, at the leaf, not the page

## Motion rules

- Import from `motion/react`, never `framer-motion`
- Easing/duration tokens live twice, mirrored: CSS `--ease-*` overrides in
  `@theme` and `src/lib/motion.ts` (tuples + `DURATION` map) — keep the two
  in sync
- Entrances go through the shared `Reveal` component (`whileInView`,
  `viewport={{ once: true }}`) — no per-section ad-hoc `motion.div`s;
  sections don't re-animate on scroll-back
- Every animation respects `useReducedMotion()` — reduced users get opacity
  fades or nothing, not transforms
- Animate `transform` and `opacity` only; never layout properties

## Number animation

- Animate numbers (stat counters, prices, percentages) with `NumberFlow` from
  `@number-flow/react` — never hand-roll a tween or count-up loop
- It's a client component: `"use client"` at the leaf, not the page
- Pass raw numbers to `value` and format via the `format`/`locales` props
  (`Intl.NumberFormat` options) — don't pre-format the string
- Drive `value` from state; trigger count-ups with `whileInView`/`useInView` so
  they run once on scroll. `NumberFlow` already respects
  `prefers-reduced-motion`, so no extra guard is needed
- Group related figures in `NumberFlowGroup` to keep their digit timings in sync

## Content & SEO baseline

- `metadata` export on every page: title, description, OpenGraph
- One `h1` per page; sections use `h2`
- All images through `next/image` with real `alt` text
- Favicon + OG image before launch, not after

## Definition of done (per section)

- Renders correctly at 375px, 768px, 1280px
- No console errors or hydration warnings
- Lighthouse performance ≥ 90 on the page it lives in
