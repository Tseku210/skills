# React & Next.js Vocabulary

*How components render, where they run, and why they re-run.*

**Server Component vs Client Component** — Server Components run only on the server: no state, no handlers, no bundle cost. Client Components (`"use client"`) ship JavaScript and can be interactive. The default is server; client is the exception you opt into at the leaf.

**"use client" boundary** — The directive marks where the client bundle *starts* — everything it imports comes along. Putting it high in the tree drags the whole subtree into the bundle; that's why it belongs at the interactive leaf.

**Hydration** — The browser attaching event handlers and state to server-rendered HTML. Until it finishes, the page looks interactive but isn't.

**Hydration mismatch** — Server HTML and first client render disagree (dates, random values, `window` access), so React discards or patches the DOM. The console warning to never ignore — it usually means something renders differently per environment.

**Controlled vs uncontrolled** — A controlled input's value lives in React state (you own every keystroke); an uncontrolled one lives in the DOM and you read it when needed. Forms get messy when one input is secretly both.

**Derived state** — A value computable from existing state or props. Compute it during render instead of storing it — stored copies drift, and syncing them is where `useEffect` abuse starts.

**Lifting state** — Moving state to the nearest common ancestor of everyone who needs it. The cure for two siblings trying to agree; the disease, when overdone, is everything re-rendering from the top.

**Prop drilling** — Passing props through layers that don't use them, just to reach a deep child. Composition (passing components as children) usually fixes it before you need context.

**Context** — React's built-in broadcast: a provider makes a value available to any descendant. Every consumer re-renders when the value changes, so keep context values small and stable.

**Re-render vs remount** — Re-render re-runs the function and diffs; state survives. Remount destroys and recreates the component; state resets. A changed `key` forces a remount — which is also the trick for "reset this form."

**Key** — React's identity for list items across renders. Index-as-key breaks when the list reorders: state sticks to positions instead of items.

**Referential equality** — Objects and functions are "changed" if they're new instances, even with identical contents. Why an inline `{}` or arrow prop defeats `memo`, and what `useMemo`/`useCallback` actually stabilize.

**Stale closure** — A callback capturing old state because it closed over a previous render. The classic "counter increments once then sticks" bug; fixed with functional updates or correct dependencies.

**Effect vs event handler** — Handlers respond to user actions; effects synchronize with *external* systems (subscriptions, DOM APIs). "Do X when the user clicks" in an effect watching state is a handler wearing a disguise.

**Suspense boundary** — The point where a loading fallback appears while something below it fetches or lazy-loads. Placement is design: one high boundary = one big spinner; several low ones = staggered reveal.

**Streaming** — The server sends HTML in chunks as parts become ready, instead of waiting for the slowest data. Suspense boundaries define the chunks.

**SSR / SSG / ISR** — Rendered per-request / at build time / at build time but re-rendered in the background after a revalidation window. The question is always "how stale can this page be?"

**RSC payload** — The serialized Server Component output Next.js sends so the client can merge server-rendered parts with client components. Why navigation can update content without full page loads.

**Server action** — A function marked `"use server"` the client can call like RPC — form handling without hand-writing an API route. Still a network endpoint: validate input as if it were one.

**Route handler** — A file exporting `GET`/`POST` in `app/` — Next's API endpoint. For machines and webhooks; server actions are for your own forms.

**Middleware** — Code running before every matched request at the edge — redirects, auth walls, locale routing. Keep it thin: it runs on *everything* it matches.

**Layout vs page** — Layouts wrap and *persist* across navigation (state survives); pages swap. Put the expensive shared chrome in the layout, not repeated in every page.

**Waterfall** — Sequential fetches where each waits for the previous — often parent component fetches, then child fetches. Fixed by hoisting fetches and passing promises, or fetching in parallel with `Promise.all`.

**Optimistic update** — Showing the expected result immediately, reconciling when the server responds. Right for likes and carts; wrong when failure is common or costly to unwind.

**Code splitting / dynamic import** — Loading a chunk of JS only when needed (`next/dynamic`, `import()`). The lever when one heavy component (chart, editor) is dragging the whole page's bundle.

**Tree shaking** — The bundler dropping unimported code. Defeated by side-effectful modules and `import *` — why barrel files can silently bloat bundles.

**Memoization (`memo`/`useMemo`)** — Skipping recomputation when inputs are referentially equal. A targeted fix for a *measured* hot spot, not a default coding style — each one adds a cache that can hold stale assumptions.
