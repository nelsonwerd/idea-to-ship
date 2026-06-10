# Acceptance Criteria — the target the loop runs toward

The loop is only as honest as its target. With no criteria, iteration either thrashes forever (nothing says "done") or stops on a whim. So before the first build → see → exercise cycle, **lock a checkable target.** This file is how.

## What makes a criterion good

A usable acceptance criterion is:
- **Binary** — it either passes or it doesn't; no "mostly."
- **Checkable by machine or by a scripted flow** — a `bash` command, a headless assertion, an `axe` count, a Lighthouse metric can settle it. If settling it needs a human's eye or judgment, that's a *human gate*, not a loop criterion (see the tail, below).
- **Tied to the product's promise** — it tests the thing that makes this build worth shipping, not an incidental detail.
- **Stated before you build toward it** — a criterion invented after the fact to match what you happened to build is theater.

Bad criterion: *"the UI looks polished."* (Not binary, not machine-checkable.)
Good criteria: *"the export flow produces valid output for all four input types"*, *"every interactive control changes its exported result"*, *"0 axe violations at impact ≥ serious"*, *"LCP < 2.5s on the main view."*

## Where criteria come from

- **A `CONCEPT_BRIEF.md` (from `ideate`)** — its success metric, Aha/activation moment, and Scope IN map almost directly onto acceptance criteria. The "Design load-bearing?" field tells you whether you need a design bar.
- **A prompt-pack prompt** — its "Verification" matrix and "What MUST NOT change" are acceptance criteria in another vocabulary; reuse them.
- **Otherwise, derive them** from the core promise: what must be true for a user to get the value, end to end?

## A criteria sheet — the four buckets

Organize the target into buckets the loop can run directly:

1. **Builds & passes** — build exits 0; type-check clean; all unit/integration tests pass (state the baseline count).
2. **Flows work** — name the core flows (the few that carry the promise) and the end-to-end assertion for each — *including control→output coupling* (every control that claims to drive an output actually changes it).
3. **Checks pass** — a11y bar (e.g. "0 axe violations at impact ≥ serious"), perf budget (a Lighthouse metric/score), no broken assets/links, clean console (no errors).
4. **Design bar** — *conditional* (next section).

## The design bar — only when feel is load-bearing

Carry `ideate`'s conditional-design forcing-function straight through:

- **If experience/feel is load-bearing** (it *is* the wedge — a motion tool, a delightful consumer app): write an explicit design direction + design acceptance criteria, and make them **as checkable as you can** — a reference comp to match, an explicit spacing scale and type hierarchy, contrast ratios, required empty/loading/error states, motion specifics. Compose `frontend-design` for the direction. The more you can turn taste into a named, checkable rule, the less the loop has to lean on self-graded vision.
- **If it isn't** (a plain utility, an internal tool): the bar is **plain-but-clear** — legible, consistent, no broken layout. **Say so explicitly and don't gold-plate it.** Over-investing polish in a utility is its own failure.

Even with a sharp design bar, the residue of taste the loop self-grades stays soft (see the SKILL's bounds) — that's what the optional different-model critic and a human spot-check are for.

## Name the tail you can't check — up front

Some of "done" is genuinely not machine-checkable. Name it *before* you loop, so it's a planned hand-off and not a silent gap:
- **Content correctness against an external source of truth** the loop doesn't hold (a dictionary, a pricing table, a legal rule).
- **Subtle correctness/security** no test exercises.
- **Real taste** beyond ugly/broken, and **whether anyone wants it** (market) — always out of scope.

These become **human gates**, not loop criteria. The loop's honest job is to drive every machine-checkable criterion to pass and then hand off the tail with a clear statement of what remains and who must settle it — never to fake a pass on something it couldn't actually check.

## Mini-example — a single-page tip-split calculator (a plain utility)

- **Builds & passes:** `npm run build` exits 0; `npm test` 8/8 pass.
- **Flows work:** enter bill + tip% + party size → per-person total updates correctly (assert the math headless); changing any input changes the output (coupling); handles 0/empty/huge inputs without NaN or crash.
- **Checks pass:** 0 axe violations ≥ serious; no console errors; loads < 1s.
- **Design bar:** *not load-bearing* — plain-but-clear; legible, mobile-first, no broken layout. Do not gold-plate.
- **Tail (human gate):** none on content; "is this nicer to use than splitting in your head?" is a real-use question, out of the loop's scope.

That sheet is enough to run the loop to a confident PASS — and equally to know exactly when to stop.
