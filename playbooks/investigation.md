### Investigation

**You own the answer. Plan, route, write.**

Read-only requests: "how does X work?", "why was Y built this way?", "are we sure about Z?", "should we do X or Y?". They produce a cited explanation or a recommendation, not a code change.

1. Route through the `how` skill: Explain mode for "how does it work", History mode for "why was it built this way". For "are we sure" and "X or Y", run Explain first, then give your own judgment with reasons.
2. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only investigation`.
3. Produce the `how`-shaped output (Overview / Key concepts / How it works / Where things live / Gotchas), or a recommendation with a tradeoffs table if the request is a decision between alternatives. If the user asked for a visual, or the flow has three or more moving parts, hand the result to `show-me`.
4. Apply `unslop` to the reply.

No PR, no design fan-out unless the investigation precedes a code change. If it does, hand back to the user and re-route to Bug fix or Feature.

**Reply:** the investigation output. For "are we sure?" answers, include your real judgment with reasons. Push back if the premise is wrong.
