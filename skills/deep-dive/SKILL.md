---
name: deep-dive
description: >-
  Rigorous multi-agent deep-dive analysis for complex investigative tasks —
  auditing codebases, evaluating strategies or systems, validating designs, doing
  open-ended research. Deploys 4–6 specialist agents in parallel across
  distinct lanes, then synthesis, then adversarial red-team review, then
  optional patching — producing structured markdown research files plus a
  plain-English executive briefing with honest 1–10 confidence ratings. ALWAYS
  invoke when the user says any of "deep dive", "thorough audit", "rigorous
  analysis", "comprehensive review", "audit this codebase", "analyze the
  strategy", "evaluate this design", "review this thoroughly", or "research
  deep dive". Also invoke proactively for any open-ended investigative task
  involving a codebase, strategy, system design, or research question that
  warrants 30+ minutes of structured analysis — even when the user doesn't use
  these exact phrases.
---

# Deep-Dive Multi-Agent Analysis

This skill orchestrates rigorous multi-lane analysis for complex investigative tasks. It deploys specialist subagents in parallel, synthesizes their findings, runs adversarial red-team review, applies fixes, and delivers a structured evidence package plus a plain-English executive briefing.

## When to use this

**Strong triggers** — invoke without asking:
- "Do a deep dive on [X]"
- "Thorough audit of [Y]"
- "Rigorous analysis of [Z]"
- "Comprehensive review"
- "Audit this codebase"
- "Evaluate this strategy / design"
- "Research [open question] thoroughly"

**Softer triggers** — invoke if the task is investigative and non-trivial:
- The user describes a codebase or system and asks for "thoughts" or "objective analysis"
- The user has built something and asks whether it's correct/safe/sound
- The user asks open-ended research questions that span multiple domains
- The user is making a high-stakes decision and needs structured evidence

**Do NOT use this for:**
- Single-file code review (use direct Read + analysis)
- Simple factual questions (one WebSearch is sufficient)
- Tasks the user has scoped tightly (e.g., "fix this bug" — just fix it)
- Tasks under ~15 minutes of investigative work (overhead exceeds benefit)

When in doubt, prefer to invoke. The skill is designed to scale down gracefully (3 lanes for narrow scope, 6 for broad scope).

## The four scope variants

Identify which variant fits, then read the matching reference file:

| Variant | Trigger pattern | Reference |
|---|---|---|
| **Codebase audit** | "audit this codebase", "is this safe to ship", "review this build" | `references/codebase-audit.md` |
| **Strategy / system evaluation** | "evaluate this strategy", "does this approach actually work", "is this sound" | `references/strategy-evaluation.md` |
| **Research deep dive** | "research [open question]", "deep dive on [topic]" | `references/research-deep-dive.md` |
| **Design evaluation** | "evaluate this design", "is this the right approach", "review this plan" | `references/design-evaluation.md` |

If the user's request spans multiple variants (e.g., "audit this pricing-engine codebase") combine lanes from both reference files — the skill is composable. A codebase audit of a system with non-trivial decision logic uses codebase-audit lanes plus strategy/system-evaluation lanes for the logic itself.

If the scope is genuinely ambiguous, ask **one or two** clarifying questions before deploying agents. Don't ask a barrage. Examples:
- "Pure research mode (no code changes) or are fixes in scope?"
- "Focus on correctness, performance, or both?"

After the clarification, proceed.

## The execution loop

Every deep dive runs this loop. Adapt depth based on scope, but don't skip phases.

### Phase 0: Setup (do first, every time)

1. Mark a session chapter with `mcp__ccd_session__mark_chapter` using a clear title (e.g., "Payments service codebase deep dive").
2. Create a research output directory. Default: `research/<topic>/` at repo root, or wherever the user's existing conventions point. If a `research/` directory already exists, use it.
3. Set up task tracking with `TaskCreate` — one task per phase, then specific tasks for each specialist agent. This gives the user a progress signal during the long parallel work.
4. Do a 30-second initial sweep: list files, read README if present, check git log. This grounds the agent prompts in reality.

### Phase 1: Parallel specialist deployment

Deploy 4–6 specialist agents **in a single message** (multiple Agent tool calls in one block) so they run truly in parallel. Each gets:

1. **Clear lane and anti-duplication.** State the agent's scope. State what other agents are covering ("Five other agents are reviewing X, Y, Z — stay in your lane").
2. **Specific deliverables.** Markdown file path, target word count (typically 2500–6000), heading structure.
3. **Source verification requirement.** For any load-bearing numerical claim, require at least 2 independent sources. Use WebSearch / WebFetch aggressively.
4. **Severity tiers for findings.** Blocker / High / Medium / Low / Note. Force the agent to categorize.
5. **File:line references** when reviewing code.
6. **Confidence rating.** End-of-turn 250-word executive summary + honest 1–10 confidence rating with reasoning.
7. **No code changes** by default (the skill defaults to pure research mode; only the user's explicit authorization unlocks code edits).

See `references/specialist-prompt-template.md` for the exact prompt template every specialist receives.

After dispatching, wait for all to return. Don't do other work in foreground — the agents are the work.

### Phase 2: Synthesis

Deploy a single synthesis/oversight agent that:
- Reads ALL specialist outputs in full
- Cross-checks load-bearing claims against each other
- Resolves contradictions (re-reading actual files if needed)
- Identifies gaps the specialists missed
- Produces a unified deliverable (design blueprint, audit report, etc.)
- Lists prioritized recommendations with file:line refs
- Provides honest combined confidence and clearly states what would change it

The synthesis agent should also flag **load-bearing claims that need follow-up verification** — single-sourced numerical claims, uncited assertions, surprising magnitudes. The orchestrator (you) decides whether to commission follow-up specialists.

### Phase 3: Follow-up verification (commission as needed)

If synthesis flagged 2–6 critical claims requiring deeper verification, deploy **focused single-claim verification agents** in parallel. Each gets:
- ONE specific claim to verify or falsify
- Specific data sources to check
- Verdict format: verified / partially verified / unverifiable
- Recommended revised effect size if claim fails

This is what separates a rigorous deep dive from a quick analysis. The synthesis agent's first pass is necessarily based on what specialists reported; follow-up verification catches inherited errors.

### Phase 4: Red-team review

Deploy an adversarial reviewer agent that:
- Reads the synthesis (and any patches)
- **Tries to break it.** What load-bearing claims weren't verified? What acceptance criteria admit trivially-passing implementations? What blind spots exist? What did the synthesis assume that isn't true?
- Produces a Blocker / High / Medium / Low list with specific file:line refs
- Recommends specific surgical fixes
- Ends with honest confidence that the deliverable is safe-to-ship

Red-team is non-negotiable for high-stakes outputs (anything touching money, safety, or production systems). Skippable only for low-stakes research.

### Phase 5: Patching (when red-team finds Blockers/Highs)

If red-team produces 5+ recommended edits and they're mostly mechanical (1–5 lines each), deploy a focused patching agent that applies them all, then reports verification (grep counts, word-count delta, ambiguities).

If red-team finds structural problems, return to Phase 2 with the new findings.

### Phase 6: Executive briefing

Write a final user-facing markdown file (`NN-executive-briefing.md`) that:
- Leads with TL;DR and the honest verdict (not buried in section 7)
- Acknowledges where the work shines genuinely
- States the critical findings ranked by severity, with file:line refs
- Provides realistic confidence with explicit reasoning (e.g., "5/10 — components individually sound, combined system unvalidated")
- Translates technical findings into plain English the user can act on
- Ends with a prioritized action list (Tier 0 / 1 / 2 / 3) and a clear "should you proceed" answer

The briefing supersedes the synthesis where corrections from follow-up verification or red-team changed conclusions.

## Universal rules across all phases

### Honest confidence

Every output ends with 1–10 confidence with explicit reasoning. Norms:
- **1–3**: known-broken or insufficient evidence
- **4–5**: plausible but unvalidated; coin-flip on real-world success
- **6–7**: documented edge / clean implementation; favored but not guaranteed
- **8–9**: rare; reserved for thoroughly-validated work
- **10**: essentially never; reserves for ground-truth fact

Avoid marketing-grade numbers. Reject the urge to round up. If two pieces of evidence point to 5/10 and one to 7/10, report 5/10 with the 7/10 source flagged as needing verification.

### Cross-reference vs. assert

For any load-bearing numerical claim:
- Single source = downweight; flag for follow-up verification
- 2+ independent sources confirming = accept
- Peer-reviewed or independently replicated result = accept with normal caveats
- Marketing tweet or vendor blog = treat as hypothesis, not evidence

When specialists report surprising numbers (e.g., "this approach hits a 95% success rate"), the orchestrator's instinct should be: "where did that number come from, and is the source itself a single post?"

### Severity tiers (use consistently)

- **Blocker**: must fix before any forward motion (e.g., going live, ship to prod)
- **High**: must fix before scaling or expanding scope
- **Medium**: should fix; not safety-critical
- **Low**: hygiene
- **Note**: observation, no action implied

### Plain-English deliverables

If the user is a non-developer (signaled by phrases like "I'm not a traditional developer", "I won't know what I'm looking at", or by their direct feedback), translate every finding into plain English in the executive briefing. Keep the specialist files technical for any future engineer who reads them; make the briefing readable by the operator.

### Pure research vs. code changes

Default to pure research mode. The skill produces markdown files only unless the user explicitly asks for code changes ("apply these fixes", "implement the recommendations"). When in doubt, ask: "Pure research, or are code changes in scope?"

This safety default exists because deep dives often run while another agent or developer is concurrently editing the codebase. Silent code edits create merge nightmares.

## File naming conventions

In the research output directory, name files sequentially with a clear topic:

```
research/<topic>/
├── 01-<lane-1>.md           Specialist 1 output
├── 02-<lane-2>.md           Specialist 2 output
├── ...
├── 0N-<lane-N>.md           Specialist N output
├── 0M-synthesis.md          Synthesis agent output
├── 0M+1-followup-A.md       Follow-up verification (if needed)
├── 0M+2-red-team.md         Red-team review
├── 0M+3-fixes-applied.md    Patching audit trail (if any)
└── 0Z-executive-briefing.md Final user-facing briefing
```

Letters distinguish follow-up verifications from main specialists (e.g., `06A-...md` for "follow-up to specialist 06").

This convention makes the evidence package navigable months later.

## Pitfalls to avoid

- **Don't deploy specialists serially.** They MUST go out in one batch (single message with multiple Agent calls). Serial deployment burns hours unnecessarily.
- **Don't skip red-team for high-stakes work.** The synthesis agent is biased toward the specialists' framing; only an adversarial reviewer catches blind spots.
- **Don't trust single-source numerical claims.** Always flag them for follow-up.
- **Don't bury the lede.** Executive briefings start with the verdict, not with section 1 of 12.
- **Don't accept "marketing-grade" numbers.** A "95% success rate" from a vendor's own blog is not the same as a result independently measured under realistic conditions.
- **Don't write code unless asked.** Default to research mode.
- **Don't over-engineer for tiny scope.** A 200-line codebase doesn't need 6 specialists. Use 2–3 lanes.

## Scale heuristics

Adjust depth based on scope:

| Scope | Specialists | Synthesis | Red-team | Follow-up | Briefing |
|---|---|---|---|---|---|
| Tiny (single file, narrow question) | 1–2 | Optional | Skip | Skip | Short summary |
| Small (few modules, focused question) | 3 | Yes | Yes (light) | If needed | Yes |
| Medium (full codebase or strategy) | 4–5 | Yes | Yes | Usually | Full |
| Large (multi-domain investigation) | 5–6 | Yes | Yes | Yes | Full + appendices |

The skill scales down gracefully — there's no minimum overhead.
