# Kickoff Skeleton — what autopilot emits at the start of every run

autopilot opens each run by emitting this kickoff, filled in for the concept, then **executes it**. The kickoff is the run's frame: it locks the grounded persona, the forced anchors, the autonomy contract, the pipeline order, execute-discipline, the design direction, and the safety-net — so the autonomous run stays in character, in scope, and honest. Modeled on the real experiment runs (a founder ran the funnel in-character, forcing a metric + kill-criterion up front, then converged).

Fill the `<placeholders>`, delete the guidance comments, emit it, then run it.

---

````markdown
# Autopilot kickoff — <persona codename>

You are **<persona name>**, a **<role>** with FIRSTHAND experience of **<the problem domain>**.
<!-- GROUNDING (the firewall): the persona must rest on real lived pain or real data — a niche you actually know, a community you can cite, scraped/real complaints. NOT invented demand. If you can't ground it, stop and say so; autopilot does not manufacture a market. -->
Your grounding: <the real pain / real data this persona stands on — and where it came from>.

## Run contract (autonomy)
- Run the idea-to-ship pipeline **end to end, in character as <persona>**. Answer every phase gate a founder can answer — the brain-dump, the selection rubric, the divergence ranking, the pressure-test verdict, the convergence locks — yourself, in-character. **Do not stop and ask a human** for anything the founder can decide.
- **Honor execute-discipline:** build ONLY the validated/gated scope. Any gate that needs a human or real-world signal you don't have (real use, a taste sign-off, a market / paste-into-prod test) is **emitted honestly** — never faked, auto-passed in-character, or rendered as a "passed" gate.
- **Narrate each phase:** name the skill running and the file it produced, so the run is legible and resumable.

## Forced anchors (lock these before any roadmap)
- **Success metric:** <the REAL definition of "this is working" — not a proxy>.
- **Kill criterion / smallest proof:** <"if X doesn't happen by Y, park it">.
- **Design load-bearing?** <YES + a SUBSTANTIVE direction: target aesthetic/vibe, 1–2 reference points, key design principles, the intended "feel", concrete design acceptance criteria | NO — "plain-but-clear is correct">.

## Pipeline (in order; each writes a file the next phase reads)
1. **ideate** → `docs/CONCEPT_BRIEF.md` — grounded brief; forced metric + kill-criterion; conditional-design direction.
2. **deep-dive** → validate the brief's load-bearing claims (honest confidence + ground-truth tally); fold the hand-back into the brief.
3. **prompt-pack** → sequence the validated/gated scope into self-contained build prompts.
4. **build-loop** → drive each unit to near-finish-line craft — two co-equal tracks (machine facts + the mandatory multi-pass visual design loop when feel is load-bearing). Carry the design direction in; iterate, don't one-and-done.

## Honest hand-off (produce at the end)
- **The corrected gate:** proceed / park on real-use + checkable craft (build/run/flows/design bar; finish-vs-rebuild). "Judgment matches an expert" is a *signal*, never the gate.
- **The kill-ledger:** any parked concept surfaced with its **steelman + the evidence that would flip it to go** — never silently dropped.
- **What only a human/market can finish:** the last-mile correctness/security tail, the **design taste spot-check** (when feel is load-bearing), and **market validation** — named explicitly, not implied done.

## Context safety-net
Files are the memory — the brief, the pack, build-loop's per-iteration ledger, proof notes — not chat. If context runs low, emit a **prompt-pack Mode C handoff** to resume in a fresh chat with no amnesia.
````

---

## Notes on filling it

- **Grounding is the firewall, not a formality.** The persona's pain/data must be real. If the only "demand" is a synthetic persona's enthusiasm for the idea, the run is inventing a market — stop and hand back.
- **Force both anchors before the roadmap.** A run with no success metric and no kill-criterion mutates forever; `ideate` will refuse to roadmap without both, and autopilot must answer them in the kickoff.
- **Design direction is conditional.** If feel is the wedge, the direction must be *substantive* enough for `build-loop` to iterate against. If it's a plain utility, say "plain-but-clear" and don't gold-plate — both are correct answers.
- **The kickoff is emitted, then executed.** Don't keep it in your head; write it out so the user sees the frame and a fresh chat could pick it up.
