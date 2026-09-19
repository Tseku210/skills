# Prove it works

Verify every task output by checking the real thing directly. Do not infer from proxies, self-reports, or "it compiles".

Why: indirect verification (file mtimes, output freshness, an agent's summary, a cached screenshot) feels cheaper than direct observation. Acting on a wrong inference costs far more than checking the source.

After any task, ask: how do I prove this actually works?
1. Build it. Necessary, not sufficient.
2. Run it and exercise the actual feature path on the real surface: the page in agent-browser, the CLI in a PTY, the endpoint with curl, both locales when it's bilingual.
3. Check the full chain: does data flow from input to output, and did the side effect land (the row, the file, the KV key)?
4. When verification fails, suspect the observation method before the system.

Delegation: trust artifacts, not self-reports. Inspect the diff, the file, the runtime behavior. Agents report what they intended, not always what happened.

Script the check when you can. A deterministic script that re-runs the comparison beats a one-time eyeball, and it is an artifact a reviewer can re-run. Keep it visible; commit it only when the trail must be auditable later.
