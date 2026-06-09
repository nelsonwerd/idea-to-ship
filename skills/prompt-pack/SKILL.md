---
name: prompt-pack
description: >-
  Author and execute "prompt packs" — a big job broken into a sequence of
  self-contained, independently-shippable prompts, each run in its own fresh
  chat so a single change never dies to a context/token limit. Also writes
  paste-ready handoff briefings to resume a dying chat or relay work to another
  tool (e.g. Codex). ALWAYS invoke when the user says any of "make a prompt
  pack", "turn this into prompts", "break this into phases", "prompts I can run
  in separate chats", "I'm running out of tokens/context", "write me a handoff",
  "a prompt I can paste into a new chat", "this is too big for one chat", "build
  plan I can hand off", or "execute Pxx / phase X from the pack". Also invoke
  proactively when a requested change is too large or too risky to finish safely
  in one session and should be decomposed into ordered, verifiable steps.
---

# Prompt-Pack — Sequenced, Self-Contained Prompts for Big Work Across Chats

A prompt pack turns one large, risky job into an ordered set of **small, self-contained prompts**. Each prompt is pasted into a *fresh* chat, does exactly one shippable unit of work, verifies itself, and stops for review. The pack file lives in the repo and is the durable source of truth — so work survives context limits, spans multiple chats and tools, and never leaves the app half-broken.

This skill encodes a battle-tested format (refined across many real packs) so every pack you author is consistent, safe, and resumable, and every pack prompt you execute follows the same disciplined loop.

## Why this exists (the problem it solves)

- **Context/token limits kill long jobs.** A 900-turn chat runs out of room mid-task; the next chat has amnesia. Packs make each unit fit comfortably in one fresh chat.
- **Big changes are risky.** Decomposing into ordered, independently-shippable steps with explicit guardrails keeps the app working between every step.
- **Work relays across chats and tools.** A self-contained prompt can go to a new Claude chat or be pasted into another agent (e.g. Codex via `AGENTS.md`) with no loss.
- **Plans evaporate.** Writing the pack to a file in `docs/` means a future session — or a confused one — can be pointed at the source of truth.

## When to use this

**Strong triggers — invoke without asking:**
- "Make a prompt pack for [X]" / "turn this into prompts" / "break this into phases"
- "Give me prompts I can run in separate chats / one at a time"
- "I'm running low on tokens/context — write me a handoff for a new chat"
- "Write a prompt I can paste into a fresh chat to continue this"
- "Execute P3 / phase C from the pack" (execution mode)

**Softer triggers — invoke when the work is large or risky:**
- A requested change spans many files / phases and won't finish safely in one session
- The user wants to ship incrementally with verification gates between steps
- Work needs to hand off to another tool or person

**Do NOT use this for:**
- A small change that fits comfortably in the current chat — just do it
- A one-line fix or quick question
- Pure research with no shippable units (use a research/deep-dive skill instead)

## The three modes

Identify which mode the user needs, then follow the matching reference.

| Mode | Trigger | Reference |
|---|---|---|
| **A — Author a pack** | "make a pack", "break this into prompts/phases" | `references/authoring-guide.md` + `references/pack-template.md` |
| **B — Execute a pack prompt** | "run P3", "execute phase C", or the user pastes a pack prompt | `references/execution-guide.md` |
| **C — Handoff briefing** | "I'm out of context", "write a handoff", "prompt for a new chat" | `references/handoff-guide.md` |

A handoff (Mode C) is just a degenerate one-prompt pack: the same self-contained, read-first, state-snapshot discipline, sized for a single resume.

## Core principles (the non-negotiables that make packs work)

These hold across all three modes. They are the difference between a pack that ships safely and a pile of prompts that drift.

1. **Self-contained.** Every prompt assumes the executing chat has *zero* memory of the chat that authored it. It carries its own context, file list, acceptance criteria, and guardrails. If a future session would have to ask "what were we doing?", the prompt has failed.
2. **One prompt = one chat = one shippable unit.** Don't stack prompts in a chat; don't skip ahead. Each unit leaves the project in a working, shippable state.
3. **Read-first protocol.** Every prompt opens by reading the project's durable context (auto-memory, `CLAUDE.md` / `AGENTS.md`, named companion docs) and **verifying file:line references against current code before editing** — the codebase moves between when a pack is written and when a prompt runs.
4. **Risk-rated with explicit guardrails.** Each prompt states a risk level and a **"What MUST NOT change"** list. This is what stops scope creep and silent regressions.
5. **Verify, every time.** Each prompt ends with exact verification commands plus a manual matrix that covers both a **regression check** (old behavior still works) and the **new behavior** across cases.
6. **Never commit unless the user explicitly says so.** Each prompt produces local changes only; the user reviews and says go. (See the project's commit conventions — e.g. message format, no co-author trailer — and inherit them into the pack's rules block.)
7. **The pack file is the source of truth.** Save it in the repo (`docs/`) so it survives the chats that consume it. If a session seems confused, point it at the pack.
8. **Independently shippable order.** Sequence so each phase can ship on its own and earlier prompts unblock later ones. State the sequencing rationale explicitly.

## Mode A — Authoring a pack

Goal: turn a big request into a sequenced, self-contained pack saved to `docs/<TOPIC>_PROMPT_PACK.md`. Full procedure in `references/authoring-guide.md`; the exact fill-in structure is `references/pack-template.md`. In brief:

1. **Deep-dive first (read-only).** Map the real code before planning. Identify every file the job touches and capture them in an **Architecture Map** (with file:line refs) so executing sessions don't rediscover them.
2. **Lock decisions & scope.** Record the agreed design decisions ("Locked Decisions") and an explicit **"What this pack does NOT cover"** list.
3. **Phase the work.** Group into phases where each is independently shippable. Write a short **Sequencing Rationale** (why this order; what each phase unblocks).
4. **Decompose into prompts.** One shippable unit each. For every prompt, fill the **per-prompt anatomy** (Risk · Files · Read-first · Why/Goal · Scope-exact-changes · What MUST NOT change · Tests · Verification · Risk register · Commit message · "When done / do not commit").
5. **Inherit project conventions.** Pull the build/test commands and the rules block from the project's `CLAUDE.md` / `AGENTS.md` / auto-memory so every prompt is correct for *this* repo.
6. **Add the closers.** A combined verification matrix (after multiple prompts ship) and a pre-flight checklist the user runs before handing off.
7. **Save & summarize.** Write the file; tell the user the execution order and how to run it (one prompt per fresh chat, verify, commit, next).

## Mode B — Executing a pack prompt

Goal: run exactly one pack prompt in a fresh chat, safely. Full procedure in `references/execution-guide.md`. In brief:

1. **Read first.** Auto-memory + `CLAUDE.md`/`AGENTS.md` + the named companion docs. Acknowledge in 2-3 sentences what you understand.
2. **Verify references.** Check every file:line in the prompt against current code before editing. If reality disagrees with the prompt, **push back** rather than forcing it.
3. **Do only the scoped change.** Respect "What MUST NOT change." If you discover scope creep, write it down as a follow-up and stop at the original scope.
4. **Verify.** Run the prompt's exact commands; walk its manual matrix (regression + new).
5. **Report and stop.** Files changed (with line numbers), test/build results, anything you had to adapt. **Do not commit** — wait for explicit go.

## Mode C — Handoff briefing

Goal: a single paste-ready message that lets a fresh chat (or another tool) resume with full context. Full procedure in `references/handoff-guide.md`. A good handoff captures: who the user is + project one-liner, what's already shipped (commits/decisions), current working-tree state, the landmines/gotchas, the exact next step, and a "read these first" list. End it with an instruction for the new session to acknowledge + summarize understanding + ask one clarifying question before acting.

## File & naming conventions

- Pack file: `docs/<TOPIC>_PROMPT_PACK.md` (e.g. `ONBOARDING_REBUILD_PROMPT_PACK.md`, `CURRENCY_FIX_PROMPT_PACK.md`).
- Handoff doc: `docs/<TOPIC>_HANDOFF.md` (or `<TOPIC>_PROMPT.md` for a single-shot brief).
- Prompt IDs: `P1 → P2 → …` for linear packs, or phase-letter + number (`A1`, `C3`, `F1a`/`F1b`) when grouped into phases. State the execution order explicitly with commit boundaries between units.
- Companion docs: list them in each prompt's "Read first" so a fresh chat can reconstruct full context.

## Universal rules (inherit + adapt per project)

Bake a **RULES block** into every pack so each prompt inherits it. Defaults that travel well (override from the project's `CLAUDE.md`/`AGENTS.md`/memory):

- **Read first**, then **verify file:line refs against current code** before editing.
- **Do not commit unless the user explicitly says "commit."** Local changes only; user reviews.
- **Tone:** short, direct, no filler. Push back when the prompt's assumptions disagree with the code.
- **Match existing style.** No premature abstractions; minimal comments; no emojis in files.
- **Staging hygiene:** stage files by name; never blanket-add untracked dirs (e.g. worktrees).
- **Commit messages:** follow the project's format (e.g. `area: imperative subject`); honor the project's co-author-trailer preference.
- **Platform gotchas:** carry any cross-platform build constraints (e.g. package-target OS minimums) into the relevant prompts.

The skill is portable; the *project-specific* facts (exact build/test commands, brand rules, invariants) come from the repo's `CLAUDE.md` / `AGENTS.md` / auto-memory. Always read those and embed the relevant ones into the pack.

## Pitfalls to avoid

- **Non-self-contained prompts.** If a prompt only makes sense in the chat that wrote it, it will fail in a fresh chat. Carry the context.
- **Stale line references.** Code moves; always instruct "verify before editing," never "edit line 414" blindly.
- **Missing "What MUST NOT change."** Without guardrails, executing sessions refactor adjacent code and cause regressions.
- **No verification matrix.** "It builds" is not verification. Require a regression case + the new-behavior cases.
- **Committing without permission.** Default to local changes; the user gates every commit.
- **Over-scoping a single prompt.** If a prompt touches many subsystems, split it. One shippable unit.
- **Skipping the read-only deep-dive when authoring.** Plans written without reading the code produce wrong file lists and wrong sequencing.

## Scale heuristics

| Scope | What to produce |
|---|---|
| Small change that fits one chat | No pack — just do the work |
| Focused feature/fix (few files) | 3–6 linear prompts (P1…P6), one verification matrix |
| Cross-cutting change (many files, one theme) | 6–12 prompts, grouped if natural, explicit MUST-NOT-CHANGE per prompt |
| Large rebuild / migration | Phased pack (A–E…), 10–17 prompts, sequencing rationale, per-phase shippability, pre-flight checklist |
| Dying chat / relay to another tool | Mode C handoff — one self-contained briefing |

The skill scales down gracefully: a handoff is a one-prompt pack; a rebuild is the full phased treatment.
