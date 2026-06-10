# Loop Procedure — running one build → see → exercise → check → critique → rebuild cycle

This is the detailed playbook for each iteration of the loop. The discipline that makes it work: every iteration ends with an **objective ledger** (numbers, not adjectives) and a **defect list tied to acceptance criteria** — so progress is measured, not felt. Read `acceptance-criteria.md` first; you cannot run this without a target.

## Iteration 0 — get a green build

A red build blocks everything downstream — you can't *see* or *exercise* what won't run. So the first iteration's only job, if the build is broken, is to make it green:
- Run the project's own build + type-check + tests via `bash`. Use the repo's real commands (from its `CLAUDE.md`/`AGENTS.md`/`package.json`/`Makefile`); don't guess.
- Fix compile/type/test failures only. Don't start polishing UI on a tree that doesn't build.
- Record the baseline ledger (below) before you change anything you're judging — you need a before to claim an after.

## The per-iteration ledger (record every iteration)

The ledger has **two co-equal tracks** — objective machine facts and (when design is load-bearing) the design bar. Capture both each pass; this is your craft-delta evidence and your final report, and it maps directly onto how a proof run (or a caller like `autopilot`) judges the loop:

| Track | Signal | How | Ground truth? |
|---|---|---|---|
| Machine | Build exit code | `bash` build command → `$?` | Yes |
| Machine | Test pass count | the project's test runner → "N passed / M total" | Yes |
| Machine | Core flows passing | the headless *exercise* scripts → pass/fail per flow | Yes |
| Machine | Console errors/warnings | captured during *see*/*exercise* | Yes |
| Machine | a11y violations (impact ≥ serious) | `axe` run → count | Yes |
| Machine | Perf budget | Lighthouse score / key metric vs. budget | Yes |
| Design | Design-bar criteria met | vs. the brief's design acceptance criteria | Partly — checkable criteria yes; "feels good" self-graded |
| Design | Design defects open (by severity) | the *see* design-critique (`design-critique.md`) → count | Partly — missing state / overflow / contrast are checkable; pure aesthetic taste is not |

The machine track is ground truth. The design track mixes **checkable** items (states present, no overflow, contrast) with **self-graded** taste — keep the soft part labeled and lean on the different-model critic + a human spot-check for it. **Neither track substitutes for the other:** green machine facts never excuse a skipped design loop, and improving screenshots never excuse a red test. When design is *not* load-bearing, the design rows collapse to a single "plain-but-clear / nothing broken" check.

## Step 1 — Build & test

- Run build, type-check, unit/integration tests. Quote the summary lines (exit code, "N passed").
- Treat the exit code and pass count as ground truth — they end debates a screenshot can't.

## Step 2 — See (the design-critique pass)

- Launch the app (dev server, or serve the static build). Confirm it boots (HTTP 200 / no crash).
- **When design is load-bearing, run the full iterated design critique — every iteration, mandatory.** Render the running UI (interactive renderer preferred — Preview MCP / Claude-in-Chrome / computer-use — else a Playwright screenshot script), capture the key states (empty/loading/error/hover/focus/filled) across ≥2 viewports (mobile + desktop), critique against the brief's design direction AND the craft heuristics, and emit **design defects with severity**. A unit/coupling test does **not** substitute for this. No renderer → report the visual loop **NOT RUN** (design bar unmet for a load-bearing build); never fake it. The full ritual — heuristics checklist, exact tool invocations, the different-model critic, and the human spot-check — lives in **`design-critique.md`**.
- **For a plain utility**, glance at the rendered UI for "plain-but-clear / nothing broken"; don't gold-plate.
- **Capture the console.** Errors and warnings are objective signals — a flow that "works" while throwing console errors is not done.

## Step 3 — Exercise

- From the acceptance criteria, script the **core flows** headless (Playwright or equivalent): the few paths that carry the product's promise.
- Assert each flow **completes end-to-end** — the user can actually get from start to finish, with the expected result.
- Assert **control→output coupling.** For every interactive control that claims to govern an output, drive it and confirm the output *actually changes*. This is how you catch the classic decoupling defect: a slider/toggle/field wired to the preview but not to the thing it's supposed to produce (the export, the saved value, the API call). A build can look perfect and be silently inert here.
- Record which flows pass, and for failures, the exact failing step.

## Step 4 — Check

- **`axe`** (or equivalent): count a11y violations; list the specific contrast/focus/role issues. Gate on impact ≥ serious by default.
- **Lighthouse** (or equivalent): performance/score against the budget the criteria set.
- **Assets/links:** scan for 404s, broken images, dead links.

## Step 5 — Critique

- Consolidate everything into one **defect list spanning both tracks** (machine defects AND design defects), each entry carrying:
  - **Severity** — Blocker / High / Medium / Low (same tiers as `deep-dive`).
  - **The acceptance criterion or design-bar criterion it blocks** (or the objective signal it failed).
  - A one-line, checkable description — points at a signal, a criterion, or a named design heuristic, never "feels off."
- **Different-model critic** — **default when design is load-bearing**, optional for a plain utility. Blind review: give it only the screenshots + acceptance criteria + design direction, not the builder's rationale; merge its defects in. Protocol + honest limits in `design-critique.md`. It never gates the machine facts and never replaces rendering the UI.
- Pick the **top few defects** (highest severity, most criteria unblocked) **from both tracks** for this rebuild. Don't try to fix everything at once.

## Step 6 — Rebuild

- Fix **only** the selected top defects (machine and design). Don't refactor adjacent code, rename things, or gold-plate (borrow `prompt-pack`'s scope discipline — a tight diff is reviewable; a sprawling one isn't).
- Re-enter at Step 1. Re-run the full ledger — both tracks — so the delta is measured, not assumed.

## Closing an iteration — apply the stop-condition

After the rebuild + re-measure, check the stop-condition (in `SKILL.md`): **PASS / PLATEAU / BUDGET / BLOCKED.** PASS requires **both tracks** — acceptance criteria + build/tests green, and (when design is load-bearing) the design bar met via the visual loop; a green build/test alone is not PASS. If one condition fires, stop and report; otherwise loop again. BUDGET (default N=5) is the unconditional hard backstop that guarantees termination.

## Handling a "cannot see" defect mid-loop

If a defect needs a signal the loop can't produce — content correctness against an external oracle, a genuine taste call, a real-world/market test — do **not** guess a fix or hide it behind a clean screenshot. Log it as **BLOCKED**, name exactly what would settle it and who must do it, and emit it as a human gate. That is a complete, honest outcome — the loop did its job by finding the edge of its own competence.

## What to report at the end

- The **stop-condition** that fired.
- The **before/after ledger** (the objective signals from iteration 0 to the last) — the concrete craft-delta.
- The **open defects** handed off, split into *machine-checkable but deferred* vs. *the cannot-see tail a human must finish.*
- Any signal **not run** (and why), reported as not-run — never as passed.
