# Backend & Data Vocabulary

*Where state lives, how it changes, and what happens when two things change it at once.*

**Migration** — A versioned, ordered change to the database schema, checked into the repo. The schema's git history: applied once, never edited after it ships — write a new one instead.

**Seed** — A script that fills a database with known starting data. Good seeds are idempotent — safe to run twice without duplicating rows.

**Idempotent** — Running it N times has the same effect as once. The property that makes retries, seeds, and webhooks safe; achieved with upserts, natural keys, or checked preconditions.

**Transaction** — A group of writes that succeed or fail as one — no half-applied states. The tool for "create order + decrement stock" style invariants.

**Rollback** — Undoing to a previous state: a transaction aborting, a migration's down step, or a deploy reverting. Ask "what's the rollback?" before any risky change, not after.

**Race condition** — Correctness depends on which of two concurrent operations lands first. Check-then-act ("if slot free, book it") is the classic shape; the fix is making it atomic (constraint, transaction, lock), not making it faster.

**Optimistic vs pessimistic concurrency** — Optimistic: proceed, detect conflict at write time (version column), retry. Pessimistic: lock first. Optimistic wins when conflicts are rare — which is most web apps.

**Index** — A lookup structure making reads on a column fast, at the cost of slower writes and space. Missing index = slow query; the columns in your WHERE and ORDER BY are the candidates.

**N+1 query** — One query for a list, then one more per item — usually an ORM lazy-loading relations in a loop. Detected in query logs, fixed by eager-loading or a join.

**Join vs denormalization** — Join: combine tables at read time, one source of truth. Denormalize: copy data so reads are one fetch, accepting you now must keep copies in sync. Denormalize for measured read pressure, not by default.

**Foreign key / constraint** — The database enforcing referential rules itself (no orders for deleted users). Constraints catch what application code forgets — they're the last line, so let the DB hold them.

**Soft delete** — A `deleted_at` column instead of removing the row. Preserves history and undo, but every query must now remember to filter — a scope/default the ORM should own.

**Pagination: offset vs cursor** — Offset (`LIMIT 20 OFFSET 400`) degrades with depth and skips/duplicates under concurrent writes. Cursor ("after id X") is stable and fast; prefer it for anything users scroll.

**Cache invalidation** — Deciding when stored copies are wrong. Every cache is a bet that staleness is acceptable; the design question is "how stale, and who pays when it's wrong?"

**TTL** — Time-to-live: the cache entry's expiry. The bluntest invalidation strategy — right when "at most N minutes stale" is genuinely fine.

**Stale-while-revalidate** — Serve the stale copy instantly, refresh in the background. The pattern behind ISR and most CDN caching: users get speed, freshness arrives one request later.

**Edge vs origin** — Edge: many small locations near users (CDN, Workers). Origin: the one place your app actually lives. Latency you can't remove with faster code is usually distance to origin.

**Cold start** — First-request latency while a serverless instance spins up. Why "it's slow sometimes" on low-traffic functions; mitigations are smaller bundles or keeping instances warm.

**KV vs D1 vs R2 vs Durable Object** *(Cloudflare)* — KV: eventually-consistent key-value, read-heavy config. D1: SQLite — relational data, real queries. R2: object storage — files and images. Durable Object: a single-instance stateful coordinator — the answer to "these requests must agree."

**Binding** — Cloudflare's dependency injection: the wrangler-config name (`env.DB`, `env.BUCKET`) through which a Worker reaches KV/D1/R2/DOs. No binding, no access — check wrangler config first when `env.X` is undefined.

**Webhook** — Them calling your endpoint when something happens (payment settled). Verify the signature, respond fast, process async, and expect duplicates — which is why handlers must be idempotent.

**Polling vs push** — Asking repeatedly vs being notified. Polling is simpler and self-healing; push (webhooks, websockets) is fresher and cheaper at scale. Start with polling unless latency is the product.

**Rate limit / backoff** — The server's request ceiling, and the client's polite retreat: wait exponentially longer between retries, with jitter so retriers don't stampede in sync.

**Connection pool** — Reused database connections. Serverless breaks naive pooling — a thousand short-lived instances each opening connections — which is what pool-proxies (Hyperdrive, pgBouncer) exist to fix.

**Queue** — A buffer decoupling "accept the work" from "do the work." The move when a request triggers something slow (email, export): enqueue, return, process later — with retries built in.

**Schema drift** — Production's actual schema no longer matching your migrations — usually from manual hotfixes in a console. The reason "works locally, fails in prod" happens with correct-looking code.

**Backfill** — Filling a new column or table with values for all existing rows. The second half of many migrations, and the slow half — often run as a batch job, not in the migration itself.
