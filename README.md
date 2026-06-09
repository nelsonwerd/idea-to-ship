# idea-to-ship

**Three composable Claude Code skills that take an idea from *fuzzy* → *validated* → *sequenced build* → *shipped*.**

Most "build with AI" workflows skip the hard half. They jump straight to code — and skip *deciding what's actually worth building*, *validating it honestly*, and *planning the build so it survives a context limit*. `idea-to-ship` is that missing front half: a small, sharp suite of Claude Code skills, reverse-engineered from real idea→ship journeys (including the mistakes those journeys made), so you don't repeat them.

```
   ideate              deep-dive             prompt-pack            (you)
 fuzzy idea  ──▶    pressure-test    ──▶    sequenced build   ──▶    execute
     ╰─────────▶  CONCEPT_BRIEF.md  ──────────▶  build prompts  ────────╯
```

They're three **separate** skills on purpose — sharp triggers, lean context, independent use — but they compose into one pipeline.

## The pipeline

1. **`ideate`** — turn a fuzzy idea (or an existing thing you want to improve) into a *locked* concept + roadmap, captured in one living `CONCEPT_BRIEF.md`. A blunt, honest co-founder: it forces a success metric and a kill criterion, refuses to spec before the concept survives an honest pressure-test, and hands off cleanly to `prompt-pack`.
2. **`deep-dive`** — the rigor engine `ideate` leans on for high-stakes validation (and that you can run directly on any codebase, strategy, design, or research question): parallel specialist agents → synthesis → adversarial red-team → a plain-English verdict with honest 1–10 confidence.
3. **`prompt-pack`** — turn a settled concept into a sequence of self-contained, independently-shippable build prompts, each run in its own fresh chat so a big build never dies to a context/token limit. Also writes paste-ready handoffs to resume a dying chat or relay to another tool.

→ **execute** the prompts in Claude Code (or hand them to Codex / another tool).

## Quickstart — try one first

| If you want to… | Type this | You get back |
|---|---|---|
| Decide *what* to build | "I have an idea for *X* — help me decide if it's worth building." | `docs/CONCEPT_BRIEF.md` |
| Investigate something rigorously | "Do a standard design evaluation of *X*. Research-only." | `research/<topic>/` + an executive briefing |
| Turn settled scope into a build plan | "Make a prompt pack from `docs/CONCEPT_BRIEF.md`." (or "*X* is too big for one chat — make me a prompt pack.") | `docs/<TOPIC>_PROMPT_PACK.md` |

Each works standalone; run them in sequence for the full idea→ship pipeline.

## The three skills

### 🧭 ideate — *find & validate what to build*
Fuzzy idea → locked concept + roadmap. Two modes: **greenfield** (a new idea) and **refinement** (evaluate/improve an existing thing). Triggers: *"help me figure out what to build"*, *"is this idea any good"*, *"should I rebuild X"*, *"turn my idea into a plan"*. → [ideate.skill](https://github.com/nelsonwerd/ideate.skill)

### 🔬 deep-dive — *investigate it rigorously*
Multi-agent investigative analysis for questions that deserve more than a one-shot answer: audits, strategy/viability evaluations, design reviews, open research. Triggers: *"do a deep dive"*, *"thorough audit"*, *"evaluate this strategy"*, *"is this sound/safe"*. → [deep-dive.skill](https://github.com/nelsonwerd/deep-dive.skill)

> **Note — `deep-dive` is token-hungry by design.** A full run fans out 4–6 specialist agents (each writing thousands of words), then synthesis, follow-up verification, a red-team pass, and a briefing — easily 10+ agent calls and tens of thousands of tokens for one analysis. That's the right trade for a high-stakes call, and a great fit on a **Claude Max** plan (or any setup where you're not token-constrained). On a smaller plan, reach for it deliberately: lean on its built-in *Scale heuristics* (2–3 lanes for narrow scope, skip the red-team for low-stakes work), or ask for a single-pass review instead. `ideate` and `prompt-pack` are far lighter.

### 📦 prompt-pack — *turn it into a shippable plan*
A big job → ordered, self-contained prompts you run one-per-fresh-chat, plus handoffs. Triggers: *"make a prompt pack"*, *"break this into phases"*, *"I'm running out of context"*, *"write me a handoff"*. → [prompt-pack.skill](https://github.com/nelsonwerd/prompt-pack.skill)

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

These follow the open **[Agent Skills](https://agentskills.io) standard**, so they work in **Claude *and* OpenAI Codex** — install all three at once as a **plugin** (Claude Code *or* Codex), or drop in individual skills. Quick pick by who you are:

| You are… | Tool | How |
|---|---|---|
| **Non-technical** | Claude app (claude.ai / desktop) | Upload each skill's **`.skill`** zip (in this repo root) via the app's **Skills / Capabilities** settings → [Agent Skills docs](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) |
| **Developer** | Claude Code | the plugin or manual copy — see Option 1/2 below |
| **Developer** | OpenAI Codex | install the bundled **plugin** (Option 3 below) — or copy each `skills/<name>/` into `.agents/skills/<name>/` (repo) or `~/.agents/skills/<name>/` (global) → [Codex skills docs](https://developers.openai.com/codex/skills) |
| **Anyone** | any agent | open any `skills/<name>/SKILL.md` — it's just instructions |

### Compatibility by skill × runtime

The skill *format* is portable; some *runtime* features (parallel subagents, progress tools, web access) are Claude-Code-native. Each skill still runs everywhere — degraded cells lose mechanics, not method.

| Skill | Claude app | Claude Code | OpenAI Codex | Generic agent |
|---|---|---|---|---|
| **ideate** | Strong — concept work; brief kept inline when there's no file tree | **Best** | Strong — with a local workspace for the brief | Works — full method; needs somewhere to keep the brief (file or inline) |
| **deep-dive** | Works (degraded: no repo/file access; lanes run serially) | **Best** — parallel subagents + web | Strong — same lanes run **serially**, same rigor; external claims labeled *unverified* if no web | Works (degraded: serial lanes, local-only; label external claims *unverified*) |
| **prompt-pack** | Limited — best for high-level planning/handoffs; weak without repo access | **Best** | **Best** — reads `AGENTS.md`, full repo access | Works — with repo/file access |

<sub>Menu names/commands drift between versions — linked docs are the source of truth. Claude-specific bits (the `plugin.json` bundle format; deep-dive's parallel-subagent orchestration) don't all carry to Codex; the **methodology is fully portable** — `deep-dive` ships an *Environment & fallbacks* section that runs the same lanes serially when subagents aren't available.</sub>

### Option 1 — manual (simplest, always works)
```bash
git clone https://github.com/nelsonwerd/idea-to-ship.git
mkdir -p ~/.claude/skills
cp -r idea-to-ship/skills/* ~/.claude/skills/
```
Then use them directly — `/ideate`, `/deep-dive`, `/prompt-pack` — or just let them auto-activate when a request matches. No restart needed.

### Option 2 — as a Claude Code plugin (all three together, namespaced)
```bash
/plugin marketplace add nelsonwerd/idea-to-ship
```
Then open `/plugin`, find **idea-to-ship**, install it, and run `/reload-plugins`. The skills become available as `/idea-to-ship:ideate`, `/idea-to-ship:deep-dive`, `/idea-to-ship:prompt-pack` (and auto-activate on relevant requests).

> **Already installed these individually?** They'll still work. For the manual method, remove the old folders first to avoid duplicates: `rm -rf ~/.claude/skills/{ideate,deep-dive,prompt-pack}`. (The plugin version is namespaced, so it won't collide.)

### Option 3 — as an OpenAI Codex plugin (all three together)

The repo is **also a Codex plugin** (`.codex-plugin/plugin.json`) that bundles the same three skills. Register it as a marketplace, then install:
```bash
codex plugin marketplace add nelsonwerd/idea-to-ship
```
Then run `/plugins` in Codex, find **idea-to-ship**, and select **Install**. The skills become available as `@ideate`, `@deep-dive`, `@prompt-pack` (and Codex invokes them on matching requests). In the **Codex app**, open **Plugins** in the sidebar to add and install it.

<sub>Codex's plugin flow is newer and still evolving — the [official Codex plugins docs](https://developers.openai.com/codex/plugins) are the source of truth for the exact command/UX. No-plugin fallback (always works): copy `skills/<name>/` into `.agents/skills/` (per-repo) or `~/.agents/skills/` (global), as in the table above.</sub>

> **Updating:** both plugins are versioned (currently **1.1.0**). In Claude Code, run `/plugin update` for the latest; in Codex, re-install from the plugin browser. Heads-up: Claude only fetches a plugin update when the **version changes** — so this `1.1.0` bump is what delivers the current skills to anyone already on `1.0.0`.

## Why this exists

Each skill encodes a specific failure mode it prevents — learned the hard way from real builds:
- **ideate** stops you from *speccing before validating* and from *building with no success metric or kill criterion*.
- **deep-dive** stops you from *trusting a confident one-shot answer* on a high-stakes call — it red-teams its own conclusions and cites current sources.
- **prompt-pack** stops a big build from *dying to a context limit* or *drifting* mid-flight.

Small, sharp, composable tools — not one monolith. That's the point.

## Standalone homes

This repo bundles copies of the three as a suite; their canonical standalone repos are:

| Skill | Repo |
|---|---|
| ideate | https://github.com/nelsonwerd/ideate.skill |
| deep-dive | https://github.com/nelsonwerd/deep-dive.skill |
| prompt-pack | https://github.com/nelsonwerd/prompt-pack.skill |

## License

MIT © 2026 Drew Nelson
