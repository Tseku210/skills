# Setup Commands

Run from the parent directory where client projects live. Replace `client-site`
with the real project name everywhere.

## 1. Scaffold Next.js

```bash
npx create-next-app@latest client-site \
  --typescript --tailwind --app --no-src-dir --turbopack \
  --import-alias "@/*" --use-npm
cd client-site
```

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

```bash
npx shadcn@latest init
```

Answer prompts: default style, CSS variables = yes, base color per the design.

Base components for a typical landing page:

```bash
npx shadcn@latest add button card input textarea accordion navigation-menu sheet
```

Add more only when a section needs them — don't pre-install the whole registry.

## 3. Motion

```bash
npm install motion
```

Import from `motion/react` (NOT `framer-motion`):

```tsx
import { motion, useReducedMotion } from "motion/react"
```

## 4. Git + GitHub

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
instead of inventing them.

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
- **One container convention.** Decide page max-width + gutters once — as a
  custom `@utility` or a shared layout component — and reuse it in every
  section. Never copy-paste `mx-auto max-w-* px-*` wrappers. Full-bleed
  backgrounds go on the outer section, the container on an inner div.
- **Layout by ratios, not pixels.** Use `flex-1` / grid fractions instead of
  forcing design-tool pixel widths (`w-[602px]`) into CSS.
