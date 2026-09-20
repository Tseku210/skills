---
name: js-toolchain-setup
description: Set up linting and formatting for a JS/TS repo with oxlint, the vendored anti-slop plugin, and oxfmt. Use when scaffolding a new JS/TS project or adding a linter or formatter to a repo that has none.
---

# JS/TS toolchain setup

Defaults for a new repo, or a repo with no linter: **oxlint** with the vendored
**anti-slop** plugin, **oxfmt** for formatting, `tsc --noEmit` as the type-checking
authority. Everything ends up in committed config, so it works on any machine and in
cloud sessions.

## Before changing anything

- Check `git status` and what the repo already runs. A repo on ESLint, Biome, or
  Prettier keeps it. Don't migrate existing config unasked; oxlint may run alongside
  ESLint if the user wants it.
- Identify the package manager from `packageManager` and the lockfile. Use it for
  every install and script below.

## 1. Lint: oxlint + anti-slop

1. Fetch the README of `github.com/dmmulroy/anti-slop` and follow its manual
   installation: copy `src/` to `tools/oxlint/anti-slop/`, install `oxlint` and
   `@oxlint/plugins` at the same exact version, register the plugin under `jsPlugins`
   in `oxlint.config.ts`. Take versions and the rule list from the README, not from
   memory. The vendored plugin is repo-owned code. Edit rules to fit the repo, never
   treat it as a dependency.
2. Sort rules into tiers by running oxlint once with every rule at `"error"`:
   - Zero violations: stays `"error"`.
   - Legacy violations: `"warn"`. Record the count and date in a header comment in
     the config. Burn down file by file and promote to `"error"` at zero. Never leave
     a rule at warn indefinitely, and never clear a backlog by disabling the rule.
3. Standing adjustments:
   - `no-shape-in-symbol-names`: `"off"`. It false-positives on the SVG DOM attribute
     `shapeRendering`, and the rest is naming taste.
   - Repos without a schema library: `no-runtime-typeof` with
     `{ "allowInTypeGuards": true }`.
4. Put the fixing guidance where the agent will read it, in the vendored rules' own
   `messages`:
   - `no-module-mocking`: append "Add a dependency seam (factory or parameter). Do
     not disable this rule."
   - `require-safety-comment-for-type-assertion`: append "A comment that restates
     the assertion does not count."

## 2. Format: oxfmt

- **Match the repo, don't impose defaults.** Measure the existing style first: quote
  style, semicolons, effective print width from line-length percentiles. Write
  `.oxfmtrc.json` to match. A formatter's first commit should re-wrap, never restyle.
- **Format hand-written code only.** `ignorePatterns` must exclude generated files
  (`*.gen.*`, `worker-configuration.d.ts`), vendored code, and any data or prose a
  build step or test parses: fixtures, content files, CSS that tests regex-match.
  Reformatting those breaks pipelines silently. Restrict formatting to JS/TS.

## 3. Gate

- Add scripts: `lint`, `fmt`, `fmt:check`, `typecheck` (`tsc --noEmit`).
- Add `lint`, `fmt:check`, and `typecheck` to the repo's aggregate check script and
  to CI.
- Document the commands in the repo's `CLAUDE.md` or `AGENTS.md`, with one line on
  the tiers: the error tier stays at zero, the warn tier is a backlog.

## 4. Verify

Run the aggregate check. Then add a deliberate violation, such as a `vi.mock(...)`
call, confirm `lint` fails and prints the edited message, and remove it.

## Fixing violations

Fix the design, not the diagnostic. `no-module-mocking` means add a real dependency
seam, not a lint-disable. `require-safety-comment` means state a real checked
invariant. A `SAFETY:` comment that restates the assertion is worse than the bare
assertion.

## Vite+

Applies only where Vite runs dev and build and Vitest runs tests. Next.js, Astro,
and anything whose own CLI owns dev and build: don't bolt it on.

- New Vite project: `vp create`. Existing: `vp migrate`, only when asked, since it is
  a repo-wide toolchain change.
- `vp` manages the global Node runtime and package manager by default. Never install
  `vp` or change that setting without explicit user sign-off.
- Under Vite+ the plugin and rules live in the config's `lint` key and run through
  `vp check`. `tsc --noEmit` stays the referee until the repo proves parity.
