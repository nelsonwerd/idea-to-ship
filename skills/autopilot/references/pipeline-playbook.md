# Pipeline Playbook — flying the four phases (compose, never copy)

How autopilot runs each phase: which skill it **invokes**, what that skill gets from the run, what carries forward, and where the gates are. autopilot adds *connective tissue only* — it never reimplements a sub-skill. Each phase's deliverable is a **file**; the file is the contract between phases (and the resume point for a fresh chat).

A note that governs the whole run: **stay in character** as the grounded persona for everything the founder can decide, and **emit — never fake — any gate that needs a human or real-world signal** (execute-discipline).

## Phase 1 — `ideate` (in character) → `CONCEPT_BRIEF.md`

- **Invoke `ideate`** and run its funnel *as the persona*: brain-dump the real lived pain, set the selection rubric, diverge, run the honest pressure-test, converge, name late. Answer each of its gates in-character — do not stop for a human.
- **Force both anchors** the kickoff locked: a real success metric and a kill-criterion, before any roadmap. `ideate` refuses to roadmap without them; autopilot supplies them in-character.
- **Resolve the conditional-design forcing-function:** if feel is load-bearing, the brief must carry a *substantive* design direction (vibe, references, principles, intended feel, design acceptance criteria); if not, "plain-but-clear." This is what Phase 4 will hand to `build-loop`.
- **Output:** `docs/CONCEPT_BRIEF.md` — grounded concept, locked decisions, scope IN/OUT, phased roadmap, the gate, the design call.
- **Gate type:** autonomous (the founder decides). The grounding itself is the one firewall check — if the concept rests on invented demand, stop and hand back (don't fabricate a market).

## Phase 2 — `deep-dive` → validate the load-bearing claims

- **Invoke `deep-dive`** on the brief's load-bearing claims (the ones the verdict turns on). It runs its multi-lane validation, red-team, and an honest confidence + **ground-truth tally**.
- **Fold its hand-back into the brief** — update the verdict, the verified-vs-still-a-bet split, and any scope/decision the dive corrected. (In the real runs the dive deleted an impossible success-metric clause and demoted a confounded proxy; expect it to *change* the brief, not rubber-stamp it.)
- **Honest-confidence caveat carries up:** the dive is the same model family as the builder, so weight externally-checkable claims above model judgment, and cap confidence by the ground-truth ratio. autopilot reports that cap; it does not launder a judgment call into a fact.
- **Output:** the updated brief + the dive's evidence files.
- **Gate type:** mostly autonomous, but any claim that needs real-world data the run can't get is flagged `unverified` and carried as a human gate — not asserted.

## Phase 3 — `prompt-pack` → sequence the gated scope

- **Invoke `prompt-pack`** (authoring mode) on the validated brief. It maps Locked decisions / Scope OUT / roadmap onto a sequenced, self-contained pack and bakes in the project's conventions.
- **Carry execute-discipline:** the pack sequences ONLY the validated/gated scope; each prompt's gate names who clears it (machine vs human). autopilot will not let the build phase exceed gated scope.
- **Output:** `docs/<TOPIC>_PROMPT_PACK.md`.
- **Gate type:** autonomous to author; the per-prompt gates are honored in Phase 4.

## Phase 4 — `build-loop` → drive each unit to near-finish-line craft

- **Invoke `build-loop`** on each shippable unit, in pack order. It runs its two co-equal tracks — the objective machine facts AND, when feel is load-bearing, the **mandatory multi-pass visual design loop**.
- **Carry the design direction in:** hand `build-loop` the brief's substantive design direction as its design bar (and compose `frontend-design` for craft). Expect a genuine **multi-pass** loop — render → critique → fix → re-render — **not a unit-test substitute and not one-and-done**; expect the per-iteration ledger + the stop-condition + the iteration count in its report.
- **Honor the stop-condition:** PASS needs no open Blocker/High/Medium on either track (and, when load-bearing, the design bar met). A defect that needs a human/real-world signal (a content oracle, a taste call) is emitted as BLOCKED — a human gate — not faked.
- **Output:** the built unit + `build-loop`'s ledger/report per unit.
- **Gate type:** machine-checkable craft is autonomous; the **design taste spot-check** and the **last-mile tail** are human gates surfaced in the hand-off.

## The hand-off (after Phase 4)

autopilot closes with an honest hand-off — never an "it's done" claim:
- **The corrected gate result:** proceed / park on real-use + checkable craft (build/run/flows/design bar; finish-vs-rebuild). Report "judgment matches an expert" only as a **signal**.
- **The kill-ledger:** every parked/killed concept with its **steelman + flip-condition**.
- **What only a human/market finishes:** the last-mile correctness/security tail; the **design taste spot-check** (when feel is load-bearing — "two models agreeing ≠ a designer signed off"); and **market validation** ("works + looks good + well-judged" ≠ "people want it").

## Context / handoff safety-net (whole run)

- **Files are the memory.** Brief → dive evidence → pack → per-unit build ledgers → hand-off note. A fresh chat resumes from the files, never from chat memory.
- **If context runs low**, emit a `prompt-pack` Mode C handoff (state snapshot + read-these-first + exact next step) so the run continues in a new chat with no amnesia. A long autonomous run is *expected* to span chats; the files make that safe.

## The one rule that keeps this honest

Every phase above is an **invocation of an existing skill**, not a re-implementation. autopilot's value is the orchestration, the autonomy contract, the corrected gate, the kill-ledger, and the honest hand-off — not new capability. If a phase tempts you to inline a sub-skill's procedure, that's the signal to stop and invoke the skill instead.
