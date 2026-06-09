# Handoff Guide — a paste-ready briefing for a fresh chat or another tool

Use this when a chat is running low on context ("I'm out of tokens", "this chat is getting deep"), when the user wants to continue work in a new chat, or when relaying work to another agent/tool (e.g. Codex via `AGENTS.md`). A handoff is a **degenerate one-prompt pack**: the same self-contained, read-first discipline, sized to resume a single thread of work.

Output: a self-contained briefing the user can paste as the first message of a new chat. Save a copy to `docs/<TOPIC>_HANDOFF.md` (or `<TOPIC>_PROMPT.md`) if it should persist.

## What a good handoff contains

Write it as a message addressed to the next session. Include, in roughly this order:

1. **Identity + project one-liner.** Who the user is and what the project is, in two sentences — enough that a cold session orients immediately. (If the project has `CLAUDE.md`/auto-memory, point at them and keep this short.)
2. **Read these first.** The exact docs/files the new session must read before acting (auto-memory, `CLAUDE.md`/`AGENTS.md`, relevant `docs/`, prior research). Tell it to **verify code references before trusting them** — memory and docs are point-in-time.
3. **What's already shipped / decided.** The commits, the locked decisions, the dead ends already ruled out. This is what stops the new chat from redoing or relitigating settled work. Cite commit hashes/subjects where useful.
4. **Current state of the working tree.** What's in progress, what's uncommitted, what's the last green checkpoint. Be honest about anything half-done.
5. **The landmines / gotchas.** The non-obvious things that will bite a fresh session — fragile areas, invariants that must hold, "looks wrong but is intentional" facts, known false leads.
6. **The exact next step.** What this session should actually do first. Make it concrete and bounded — ideally one shippable unit (if it's bigger, consider authoring a full pack instead).
7. **Build/test commands.** The exact, verified commands so the new session can verify its work.
8. **Tone/working-style.** Inherit the project's conventions (e.g. short and direct, push back on bad specs, don't commit without explicit go, commit-message format).

## End with an orientation handshake

Close the handoff with an instruction for the new session to **prove it's oriented before acting**:

> First, confirm you've read this and the auto-memory. In 3-4 sentences, summarize: (1) your understanding of the current state, (2) the first thing you'd do and why, (3) one question or assumption you want me to confirm. Then wait for my green light.

This catches misunderstandings before any code is touched — and it's exactly how the most reliable handoffs in the wild are written.

## Cross-tool relay (e.g. Claude → Codex)

When the handoff is going to a different agent that reads `AGENTS.md` (not `CLAUDE.md`):
- Make the briefing fully self-contained (don't assume it auto-loads the same memory/CLAUDE.md).
- Restate the rules block inline (tone, don't-commit, commit format, platform gotchas).
- Prefer concrete file paths + "verify before editing" over any assumed shared context.
- If you're authoring many relay units, that's a **pack** (Mode A), not a single handoff — each prompt is one paste-able unit for the other tool.

## Quality bar

- [ ] Could a cold session with **zero memory** of this chat resume from the briefing alone?
- [ ] Does it say what's **done/decided** (not just what's left)?
- [ ] Are the **landmines** and **invariants** spelled out?
- [ ] Is the **next step** concrete and bounded?
- [ ] Does it end with the **acknowledge-and-summarize handshake**?
- [ ] Does it inherit the project's **don't-commit-without-go** default?

## When a handoff should become a pack

If the remaining work is more than one shippable unit — multiple phases, several files, real risk — don't cram it into one handoff. Author a full pack (Mode A, `authoring-guide.md`) and let the handoff just point at it: "continue the work in `docs/<TOPIC>_PROMPT_PACK.md`, starting at P3."
