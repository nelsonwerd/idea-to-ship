# Pack Template

The canonical structure for a prompt pack, distilled from real packs that shipped large changes safely across many chats. Copy this scaffold, fill the `<PLACEHOLDERS>`, delete guidance comments (`<!-- ... -->`), and save to `docs/<TOPIC>_PROMPT_PACK.md`.

A pack has two layers: **pack-level front matter** (read once) and **N self-contained prompts** (each pasted into its own fresh chat). The whole point is that an executing chat needs *only* one prompt block — so each prompt re-states the rules it needs and names the docs to read.

---

## Layer 1 — Pack front matter

````markdown
# <Human title> — Prompt Pack

**Created:** <YYYY-MM-DD>
**Companion docs:** <docs that give full context, e.g. an audit/handoff doc>
**Platform scope:** <e.g. iOS/SwiftUI + Python backend>
**Validated against:** commit `<short-hash>` on branch `<branch>` <!-- the tree state this pack was written against; if the executing chat is far ahead, re-verify the Architecture map before trusting line refs -->

<1-2 sentence description of what this pack accomplishes and why it's split up.>

## How to use this pack

This pack contains **<N> prompts**<, organized into <M> phases>. Feed them back **one at a time, in order**. Each prompt is self-contained — paste it into a **fresh chat** and it has everything that chat needs.

- One prompt = one chat session = one focused, shippable unit. **Don't stack prompts. Don't skip ahead.**
- Between prompts: verify the change, then **commit** (you, after review), then start the next prompt in a new chat.
- Each phase leaves the app in a working, shippable state — you can pause between phases.
- **This pack is the source of truth.** If a future session is confused, point it here.

## RULES (every prompt inherits these)

<!-- Pull project-specific rules from CLAUDE.md / AGENTS.md / auto-memory. Defaults below: -->
1. **Read first.** Start by reading auto-memory + `CLAUDE.md`/`AGENTS.md` + the companion docs. Then **verify every file:line reference against the current code before editing** — the codebase moves between writing and running a prompt.
2. **Do not commit unless I explicitly say "commit."** Each prompt produces local changes only; I review and say go.
3. **Tone:** short, direct, no filler. **Push back** if a prompt's assumptions disagree with the code you find.
4. **Match existing style.** No premature abstractions; minimal comments; no emojis in files.
5. **Staging hygiene:** stage files by name; never blanket-add untracked dirs.
6. **Commit messages:** `<project format, e.g. "area: imperative subject">`. <co-author-trailer preference>.
7. <Any platform gotchas, e.g. "gate iOS-only APIs behind #if os(iOS); package target is macOS .v13 → one-arg .onChange">.

## Build / test commands (reusable across all prompts)

```bash
<!-- The exact, verified commands for this repo. Copy from CLAUDE.md / AGENTS.md. -->
<e.g. cd ios/Packages/ClosureKit && swift test>
<e.g. xcodebuild -project ... -scheme ... -destination '...' build>
<e.g. cd backend && .venv/bin/python -m pytest -q>
```

## Locked decisions
<!-- Only for design-heavy packs. The constraints agreed in the planning conversation. -->
- <Decision 1 the executing chat must treat as fixed>
- <Decision 2 ...>

## Architecture map
<!-- Key files identified during the read-only architecture reconnaissance, so executing sessions don't rediscover them. Use real paths; mark line numbers as "verify before editing." -->
- <Subsystem>: `<path>` — <what it does>
- <Subsystem>: `<path>` — <what it does>

## Sequencing rationale
<!-- WHY this order; what each phase unblocks; why each is independently shippable. -->
<Phase A ships X first so that later phases can rely on it; Phase B is pure infra; ...>

## Execution order
`P1 → P2 → P3 → …`  (each "→" is a commit boundary with a verification gate)

## What this pack does NOT cover
<!-- Explicit scope fence. Prevents the executing chat from wandering. -->
- <Out-of-scope item 1 — deferred to a later batch>
- <Out-of-scope item 2>
````

---

## Layer 2 — Per-prompt anatomy (repeat for each prompt)

This is the heart. Every prompt is a self-contained brief. Keep the same sections in the same order so executing chats know where to look.

````markdown
# P<n> — <area>: <imperative one-line goal>

**Risk:** <very low | low | medium | medium-high | HIGH>. <one-line why.>
**Files:** `<path>`<, `<path>` …> <(plus tests in `<path>`)>.

## Read first
- Auto-memory + `CLAUDE.md`/`AGENTS.md`.
- <Companion doc(s)>.
- Verify these references against current code before editing: `<file:line>` — <what's there>.
- `git status --short` on the files below — if any have unrelated uncommitted changes, stop and report.

## Why this exists / Goal
<2-4 sentences: the problem, and exactly what this prompt should achieve. Be honest about whether the right answer might be "this is already fine" — the executing chat should push back, not force a change.>

## Scope — exact changes
<!-- Be concrete. Where helpful, show before/after code blocks. This is the spec. -->
### <file or step>
<current → updated, or a precise description of the edit>

## What MUST NOT change
<!-- The guardrails. This is what prevents scope creep and silent regressions. -->
- <Invariant 1 — e.g. "endpoint URL/shape", "render output for the USD path", "the X helper signature">
- <Invariant 2>

## Tests
- <Existing tests to update + why> / <new tests to add, with the cases they must cover>.

## Verification
1. `<exact command>` — <expected result>.
2. `<exact command>` — <expected result>.
3. **Manual matrix:**
   - <Regression case — old behavior still works>.
   - <New-behavior case 1>.
   - <New-behavior case 2 / edge case>.

## Gate — who clears it: machine vs human
<!-- Optional — include when proceeding past this unit hinges on a checkpoint. Machine-cleared: the Verification commands above settle it (build/tests/headless flow/axe). Human / real-world-cleared: it needs a signal not available in-session (real-use test, taste call, paste-into-prod, next-day survival). If human-cleared, the executing chat STOPS and emits the gate (states what's unverified + who must clear it) and never fakes it, renders a "passed" gate, or builds past it. Omit if the unit has no gate beyond its Verification. -->
- **Gate:** <what must hold to proceed past this unit>. **Cleared by:** <machine — the Verification above | human — name the real-world signal>.

## Risk register
- **Could break:** <what> — **mitigation:** <how to detect/avoid>.

## Commit message
```
<area>: <imperative subject>
```

## When done
Report: files changed (with line numbers), test/build results, anything you had to adapt or any existing test you updated and why. **Do not commit — wait for my explicit go.**
````

---

## Closers (end of the pack)

````markdown
# Combined verification matrix (after multiple prompts ship)
<!-- The end-to-end checks once a phase / the whole pack has landed. -->
1. <Cross-cutting regression check>.
2. <End-to-end new-behavior check>.
3. <Backward-compat check, e.g. old client ↔ new server>.

# Pre-flight checklist (run before handing off)
- [ ] <Prerequisite that must be live first>.
- [ ] Hand P1 to a fresh chat. Wait for it to land + verify + commit.
- [ ] Then hand P2 to another fresh chat. …
- [ ] If a fresh chat needs more context than a prompt provides, point it at <companion docs>.
````

---

## Filled mini-example (one prompt, concrete)

This shows the anatomy populated, so the pattern is unambiguous.

````markdown
# P1 — backend: include `currency` on every list-API row (defense in depth)

**Risk:** low. Pure additive field on a JSON response; clients ignore unknown keys.
**Files:** `<the list endpoint, e.g. api/items.py>` (+ its tests).

## Read first
- Auto-memory + `CLAUDE.md` / `AGENTS.md`.
- <any companion doc that explains the larger effort>.
- Verify before editing: the row-builder dict literals in the endpoint — find them in current code; don't trust remembered line numbers.

## Why this exists / Goal
Each row in the list response omits its own `currency`, so the client falls back to a global default and can mislabel a row. Add an explicit per-row `currency` so the wire format is honest even if a future code path returns a non-matching row.

## Scope — exact changes
### `<api/items.py>`
Add `"currency": row.currency` to each row dict literal in the summary lists. Use the row's own stored value, not the global default.

## What MUST NOT change
- Endpoint URL/path and existing field names/types.
- How amounts are stored.
- Existing filtering behavior.

## Tests
- Update any test that asserts an exact key set on a row.
- Add: every row in the response includes `currency`, matching the row's stored value.

## Verification
1. `<test command>` — all green.
2. `<lint command>` — clean.
3. **Manual matrix:** single-currency account → output unchanged (regression). Mixed-currency data → each row shows its own currency, not the global default.

## Gate — who clears it: machine vs human
- **Gate:** tests + lint green and the manual matrix holds. **Cleared by:** machine — the Verification commands above; no human/real-world signal needed.

## Risk register
- **Could break:** tests that exhaustively assert the row key set — **mitigation:** run tests first, add `currency` to the expected set.

## Commit message
```
<area>: include currency on every list row (defense in depth)
```

## When done
Report files + line numbers, test/lint results, any test you updated. **Do not commit — wait for my go.**
````
