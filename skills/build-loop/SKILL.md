---
name: build-loop
description: >-
  Drive a build to actually-works, near-finish-line craft by looping build → see
  → exercise → check → critique → rebuild over the agent's existing tools (bash
  build/test, headless screenshot + vision, Playwright, axe/Lighthouse) until
  acceptance criteria pass or an explicit stop-condition fires — no infinite
  thrash. ALWAYS invoke when the user says any of "tighten this build", "iterate
  until it passes", "self-verify the UI", "make it actually work, not just
  compile", "loop until the core flows pass", or "drive this to near-finish-line".
  Also invoke proactively after a scaffold or feature lands and before handing a
  draft to a human. Composition-first over existing tools, not a new program; it
  states its own honest bounds — objective craft only, taste self-graded, ~80%
  ceiling, market validation out of scope. Do NOT use to decide WHAT to build
  (that's ideate) or whether a design/strategy is sound (deep-dive).
---

# Build-Loop — see-and-exercise iteration until a build actually works

`build-loop` takes a build that compiles-but-isn't-done and drives it toward **near-finish-line craft** by repeating one disciplined cycle — **build → see → exercise → check → critique → rebuild** — until its acceptance criteria pass or a stop-condition fires. It doesn't just re-read its own plan; it *runs, sees, and exercises what it built*, then feeds those observations back into the next rebuild.

It is **composition-first**: it orchestrates tools the agent already has — `bash` (build/test), a headless screenshot + vision to *see*, Playwright/headless to *exercise* the flows, `axe`/Lighthouse to *check* — via prose. It is **not** a new program, and not a reinvention of the see-and-exercise agents vendors already ship; it's the discipline that wraps them: a target, a loop, a stop-condition, and an honest ledger of what was actually checked.

This skill is the downstream partner to `prompt-pack` (which sequences *what* to build) and `ideate` (which decides *whether* to build it). It carries `prompt-pack`'s execute-discipline (**never fake a signal you didn't run**) and `ideate`'s conditional-design (**a design bar only when feel is load-bearing**).

## When to use this

**Strong triggers — invoke without asking:**
- "Tighten this build" / "drive it to near-finish-line" / "make it actually work, not just compile"
- "Iterate until it passes" / "loop until the core flows pass"
- "Self-verify the UI" / "see whether what I built actually renders and works"

**Softer triggers — invoke proactively:**
- A scaffold or feature just landed and you want it driven from "compiles" to "works + holds a craft bar."
- You're about to hand a draft to a human and want the machine-checkable defects gone first.

**Do NOT use this for:**
- Deciding **what** to build or whether it's worth building → that's `ideate`.
- Judging whether a design/strategy/codebase is **sound or safe** → that's `deep-dive`.
- A one-line fix you can make and eyeball in ten seconds → just do it.
- **Validating that people want it** → out of scope (see bounds below); that's the human/market handoff.

**Routing tie-breaker:** `build-loop` answers *"does this build actually work and meet its craft bar?"* — not *"is it the right thing to build?"* (`ideate`) or *"is it sound?"* (`deep-dive`).

## What it can and cannot do (read this before you trust it)

The honest bounds are load-bearing — they're stated here, up front, so no one reads a green loop as more than it is.

- **Catches (objective, trustworthy ground truth):** broken builds, failing tests, dead/half-wired flows, console errors, a control that doesn't actually change its output, missing-asset/404s, contrast and other `axe`-checkable a11y violations, blown performance budgets. These are *machine-checkable* — this is the part that moves a rudimentary scaffold toward near-finish-line craft.
- **Soft on (self-graded taste):** a model screenshotting its own UI and calling it "tasteful" is the monoculture, at the visual layer. The loop reliably flags *ugly/broken*; it is unreliable on *genuinely good*. The optional different-model critic (below) blunts this — but two correlated models still aren't a user.
- **Cannot see (the last-mile tail — plan for a human to finish it):**
  - **Content wrong against a source of truth it doesn't hold** — e.g. a value marked "invalid" that is actually valid in the target dictionary. The build is green, the flow works, the screenshot looks fine, and the content is still wrong. Without the external oracle, the loop has no way to know.
  - **Subtle correctness/security defects with no failing check** — a race, an auth edge, an off-by-one that no test exercises.
  - **Whether anyone wants it** — "works + looks good" ≠ "people want it."
- **Ceiling: ~80% of the craft, not 100%.** "Near-finish-line" is the **aim, not a guarantee**; the last-mile correctness/security/taste tail is the human's. **Market validation is explicitly out of scope.**

If a defect lands in "cannot see," the loop's job is to **name it and hand it off** — never to paper over it with a passing-looking screenshot.

## Prerequisite — lock the acceptance criteria first

You cannot loop without a target; a loop with no criteria either thrashes forever or stops arbitrarily. **Before iterating, lock:**
1. **Acceptance criteria** — binary, checkable statements of "done" (a machine or a scripted flow can settle each). Detail + examples in `references/acceptance-criteria.md`.
2. **The design bar — conditionally.** If experience/feel is load-bearing to this product (cf. `ideate`'s conditional-design forcing-function), carry an explicit design direction + design acceptance criteria, and compose `frontend-design` for the direction. If it's a plain utility, the bar is **plain-but-clear** — say so and don't gold-plate it.

If these don't exist yet, write them first (or pull them from the `CONCEPT_BRIEF.md` / pack). No criteria → no loop.

## The loop

Run this cycle each iteration. The detailed per-step playbook — exact invocations, what to look for, how to score — is in `references/loop-procedure.md`.

1. **Build & test** — run the project's own build, type-check, and unit/integration tests via `bash`. Capture exit codes and pass counts as ground truth. **A red build is iteration 0's only job** — get it green before anything else; you can't see or exercise what won't run.
2. **See** — launch the app, headless-screenshot the rendered UI at representative viewport(s), and judge it via vision against the design bar (hierarchy, spacing, contrast, alignment, state coverage). Capture console errors/warnings — a noisy console is a signal.
3. **Exercise** — drive the core flows headless (Playwright or equivalent): click, fill, navigate; assert each flow completes end-to-end. Critically, assert **control→output coupling** — drive each input and confirm the output it claims to govern actually changes (this is how you catch a slider wired to nothing).
4. **Check** — `axe` for a11y (contrast/focus/roles), Lighthouse for performance budgets, and a scan for broken assets/links.
5. **Critique** — turn the above into a **defect list with severity** (Blocker / High / Medium / Low) and the acceptance criterion each one blocks. Every entry points at a checkable signal or a named criterion — **no vibes.** (Optionally, fold in the different-model critic's findings — below.)
6. **Rebuild** — fix the **top** defects only; don't refactor adjacent code or gold-plate. Then re-enter at step 1.

Keep a **per-iteration ledger** of the objective signals (build exit, test pass count, flows passing, console-error count, a11y-violation count). That ledger *is* the craft-delta evidence and what you report at the end — not "it looks better."

## The stop-condition (no infinite thrash)

Stop and report the moment **any** of these fires:

- **PASS** — all acceptance criteria met and build/tests green. (Success — hand off.)
- **PLATEAU** — craft-delta below threshold for **2 consecutive iterations**, where "below threshold" means *no new acceptance criterion passed AND no defect of severity ≥ Medium closed.* (Diminishing returns — hand off what's left.)
- **BUDGET** — the iteration cap is reached (**default 5**; the caller may set it). This is the hard backstop.
- **BLOCKED** — the next defect needs a human or real-world signal the loop can't get (a taste call, an external-oracle/content check, a paste-into-production test). **STOP and emit it** as a human gate — carrying `prompt-pack`'s execute-discipline: never fake it, render a passed-looking result, or build past it to look complete.

**Why this can't infinite-loop:** BUDGET is an unconditional counter — even if PASS, PLATEAU, and BLOCKED never trigger, the loop halts at N iterations. The other three only ever stop it *sooner*. Every run terminates.

Always report **which condition fired** and the **before/after on the objective ledger** — so the caller sees the actual craft-delta, not a vibe.

## The optional different-model critic (recommended — but the loop runs without it)

The builder grading its own taste is a monoculture at the visual layer. A critic running a **different model**, handed **only** the screenshots + acceptance criteria + design bar (blind to the builder's own rationale), surfaces taste/quality judgments the builder shares with itself and can't see. Fold its defects into step 5's critique.

**Modularity is locked:** the loop runs **fully without** the critic — the objective signals (build/test/flows/console/a11y) don't need a second model. The critic is an **enhancement layered on the taste step, never a dependency**, and never gates the objective signals. Be honest about its limit: even with it, you have two correlated models, not a user — still soft on *genuinely good*, still zero market signal.

## Environment & fallbacks (run anywhere)

The method is portable; only the tooling degrades. Substitute the fallback and **say so in the report** — a signal you couldn't run is reported as **not run**, never as passed (execute-discipline).

| Capability | If unavailable |
|---|---|
| `bash` build/test | Core — if you can't build/test, you can't loop; stop and say so. |
| Headless screenshot + vision (*see*) | Skip the *see* step; the loop runs on build/test/exercise/check signals only. Note the gap; don't fake a visual pass. |
| Playwright/headless (*exercise*) | Fall back to whatever drives the surface — run the CLI, call the API, hit the endpoint — and assert outputs. Skip only if there's genuinely no exercisable surface. |
| `axe` / Lighthouse (*check*) | Skip the a11y/perf checks; report them as not run. |
| Different-model critic | Run the loop without it (it's optional by design). |

**Non-browser surfaces** (a CLI, a library, a backend) have no *see* step — run build/test plus a targeted *exercise* (invoke the binary, call the function/endpoint, assert the result) and skip the visual steps. The loop still earns its keep on the objective signals.

## Pitfalls to avoid

- **Looping with no acceptance criteria** — guarantees thrash or an arbitrary stop. Lock the target first.
- **Treating self-graded "looks good" as a pass** — it's the monoculture. Pass on objective signals; let the critic + a human handle taste.
- **Faking a signal you couldn't run** — a skipped check is reported skipped, never green.
- **Reinventing the harness** — compose the existing tools; if you find yourself writing a bespoke test-runner/agent framework, stop (that's not this skill).
- **Looping past the plateau** — diminishing returns are a hand-off signal, not a reason to grind. The last-mile tail is the human's.
- **Reading "works + looks good" as "validated"** — market validation is not in scope; don't imply it.
- **Guessing at a content/correctness defect** — if settling it needs an external oracle the loop doesn't have, emit it as a human gate, don't invent the answer.

## Scale heuristics

| Situation | What to run |
|---|---|
| A tiny change that just needs to compile | One pass: build + test, eyeball. No full loop. |
| A fresh scaffold or feature (plain utility) | Full loop, N≈3–5, acceptance criteria; design bar = plain-but-clear. |
| A build where feel **is** the wedge | Full loop + the different-model critic + a flagged human spot-check on taste; explicit design bar (compose `frontend-design`). |
| A non-browser CLI/library/backend | Build/test + targeted exercise; skip *see*; objective signals only. |

The loop scales down to a single build/test pass and up to a multi-iteration, critic-augmented drive — but the discipline is constant: a checkable target, an honest ledger, a stop-condition, and a clean hand-off of the tail it cannot see.
