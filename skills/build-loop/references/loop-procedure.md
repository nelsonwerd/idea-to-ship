# Loop Procedure — running one build → see → exercise → check → critique → rebuild cycle

This is the detailed playbook for each iteration of the loop. The discipline that makes it work: every iteration ends with an **objective ledger** (numbers, not adjectives) and a **defect list tied to acceptance criteria** — so progress is measured, not felt. Read `acceptance-criteria.md` first; you cannot run this without a target.

## Iteration 0 — get a green build

A red build blocks everything downstream — you can't *see* or *exercise* what won't run. So the first iteration's only job, if the build is broken, is to make it green:
- Run the project's own build + type-check + tests via `bash`. Use the repo's real commands (from its `CLAUDE.md`/`AGENTS.md`/`package.json`/`Makefile`); don't guess.
- Fix compile/type/test failures only. Don't start polishing UI on a tree that doesn't build.
- Record the baseline ledger (below) before you change anything you're judging — you need a before to claim an after.

## The per-iteration ledger (record every iteration)

Capture these objective signals each pass. This is your craft-delta evidence and your final report — and it maps directly onto how a proof run (or a caller like `autopilot`) judges the loop:

| Signal | How | Ground truth? |
|---|---|---|
| Build exit code | `bash` build command → `$?` | Yes |
| Test pass count | the project's test runner → "N passed / M total" | Yes |
| Core flows passing | the headless *exercise* scripts → pass/fail per flow | Yes |
| Console errors/warnings | captured during *see*/*exercise* | Yes |
| a11y violations (impact ≥ serious) | `axe` run → count | Yes |
| Perf budget | Lighthouse score / key metric vs. budget | Yes |
| Taste/design-bar score | vision critique (+ optional critic) | **No — self-graded** |

The first six are trustworthy. The seventh is the soft one — keep it in the ledger but never let it be the *only* thing that moved.

## Step 1 — Build & test

- Run build, type-check, unit/integration tests. Quote the summary lines (exit code, "N passed").
- Treat the exit code and pass count as ground truth — they end debates a screenshot can't.

## Step 2 — See

- Launch the app (dev server, or serve the static build). Confirm it boots (HTTP 200 / no crash).
- **Headless-screenshot** the rendered UI at the representative viewport(s) the acceptance criteria name (e.g. mobile + desktop if both matter).
- **Judge via vision against the design bar** — not "is it pretty" but concrete, nameable issues: hierarchy, spacing rhythm, contrast, alignment, truncation/overflow, empty/loading/error **state coverage**, focus visibility. Write each as a defect, not a vibe.
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

- Consolidate everything into one **defect list**, each entry carrying:
  - **Severity** — Blocker / High / Medium / Low (same tiers as `deep-dive`).
  - **The acceptance criterion it blocks** (or the objective signal it failed).
  - A one-line, checkable description — points at a signal or a criterion, never "feels off."
- **Optional different-model critic:** spawn a critic on a *different* model. Give it **only** the screenshots + acceptance criteria + design bar — *not* the builder's rationale (blind review). Ask for a blind score and concrete defects. Merge its defects in. Honest limit: it blunts the monoculture but is still a model, not a user.
- Pick the **top few defects** (highest severity, most criteria unblocked) for this rebuild. Don't try to fix everything at once.

## Step 6 — Rebuild

- Fix **only** the selected top defects. Don't refactor adjacent code, rename things, or gold-plate (borrow `prompt-pack`'s scope discipline — a tight diff is reviewable; a sprawling one isn't).
- Re-enter at Step 1. Re-run the full ledger so the delta is measured, not assumed.

## Closing an iteration — apply the stop-condition

After the rebuild + re-measure, check the stop-condition (in `SKILL.md`): **PASS / PLATEAU / BUDGET / BLOCKED.** If one fires, stop and report; otherwise loop again. Remember BUDGET (default N=5) is the hard backstop that guarantees termination.

## Handling a "cannot see" defect mid-loop

If a defect needs a signal the loop can't produce — content correctness against an external oracle, a genuine taste call, a real-world/market test — do **not** guess a fix or hide it behind a clean screenshot. Log it as **BLOCKED**, name exactly what would settle it and who must do it, and emit it as a human gate. That is a complete, honest outcome — the loop did its job by finding the edge of its own competence.

## What to report at the end

- The **stop-condition** that fired.
- The **before/after ledger** (the objective signals from iteration 0 to the last) — the concrete craft-delta.
- The **open defects** handed off, split into *machine-checkable but deferred* vs. *the cannot-see tail a human must finish.*
- Any signal **not run** (and why), reported as not-run — never as passed.
