# Testing & Debugging Vocabulary

*How you know it works, and what to say when it doesn't.*

**Unit vs integration vs e2e** — Unit: one function in isolation, fast, thousands. Integration: several real pieces together (route + DB). E2E: the app as a user drives it, browser and all — slow, few, reserved for money paths. The pyramid: many unit, some integration, few e2e.

**Smoke test** — The fastest possible "is it fundamentally alive?" check — app boots, homepage renders, login works. Run first; if smoke fails, nothing else is worth running.

**Regression test** — A test written *from a bug*: it reproduces the failure, then the fix makes it pass, and it stands guard forever. Every real bug should leave one behind.

**Acceptance criteria** — The observable behaviors that define "done," written before the work: "when X, then Y." Turns "it's still not working" into a checkable list — and gives an agent a target it can verify itself.

**Fixture / factory** — Fixture: fixed, known test data. Factory: a function generating valid objects with overridable fields (`makeOrder({status: 'paid'})`). Factories age better — one schema change updates one place.

**Mock vs stub vs spy vs fake** — Stub: canned answers ("return this user"). Mock: a stub that also *asserts* it was called correctly. Spy: wraps the real thing and records calls. Fake: a working lightweight substitute (in-memory DB). Over-mocking tests your wiring, not your behavior.

**Flaky test** — Passes and fails on the same code — timing, order-dependence, shared state, real network. Quarantine it or fix it; a suite people re-run "until green" protects nothing.

**Snapshot test** — Asserting output matches a stored copy wholesale. Cheap to create, cheap to blindly re-approve — which is how they rot into noise. Good for stable serialized output, bad for "did the UI change?"

**Coverage** — Percentage of code executed by tests. A useful *floor* and a terrible target: 100% coverage with weak assertions verifies nothing. Read it to find untested branches, not to score points.

**Red-green-refactor** — TDD's loop: write the failing test (red — proves the test can fail), make it pass minimally (green), then clean up under its protection. Skipping red is how tests that always pass get written.

**Happy path vs edge case** — The intended flow vs the boundaries: empty list, zero, one, max, unicode, offline, double-click. Bugs live at the edges; "works for me" usually means "works on the happy path."

**Repro / minimal repro** — Reliable steps that trigger the bug, then the *smallest* version that still does. Minimizing isn't overhead — it usually reveals the cause before any debugger opens.

**Root cause vs symptom** — The null check that stops the crash treats the symptom; *why* it was null is the cause. Ask "why" until the answer is a decision, not another symptom — patched symptoms return wearing different stack traces.

**Bisect** — Binary-search the history (or the input, or the config) between known-good and known-bad. The systematic alternative to staring; `git bisect` automates the history case.

**Instrument** — Adding targeted observation (logs, counters, timers) to see what actually happens, instead of reasoning about what should. When a debugger can't attach — prod, timing bugs — instrumentation is the debugger.

**Heisenbug** — A bug that vanishes under observation — the debugger or extra logging changes timing enough to hide the race. Its appearance is itself evidence: suspect concurrency.

**Off-by-one** — The boundary error family: `<` vs `<=`, index vs count, fencepost problems. Named because it's *that* common; check the boundaries first.

**Dry run** — Executing the logic with writes disabled, printing what *would* happen. Any script that mutates data in bulk deserves a `--dry-run` flag, run first, output read.

**Canary** — Shipping to a small slice first and watching before full rollout. The production-scale version of "try it on one file first."

**Assertion** — A declared invariant that fails loudly when violated. In tests it's the point; in production code, a tripped assertion is a gift — the bug announced itself at the cause, not three layers later.

**Determinism** — Same inputs, same result, every time. The property tests depend on; time, randomness, and network are the usual leaks — inject or freeze them.

**Test double leakage** — Mocks drifting from the real thing's behavior, so tests pass while production breaks. The check: does anything verify the double against reality (contract tests, occasional integration runs)?

**Quarantine** — Moving a flaky test out of the blocking suite while keeping it running and tracked. Honest middle ground between deleting it and letting it poison trust in CI.

**Verification vs testing** — Tests check what you predicted; verification exercises the real flow end-to-end and *observes* it — open the page, click the button, watch the network tab. "Tests pass" and "it works" are different claims; agents especially must earn the second one.
