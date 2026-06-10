# Modes Guide — greenfield vs refinement

`ideate` runs in one of two modes, detected in the first exchange. Both funnel into the same pressure-test, convergence, and CONCEPT_BRIEF — they differ only in how they open and diverge.

---

## Greenfield — fuzzy idea → concept

**Triggers:** "I have an idea for…", "help me figure out what to build", "give me a few ideas for X", a blank-slate brain-dump, no existing artifact.

### Phase 0 — Frame (intake)
- Let the user **brain-dump freely** — don't force structure early; the unstructured rambles are where the real insight (and the wedge) usually hide.
- Capture: their **goal**, **hard constraints** (time, money, platform, skills), **soft success criteria**, and crucially their **insider edge** — what do they know or have that others don't?
- **Set the selection rubric before generating anything:** agree on what would make an idea worth pursuing *for this person* (e.g. "solves a pain I personally have", "reachable first customers", "defensible wedge"). You'll judge options against it.
- **Force the two anchors:** a real success metric and a kill criterion. Most people skip these; you don't.
- Write the stub `CONCEPT_BRIEF.md`.

### Phase 1 — Explore (diverge wide)
- Generate **5–7 options in ONE uniform, comparable template** so they can be judged side by side. A good per-option template: *Who it's for (and who pays, if it's commercial) · The pain · What it does · Why it wins · MVP in a sentence · Monetization or sustainability model · Build effort.*
- **Rank the options against the user's stated rubric**, with a clear top pick and your reasoning.
- Ask the **founder-market-fit question explicitly:** "Which of these do you have *personal pain* or insider insight into?" — that filter, more than the ranking, usually selects the lane.
- Then **mine the user's lived reality:** "Walk me through how you (or your target) actually do this today, in detail — ramble freely." Reframe the anecdote into the wedge. (Real wedges and target segments far more often come from the user's own workflow than from the generated menu.)

Divergence here is genuinely wide — this is the one phase where blue-sky generation earns its place. (Don't over-engineer it, though; the goal is a chosen, well-reasoned direction, not a giant idea catalog.)

---

## Refinement — existing thing → evaluate / improve

**Triggers:** "evaluate this", "should I rebuild / refactor X", "improve my app", "here's my repo, assess it", "where are we really at?" Note: this is the **more common real entry point** — people re-open the idea space repeatedly mid-project. Treat re-entry as first-class; don't assume a cold start. On re-entry, first **load any existing `CONCEPT_BRIEF.md` (in `docs/`, else the repo root) and continue editing it** — don't start over.

### Phase 0 — Open with the four-lens assessment
Run these in order, and **give your independent read before asking for the user's own notes** (anti-anchoring):
1. **What is it / what does it do?** — demonstrate real comprehension of the existing thing first.
2. **Viability** — should this exist? Is it a business / worth continuing? Honestly.
3. **Quality** — is the thing actually good (code, UX, product)? Where's it weak?
4. **Honest take** — your real opinion, not a description. What would you do?

Then capture the **parity contract** and **current-state (done vs not-done)** into the brief (see template).

### Phase 1 — Explore (narrow, decision-oriented)
Divergence in refinement is *not* blue-sky. It's a small set of **strategic forks**, each as a 2–3-option set with honest pros/cons and a recommended default:
- Tweak vs refactor vs **rebuild** (be honest when the user's cheap path won't get them what they want — naming "this is a rebuild, not a refactor" early saves enormous waste).
- Big-bang vs **staged** migration.
- Which slice to prove first.

### The golden-master discipline (refinement's defining rule)
When improving or rebuilding something that already works, **the existing thing is the spec — the "golden master."** The dominant failure is *drifting away from it* during a rebuild and only noticing far too late. So:
- Author an **enforceable parity contract**: an inventory of existing screens/flows/endpoints + the hand-tuned details the user cares about + an explicit, *testable* "done relative to the current thing." Not vague prose — something later phases can be checked against.
- Run a **pre-mortem**: what will silently break or drift, and how will we detect it (screenshot diffs, golden-master comparison, small surgical changes vs sweeping rewrites)?
- Prefer **lock-the-spine-defer-the-rest** hard here: a giant migration roadmap locked before validating the first slice is the classic meltdown.

---

## Where the modes converge

Both modes lead into the **same Phase 2 pressure-test, Phase 3 convergence, and the same CONCEPT_BRIEF + prompt-pack handoff.** The honesty contract, the success-metric/kill-criterion forcing functions, the scope-fence, the lock-the-spine discipline, naming, and the handoff are identical. Refinement just carries two extra brief sections (parity contract, current-state) and opens with the four-lens assessment instead of wide divergence.

If you're unsure which mode you're in: is there an existing artifact (repo, app, draft) that the work must respect and not regress? If yes → refinement. If it's a blank slate → greenfield.
