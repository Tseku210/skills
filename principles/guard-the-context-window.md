# Guard the context window

The context window is finite and non-renewable within a session. Every token that enters should earn its place.

- Isolate large payloads. Route verbose outputs, screenshots, and long documents to subagents. The main context gets summaries.
- Don't read what you won't use. Read selectively; skip files the task doesn't need.
- Keep frequently used content inline. A template used on every invocation belongs in the skill file, not in a separate file that costs a read each time.
- Size phases and cap scope: files per phase, turn budgets, mechanism costs.
- Before a long task, checkpoint so a compaction loses nothing that matters.
