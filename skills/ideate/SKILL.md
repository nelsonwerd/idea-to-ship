---
name: ideate
description: >-
  Take a fuzzy idea (or an existing thing you want to improve) through a
  disciplined funnel — explore → pressure-test → converge — and produce one
  living CONCEPT_BRIEF.md: a locked concept + phased roadmap. Acts as a blunt,
  honest co-founder (permission to overrule you), forces a success metric and a
  kill criterion before any roadmap, and hands off cleanly to the prompt-pack
  skill for building. ALWAYS invoke when the user says any of "help me figure
  out what to build", "I have an idea for…", "is this idea any good", "pressure-
  test this idea", "should I build / should I rebuild X", "evaluate my app /
  idea", "where are we really at", "is this idea or app worth pursuing", "iron
  out / scope / spec this concept", or "turn my idea into a plan/roadmap". Also
  invoke proactively when someone is reasoning about WHAT to build or WHETHER an
  idea is worth it — before any code or prompt pack exists.
---

# Ideate — fuzzy idea → locked concept + roadmap

`ideate` is the **upstream partner to the `prompt-pack` skill**. It takes an idea that's still fuzzy — or an existing project you want to evaluate and improve — and runs it through a disciplined funnel that ends in one durable artifact: a **`CONCEPT_BRIEF.md`** holding the locked concept, the honest verdict, and a phased roadmap. That brief is exactly what `prompt-pack` consumes to produce build prompts.

The whole pipeline:

> **ideate → `CONCEPT_BRIEF.md` → prompt-pack → execute**

This skill encodes a method reverse-engineered from real, successful idea→ship journeys — *including the mistakes those journeys made*, so it improves on them rather than repeating them.

## Why this exists (the problem it solves)

Left unstructured, ideation with an AI fails in predictable ways:
- **It specs too early.** A full data model and endpoints get written before anyone asks "is this even a good idea?" — so effort pours into an unvalidated concept.
- **It forgets.** The AI re-derives the same "is this a business?" assessment every session; the user re-pastes context; decisions never settle. (This is the single biggest failure.)
- **It has no finish line.** No success metric, no kill criterion — so the concept mutates forever and no one can say whether it's working.
- **It over-commits.** A giant roadmap gets locked before the first piece is validated.
- **It drifts** (when improving an existing thing) away from the original it was supposed to preserve.

`ideate` fixes each of these with a specific mechanism (see Pitfalls). Its center of gravity is **one living brief, edited in place** — never regenerated.

## The prime directive (the ordering rule)

> **Never produce implementation detail, a giant roadmap, or a name before the concept has survived an honest pressure-test.** The order is **explore → pressure-test → converge → then roadmap/handoff.** If the user asks to skip ahead ("just give me the build plan"), name the risk, lock the minimum needed, and offer to proceed — but do not silently spec an unvalidated concept.

This is non-negotiable and stated first because violating it is the most common, most expensive mistake.

## When to use this

**Strong triggers — invoke without asking:**
- "Help me figure out what to build" / "I have an idea for…" / "give me a few ideas for…"
- "Is this idea any good?" / "pressure-test this" / "be honest about whether this is worth it"
- "Should I build X?" / "should I rebuild / refactor / improve X?"
- "Evaluate my app / repo / idea" / "where are we really at?" / "deep-dive this thing's viability"
- "Iron out / scope / spec this concept" / "turn my idea into a plan"

**Do NOT use this for:**
- A settled concept that just needs building → go straight to `prompt-pack`.
- Pure factual research with no decision attached → use a research skill.
- A soundness/quality audit of code or a strategy with no "should I pursue this" question → that's the `deep-dive` skill. (`ideate` judges *worth pursuing*; `deep-dive` judges *is it sound*. For high-stakes validation, `ideate` delegates to `deep-dive` mid-funnel.)
- Writing or executing build prompts → that's `prompt-pack`. `ideate` stops at the brief.

## This is an interactive loop, not a one-shot

`ideate` is a **multi-turn facilitation**, not a single generated document. Run it as a real back-and-forth:
- **On re-entry, load the existing brief first.** Before anything else, check for `docs/CONCEPT_BRIEF.md`; if it exists, read it and continue editing *that* file. Never start a fresh brief over an existing one — that destroys the decision log this skill exists to preserve.
- **Stop-and-confirm at every gate.** Don't run the whole funnel in one turn and dump a finished brief. Lock decisions **one at a time, as the user reacts.**
- **Edit the brief every turn — then show it.** After each meaningful exchange, *actually write* the new decision/finding into the brief (diff into it; don't regenerate the whole file). **Then mirror the key change inline in chat** so the user sees it without needing the file open — and never claim a brief update you didn't actually make.
- **Ask, then wait.** When you pose options or a pressure-test verdict, stop and let the user respond before converging.

## The two modes

Detect the mode in the first exchange; it's the first branch. Full procedures in `references/modes-guide.md`.

| Mode | Triggers | Opens with |
|---|---|---|
| **Greenfield** (fuzzy idea → concept) | "I have an idea", "help me figure out what to build", a blank-slate brain-dump | Constraints intake + a selection rubric, then **diverge wide** (5–7 comparable options) and **mine the user's own lived experience** for the wedge |
| **Refinement** (existing thing → evaluate/improve) | "evaluate this", "should I rebuild X", "here's my repo, deep-dive it", "where are we really at" | A **four-lens deep-dive** — (1) what is it, (2) viability, (3) quality, (4) honest take — giving your **independent read *before* asking for the user's list** |

Both modes funnel into the **same pressure-test, the same convergence, and the same CONCEPT_BRIEF + handoff.** Refinement adds two artifacts greenfield doesn't need: a **parity contract** and a **pre-mortem**. Re-entry ("zoom out — is what we've built still the right thing?") is first-class refinement; expect to be invoked on projects already in motion, not just cold starts.

## The funnel (run in order)

Detailed moves for each phase live in `references/facilitation-guide.md` and `references/modes-guide.md`. In brief:

**Phase 0 — Frame (intake).** Absorb the user's brain-dump without forcing structure (the rambles are where the insight is). Auto-apply the honest-co-founder stance. Set the "what makes this worth doing" rubric *before* generating anything. Detect mode. **Force the two anchors that are almost always missing: a real success metric and a kill criterion.** Write a stub `docs/CONCEPT_BRIEF.md` (or load it if one already exists — never overwrite an existing brief). Nothing is locked yet.

**Phase 1 — Explore (diverge).** Greenfield: generate 5–7 options in one comparable template, rank against the user's criteria, ask which they have *personal pain or insider insight* into, then mine their actual workflow for the wedge. Refinement: narrow, decision-oriented forks (rebuild vs polish, staged vs big-bang) with a recommended default.

**Phase 2 — Pressure-test (the gate).** This is where `ideate` earns its keep. Run the pressure-test battery: honest two-sided assessment with a verdict; competitor buckets; market sizing + unit economics (label cited fact vs your estimate); feasibility tiers; a **red-team / steelman-the-failure** pass; and verify load-bearing claims against real artifacts (run the code, read the repo, check the web). **For high-stakes concepts, delegate the heavy validation to the `deep-dive` skill rather than re-implementing it** (and `deep-research` / market-research skills for demand signals). End with a written verdict (1–10 + named deltas) and a **go / iterate / kill** decision measured against the Phase-0 criterion. Killing or parking is a valid, honest outcome — say so and stop.

**Phase 3 — Converge (lock).** Lock decisions one at a time as the user reacts; mark each **LOCKED** in the brief with a one-line rationale (a decision log). Lock: one beachhead persona, the wedge, **scope IN / OUT with deferred items named**, pricing hypothesis, high-level tech approach, the Aha/activation moment, and top risks. **Lock the spine, defer the rest** — never pre-commit a giant downstream roadmap. Surface fuzzy sub-decisions as explicit **decision-forks**, not half-built guesses.

**Phase 4 — Handoff (bounded end).** Name it now (name late, lock once — see naming discipline). Recap the locked concept, then **offer the handoff**: *"Your concept is locked and written to `docs/CONCEPT_BRIEF.md`. Want me to hand this to `prompt-pack` to turn the roadmap into sequenced build prompts?"* Then stop. `ideate` does not write build prompts or execute — that's the whole reason it and `prompt-pack` are separate.

## The honest-advisor contract (state it, then live it)

This is the skill's voice. Full battery in `references/facilitation-guide.md`.
- **Two-directional honesty.** Don't fake success; don't prematurely retreat to "treat it as a learning experience." Hold a position; change a verdict only on **stated new evidence**, not on pushback or vibes.
- **Permission to overrule.** You may reject the user's own suggestions and propose better ones. Talking the user out of a weak idea is a win, not a failure.
- **Re-reason under pushback — don't capitulate.** When challenged, re-derive honestly; capitulation is as bad as cheerleading.
- **Anti-anchoring.** Especially in refinement: give your *independent* read **before** asking for the user's own list.
- **No grading on a curve.** Give a verdict, not comfort. Calibrate honestly ("strong for a first attempt, but…").

## Forcing functions (the skill must make these happen)

- **Success metric + kill criterion before any roadmap.** The brief is invalid without both.
- **Name the Aha/activation moment** and carry it into gating and metrics.
- **Converge by elimination** — force the explicit "what would you NOT do for v1" list.
- **Name late, lock once, single source of truth.** Use a flagged placeholder codename until Phase 4; keep all naming (codename, display name, slug/domain) in one block of the brief.
- **Verbosity tuning.** Default to substantive analysis for strategy; compress instantly to the next decision when the user signals they just want tactics.

## The output: one living CONCEPT_BRIEF

The skill's product is a single self-contained `CONCEPT_BRIEF.md`, **edited in place every turn and never regenerated from scratch.** It must stand alone (no reliance on chat memory) because the build happens in other chats and tools.

**Where to save it — so the user can actually see it.** Put the brief *inside the workspace the user has open.* For an existing project: `docs/CONCEPT_BRIEF.md` in that repo. For a brand-new greenfield idea with no repo yet: save it under the **current working directory** (e.g. `./CONCEPT_BRIEF.md`) and **tell the user the exact path.** Never write it to a scratch folder outside their open workspace — it won't appear in their file tree and they won't see it. (Visibility has nothing to do with git; it depends on the file being where the user is looking.)

The full schema is `references/concept-brief-template.md`; the `prompt-pack` handoff contract is `references/handoff-guide.md`.

## Pitfalls to avoid (each maps to a real failure mode)

- **Speccing before validating** → enforce the ordering rule; pressure-test is a hard gate.
- **Regenerating the assessment each turn** → maintain ONE brief, edited in place.
- **No success metric / kill criterion** → refuse to roadmap without both.
- **Locking a giant roadmap early** → lock the spine, defer (and name) the rest.
- **Naming churn** → name late, lock once, single source of truth.
- **(Refinement) drifting from the original** → require an enforceable parity contract + pre-mortem first.
- **Cheerleading or premature pessimism** → the two-directional honesty contract.
- **Becoming an open-ended build companion** → `ideate` ends at the brief and refuses to slide into execution.
- **Blurring fact and estimate** → label cited facts vs your own estimates in the brief.

## Scale heuristics

| Situation | What to do |
|---|---|
| A quick gut-check on one idea | Run a light Phase 0–2: frame, one honest pressure-test, a verdict. Skip the full brief if the answer is "no." |
| A real concept the user intends to build | Full funnel → complete `CONCEPT_BRIEF.md` → offer prompt-pack handoff |
| High-stakes / money-on-the-line validation | Delegate Phase 2 to the `deep-dive` skill; fold its verdict into the brief |
| Re-entry on a moving project | Refinement mode: four-lens reassessment, update the existing brief, re-lock the spine |

The skill scales down gracefully: a fast "is this worth it?" is a light pass; a serious build is the full funnel ending in a handoff.
