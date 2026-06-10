# idea-to-ship

**Three composable Agent Skills — for Claude and OpenAI Codex — that take an idea from *fuzzy* → *validated* → *sequenced build* → *shipped*.**

Most "build with AI" workflows skip the hard half. They jump straight to code — and skip *deciding what's actually worth building*, *validating it honestly*, and *planning the build so it ships in safe, verifiable steps*. `idea-to-ship` is that missing front half: a small, sharp suite of Agent Skills (they run in **Claude** and **OpenAI Codex**), reverse-engineered from real idea→ship journeys (including the mistakes those journeys made), so you don't repeat them.

```
   ideate              deep-dive             prompt-pack            (you)
 fuzzy idea  ──▶    pressure-test    ──▶    sequenced build   ──▶    execute
     ╰─────────▶  CONCEPT_BRIEF.md  ──────────▶  build prompts  ────────╯
```

They're three **separate** skills on purpose — sharp triggers, lean context, independent use — but they compose into one pipeline.

**Who it's for.** Solo and small-team builders who tend to start coding before deciding *what's actually worth building* — working in **Claude** or **OpenAI Codex**. If you've shipped a feature nobody used, rebuilt something and lost the parts that worked, or watched a big change stall halfway, this suite front-loads the discipline that prevents it. Each skill also earns its keep alone. (`deep-dive` is token-hungry by design — see its note below; it shines most when you're not token-constrained, e.g. on a Claude Max plan.)

## The pipeline

1. **`ideate`** — turn a fuzzy idea (or an existing thing you want to improve) into a *locked* concept + roadmap, captured in one living `CONCEPT_BRIEF.md`. A blunt, honest co-founder: it forces a success metric and a kill criterion, refuses to spec before the concept survives an honest pressure-test, and hands off cleanly to `prompt-pack`.
2. **`deep-dive`** — the rigor engine `ideate` leans on for high-stakes validation (and that you can run directly on any codebase, strategy, design, or research question): parallel specialist agents → synthesis → adversarial red-team → a plain-English verdict with honest 1–10 confidence.
3. **`prompt-pack`** — turn a settled concept into a sequence of self-contained, independently-shippable build prompts: each does one unit, verifies itself, and leaves the app working before the next. Run them in one chat or spread across many — each prompt is self-contained, so any unit moves cleanly to a fresh chat whenever you want (or need) one. Also writes paste-ready handoffs to resume a chat or relay work to another tool.

→ **execute** the prompts in Claude Code (or hand them to Codex / another tool).

## Quickstart — try one first

| If you want to… | Type this | You get back |
|---|---|---|
| Decide *what* to build | "I have an idea for *X* — help me decide if it's worth building." | `docs/CONCEPT_BRIEF.md` |
| Investigate something rigorously | "Do a standard design evaluation of *X*. Research-only." | `research/<topic>/` + an executive briefing |
| Turn settled scope into a build plan | "Make a prompt pack from `docs/CONCEPT_BRIEF.md`." (or "*X* is too big for one chat — make me a prompt pack.") | `docs/<TOPIC>_PROMPT_PACK.md` |

Each works standalone; run them in sequence for the full idea→ship pipeline.

<details>
<summary><strong>See what you actually get back — a worked example</strong> (click to expand)</summary>

**`ideate` → `docs/CONCEPT_BRIEF.md`** *(excerpt — the locked concept + honest verdict, edited in place across the session, not regenerated):*

> - **Confidence verdict:** 7/10 — would move to 8 if 5 target users confirm the triage pain in interviews; down to 4 if they already tolerate shared Gmail.
> - **One-line promise:** Every client message handled by the right person, fast — without anyone owning a chaotic shared inbox.
> - **Beachhead persona:** 2–6 person creative/client-service studios. *(Secondary: solo freelancers — not v1.)*
> - **Success metric:** % of client messages with a clear owner + reply within 1 business day.
> - **Kill criterion:** If 5 target studios won't try a 2-week pilot, shelve it.
> - **Scope OUT / deferred:** Outlook, analytics dashboard, mobile app — each named with a one-line reason.
> - LOCKED: Layer on existing email, don't replace it — lowers switching cost (the wedge).

**`deep-dive` → `research/<topic>/NN-executive-briefing.md`** *(excerpt — verdict-first, after parallel specialists + an adversarial red-team):*

> **TL;DR.** Sound core; one blocker before you ship. **Confidence: 6/10 — 4 of 7 load-bearing findings externally verified (tests + `git`); the rest rest on model judgment.**
> - **[Blocker]** Currency rounding diverges between server and client — `pricing.ts:142` vs `format.ts:88`.
> - **[High]** No regression test covers the refund path; a silent change there ships unnoticed.
> - **Should you proceed?** Fix the blocker, add the refund test, then ship Phase 1.

**`prompt-pack` → `docs/<TOPIC>_PROMPT_PACK.md`** *(excerpt — one self-contained, independently-shippable unit; reads the brief above):*

> **P2 · Add per-currency rounding — Risk: HIGH**
> **Read first:** `CLAUDE.md`, `docs/CONCEPT_BRIEF.md`, `pricing.ts` — *verify file:line before editing.*
> **What MUST NOT change:** the public `formatAmount()` signature; existing USD output.
> **Verification:** `npm test pricing` + manual matrix (regression: USD unchanged · new: JPY 0-decimal, BHD 3-decimal).
> **When done:** report files changed + test results. **Do not commit — wait for explicit go.**

</details>

## The three skills

### 🧭 ideate — *find & validate what to build*
Fuzzy idea → locked concept + roadmap. Two modes: **greenfield** (a new idea) and **refinement** (evaluate/improve an existing thing). Triggers: *"help me figure out what to build"*, *"is this idea any good"*, *"should I rebuild X"*, *"turn my idea into a plan"*. → [ideate-skill](https://github.com/nelsonwerd/ideate-skill)

### 🔬 deep-dive — *investigate it rigorously*
Multi-agent investigative analysis for questions that deserve more than a one-shot answer: audits, strategy/viability evaluations, design reviews, open research. Triggers: *"do a deep dive"*, *"thorough audit"*, *"evaluate this strategy"*, *"is this sound/safe"*. → [deep-dive-skill](https://github.com/nelsonwerd/deep-dive-skill)

> **Note — `deep-dive` is token-hungry by design.** A full run fans out 4–6 specialist agents (each writing thousands of words), then synthesis, follow-up verification, a red-team pass, and a briefing — easily 10+ agent calls and tens of thousands of tokens for one analysis. That's the right trade for a high-stakes call, and a great fit on a **Claude Max** plan (or any setup where you're not token-constrained). On a smaller plan, reach for it deliberately: lean on its built-in *Scale heuristics* (2–3 lanes for narrow scope, skip the red-team for low-stakes work), or ask for a single-pass review instead. `ideate` and `prompt-pack` are far lighter.

### 📦 prompt-pack — *turn it into a shippable plan*
A big job → ordered, self-contained prompts, each shippable on its own, plus handoffs. Run them in one chat or across many. Triggers: *"make a prompt pack"*, *"break this into phases"*, *"I'm running out of context"*, *"write me a handoff"*. → [prompt-pack-skill](https://github.com/nelsonwerd/prompt-pack-skill)

## How they compose

- `ideate` produces a **`CONCEPT_BRIEF.md`** — the single artifact `prompt-pack` consumes to author build prompts. (ideate delivers the *what & why*; prompt-pack derives the *how* from your actual code.)
- `ideate` **delegates to `deep-dive`** when a concept needs heavy, current-sourced validation, and folds the verdict back into the brief.
- Each is also fully useful **on its own** — run `deep-dive` to audit a codebase, `prompt-pack` to sequence a refactor, `ideate` to gut-check an idea — without the others.

**Which skill for which question?** (they overlap on "evaluate / plan" — here's the precedence)

| The user is really asking… | Skill | Then |
|---|---|---|
| *What should I build? Is this idea worth pursuing?* | **ideate** | locks a `CONCEPT_BRIEF.md`; delegates heavy validation to `deep-dive` mid-funnel |
| *Is this correct / safe / viable / evidence-backed?* | **deep-dive** | returns a verdict + confidence; if it was validating a concept, hands a block back to `ideate` |
| *Scope is settled — sequence the build* | **prompt-pack** | reads `CONCEPT_BRIEF.md` if present; offers `ideate` first if the idea is unsettled |
| *Genuinely unclear* | ask one question | *viability direction, rigorous audit, or execution-planning?* |

These compose, but each also runs alone — install only the one you need.

## Install

These follow the open **[Agent Skills](https://agentskills.io) standard**, so they run in **Claude** and **OpenAI Codex** — install all three as a **Claude Code plugin**, drop them into your **Codex skills folder**, or copy individual skills anywhere. Pick your setup:

| You use… | Get all three by… |
|---|---|
| **Claude Code** — terminal, the **Code** tab of the Claude desktop app, [claude.ai/code](https://claude.ai/code), or a VS Code / JetBrains IDE | the **plugin** (Option 1), or a manual copy (Option 2) |
| **OpenAI Codex** — CLI, app, or IDE | copying the skills into `~/.agents/skills/` (Option 2) |
| **Claude chat** — the **Chat** tab of the desktop app, or [claude.ai](https://claude.ai) (non-coding use) | uploading each skill's **`.skill`** zip (in this repo root) under **Customize → Skills**. Best for `ideate`; `deep-dive` / `prompt-pack` want repo/file access. |
| **Any other agent** | pointing it at any `skills/<name>/SKILL.md` — it's just instructions |

<sub>**"Claude Code" and "Claude chat" both live in the one Claude desktop app** — its **Code** tab vs its **Chat** tab (plus their terminal / web / IDE surfaces). Plugins install in Claude Code only; the Chat tab takes uploaded skills under *Customize → Skills*.</sub>

### Compatibility by skill × surface

The skill *format* is portable; some *runtime* features (parallel subagents, progress tools, web/repo access) are richest in Claude Code and Codex. Each skill still runs everywhere — degraded cells lose mechanics, not method.

| Skill | Claude chat | Claude Code | OpenAI Codex | Other agents |
|---|---|---|---|---|
| **ideate** | Strong — concept work; brief kept inline when there's no file tree | **Best** | Strong — with a local workspace for the brief | Works — full method; keep the brief in a file or inline |
| **deep-dive** | Works (degraded: no repo/file access; lanes run serially) | **Best** — parallel subagents + web | Strong — same lanes run **serially** (lower cross-agent independence, so confidence is capped); external claims labeled *unverified* if no web | Works (degraded: serial lanes, local-only; label external claims *unverified*) |
| **prompt-pack** | Limited — best for high-level planning/handoffs; weak without repo access | **Best** | **Best** — reads `AGENTS.md`, full repo access | Works — with repo/file access |

<sub>Menu names/commands drift between versions — the linked docs are the source of truth. Claude-specific bits (the plugin manifest format; deep-dive's parallel-subagent orchestration) don't all carry to Codex; the **methodology is fully portable** — `deep-dive` ships an *Environment & fallbacks* section that runs the same lanes serially when subagents aren't available.</sub>

### Option 1 — Claude Code plugin (all three, namespaced)
```bash
/plugin marketplace add nelsonwerd/idea-to-ship-skills
/plugin install idea-to-ship@nelsonwerd
```
Or, in the desktop app's **Code** tab: click **+** next to the prompt → **Plugins** → add this marketplace and install. The skills become `/idea-to-ship:ideate`, `/idea-to-ship:deep-dive`, `/idea-to-ship:prompt-pack` and auto-activate on matching requests (run `/reload-plugins` if they don't appear).

> **Already have the skills installed manually?** They still work. To avoid duplicate names, remove the old copies first: `rm -rf ~/.claude/skills/{ideate,deep-dive,prompt-pack}`. (The plugin namespaces its skills, so it won't collide.)

### Option 2 — copy the skills (any tool, always works — and the Codex path)
```bash
git clone https://github.com/nelsonwerd/idea-to-ship-skills.git
cp -r idea-to-ship-skills/skills/* ~/.claude/skills/     # Claude Code
cp -r idea-to-ship-skills/skills/* ~/.agents/skills/     # OpenAI Codex
```
No restart needed in Claude Code (it detects them in-session); **restart Codex** to load skills dropped into `~/.agents/skills/` (Codex also scans a repo-level `.agents/skills/` if you want a skill in one project only). Then use them directly (`/ideate` in Claude; `/skills` or just describe the task in Codex) or let either tool auto-activate by description.

> **Updating:** the Claude plugin uses **commit-SHA versioning**, so every push to this repo counts as an update — no version bump to wait on. In **Claude Code**, run `/plugin update` (or turn on auto-update for the marketplace in `/plugin` → **Marketplaces**, and it refreshes at startup). For a **copied** install (Codex via `~/.agents/skills/`, or a manual Claude copy), `git pull` and re-copy.

## Why this exists

Each skill encodes a specific failure mode it prevents — learned the hard way from real builds:
- **ideate** stops you from *speccing before validating* and from *building with no success metric or kill criterion*.
- **deep-dive** stops you from *trusting a confident one-shot answer* on a high-stakes call — it red-teams its own conclusions and cites current sources.
- **prompt-pack** stops a big build from *drifting* or *leaving the app half-broken between steps* — and keeps each unit small enough to outlast a context limit if you hit one.

Small, sharp, composable tools — not one monolith. That's the point.

## Standalone homes

This repo bundles copies of the three as a suite; their canonical standalone repos are:

| Skill | Repo |
|---|---|
| ideate | https://github.com/nelsonwerd/ideate-skill |
| deep-dive | https://github.com/nelsonwerd/deep-dive-skill |
| prompt-pack | https://github.com/nelsonwerd/prompt-pack-skill |

## License

MIT © 2026 Drew Nelson
