# Coding Rules Template

Copy everything below the line into the new repo as `CLAUDE.md`, then fill in
the bracketed header fields.

---

# [Client Name] — Landing Page

Stack: Next.js (App Router) + Tailwind v4 + shadcn/ui + Motion.
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
  tokens in `globals.css`. Never hardcode hex values or arbitrary font sizes
  in components.
- **No arbitrary-value soup.** `text-[4.2rem]`, `px-[13px]`, `mt-[7px]` are
  code smells. If a value is needed twice, it's a token; if once, question it.
- **Headings use the project's type tokens.** The scale is defined once in
  `@theme` (fluid `clamp()` or responsive variants — whichever matches the
  design), never ad-hoc sizes per section.
- **One container convention owns page gutters and max-width.** Defined once
  (custom utility or layout component), used by every section. Full-bleed
  backgrounds on the outer wrapper, container on an inner div. No
  per-section bespoke padding.
- **Layout by ratios, not pixels.** `flex-1` / grid fractions, not
  design-tool pixel widths.

## Component structure

- One file per landing-page section: `components/sections/hero.tsx`,
  `features.tsx`, `pricing.tsx`, `faq.tsx`, `cta.tsx`, `footer.tsx`
- Shared primitives live in `components/ui/` (shadcn-managed — edit freely,
  they're owned code, but keep the shadcn structure)
- Server Components by default; add `"use client"` only where interaction
  or Motion requires it, at the leaf, not the page

## Motion rules

- Import from `motion/react`, never `framer-motion`
- Every animation respects `useReducedMotion()` — reduced users get opacity
  fades or nothing, not transforms
- Entrances: `whileInView` with `viewport={{ once: true }}` — sections don't
  re-animate on scroll-back
- Animate `transform` and `opacity` only; never layout properties

## Content & SEO baseline

- `metadata` export on every page: title, description, OpenGraph
- One `h1` per page; sections use `h2`
- All images through `next/image` with real `alt` text
- Favicon + OG image before launch, not after

## Definition of done (per section)

- Renders correctly at 375px, 768px, 1280px
- No console errors or hydration warnings
- Lighthouse performance ≥ 90 on the page it lives in
