---
name: create-verification-skill
description: "Generate a project-local verification skill that drives the real app the way a user does, so any agent can prove UI, CLI, API, or native-app behavior on demand. Use for /create-verification-skill, \"make a verify skill for this repo\", \"how do I test this\" when no scripted way exists, or when a repo's .claude/verify or .claude/skills has no verification recipe."
disable-model-invocation: true
---

# Create a verification skill

Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates that as a project-local skill at `.claude/skills/verify-<app>/`, tailored to the repo. You write the generator's output for the next agent, not for a human: it will be read cold, mid-task, by an agent that has never seen the app.

## Cost posture

This is on-demand proof, not a test suite. It never adds Playwright or Cypress to the repo, never wires anything into CI, and never runs more than one app instance at a time unless the repo already isolates them. It answers "how do I verify this change right now" in minutes, with evidence the user can look at. Heavy end-to-end suites have been removed from these repos for CPU cost more than once; don't put them back through the side door.

## 1. Interview the repo, not the user

Answer these from the codebase and only ask the user what you cannot observe:

- **Surface:** what does a user actually touch? A web UI, a CLI or TUI, a native macOS app, an API, a library? A repo can have several; pick the primary one and note the rest.
- **Run:** how does the app start locally? Prefer the repo's own documented dev command (package scripts, Makefile, README, CLAUDE.md). Note ports, env vars, seed data, auth. Read `CLAUDE.md` and `AGENTS.md` first; they usually already say how (`pnpm dev`, `dev:reset`, `wrangler dev`, `bun start`, `xcodebuild`).
- **Drive:** how can an agent interact with it programmatically? Existing harnesses first: scripts in `.claude/verify/`, Vitest integration tests, curl-able endpoints, a debug port. Only then pick a generic recipe:
  - Web UI: `agent-browser` (accessibility-tree snapshots with element refs; headless; isolated profile). Not Playwright.
  - CLI or TUI: a tmux session or PTY helper; for Bun and OpenTUI apps, the framework's headless test renderer.
  - HTTP API or Worker: `curl` against the local `wrangler dev` or `next dev` port; `wrangler d1 execute --local` to read state.
  - Native macOS app: `xcodebuild` to build, `xcrun` and the app's own CLI or AppleScript hooks to drive, screenshots via `screencapture`.
- **Observe:** what evidence can be captured? Screenshots, accessibility snapshots, terminal transcripts, response bodies, logs, exit codes, DB rows.
- **Isolate:** can two instances run side by side (ports, data dirs, `.wrangler` state)? If not, say so in the generated skill: refusing to double-drive a shared instance beats corrupting the user's session.

If the checkout doesn't build or start as-is, fix that first, or report it precisely, before generating; a skill written against a broken base teaches wrong steps. When an irrelevant missing asset blocks startup (a static dir the API never serves, a sample config), the generated skill may create it, clearly marked as verification scaffolding, and remove it in cleanup.

## 2. Generate the skill

Write `.claude/skills/verify-<app>/SKILL.md` with YAML frontmatter (`name: verify-<app>` and a `description` that names the app, the surface, and when to reach for it; without frontmatter the skill never registers) and these sections, each grounded in what the interview actually found. No placeholders left.

- **Launch:** the exact command that starts the app for verification, and how to tell it's ready (a log line, a port answering, a prompt). Include teardown. For a short-lived CLI or TUI there is no server to keep alive: launch means build the binary once, then start each drive in its own isolated PTY or tmux session.
- **Doctor:** one read-only check that answers "is this instance worth driving?": process up, right build, port owned by us, seed data present, auth valid. An agent runs this first whenever anything looks off. For the Next.js and Payload repos, doctor includes the stale-D1 symptom: a request taking 30s or more means run `dev:reset`, not debug the browser.
- **Drive:** the harness recipe with real selectors, routes, and commands from this repo, not examples. Prefer stable handles (ARIA roles and names, data attributes, prompt strings, route paths) over coordinates and tab order.
- **Evidence:** what to capture for a proof and where it goes (default `.claude/verify/evidence/<feature>/`, gitignored). State the proof standards: exercise the real user path, not internal setters or test-only endpoints; capture the action and the resulting state, not just the final screen; verify side effects (rows inserted, files written, KV keys set) alongside what's visible; mocks only where a production boundary already isolates the external system. For a bilingual app, drive both locales; the `mn` default is the one the client sees first.
- **Cleanup:** how to tear down instances the run created. Never kill by process name; kill what you started. Cleanup removes instances and scratch state, never the evidence: proof artifacts survive the teardown, in a location the skill names.
- **Helpers:** any script the skill ships is executable and its invocation is shown in the skill body. A helper the reader has to reverse-engineer is not a helper.

## 3. Seed the feature map

Create `.claude/skills/verify-<app>/features/README.md` plus one file per user-facing feature you can identify (the top 3-5 to start, from routes, commands, menus, or docs). Follow the shape in `references/feature-map-example/`: a README index and one file per feature. Each file answers, from the user's point of view: what the feature is, how to reach it, how to drive it with the harness, and what observable end state proves it works. The four H2s are `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. The map is the repo's maintained verification source; a proof that drives one convenient entry point is incomplete when the map lists others.

## 4. Prove the generated skill before handing it over

Run its own instructions end to end once: launch, doctor, drive ONE mapped feature, capture evidence, clean up. After cleanup, confirm the evidence still exists at the named location; a cleanup that eats the proof fails this step. Fix what fails, and run the generated cleanup after every failed iteration too, so broken attempts don't strand processes and ports. A generated skill that was never executed is a draft, not a deliverable.

## 5. Hand over

Tell the user the exact command or phrase that invokes the new skill, which feature was proven, where the evidence is, and point at `/maintain-verification-skill` for keeping the map honest as the app changes. Suggest a cadence only if they ask.
