# Separate before serializing shared state

When concurrent actors might share mutable state, first ask whether they truly need the same mutable object. If not, eliminate the sharing. When sharing is real, enforce serialization structurally: lockfiles, sequential phases, exclusive ownership. Instructions and conventions are not concurrency control.

1. Identify shared mutable state: files both read and write, branches both push to, APIs both define and consume.
2. Default: eliminate the shared write target. Give each actor its own file, key, branch, or state directory, and merge only at the read or reporting boundary. Two workers writing their own field into one `state.json` is still shared mutation; two files is not.
3. Only when one shared write target is a real invariant, serialize access structurally. "We need a lock" is a design smell to check, not the default answer.

Scope note: this is the argument for worktrees, and it applies when two agents will write the same files at the same time. A single small fix in the main checkout has no shared writer and needs no worktree.
