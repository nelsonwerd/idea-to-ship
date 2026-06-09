# Execution Guide — running one pack prompt in a fresh chat

Use this when the user pastes a pack prompt, or says "run P3 / execute phase C." The discipline here is what makes packs safe: do exactly one unit, verify it, and stop.

## The loop

### 1. Read first, then acknowledge
- Read auto-memory + `CLAUDE.md`/`AGENTS.md` + the prompt's named companion docs.
- In **2-3 sentences**, acknowledge what you understand: the goal of this prompt, the files in play, and the one regression you're most worried about. This catches a wrong-prompt or stale-context situation before any edit.

### 2. Verify references against current code
- Open every file the prompt names and **check the line references against the current code before editing** — code moves between authoring and execution.
- If reality disagrees with the prompt (a function moved, an assumption is false, the change is already made), **push back and report** rather than forcing the edit. The prompt's assumptions are hypotheses; the code is truth.

### 3. Do only the scoped change
- Implement exactly what "Scope — exact changes" specifies.
- Honor **"What MUST NOT change"** strictly. Do not refactor adjacent code, rename things, or "improve" beyond the ask.
- If you discover necessary work outside the scope, **write it down as a follow-up and stop at the original scope** — don't expand the prompt mid-flight. (Note it for a future pack prompt.)
- Match existing style; no premature abstractions; minimal comments; no emojis in files.

### 4. Verify
- Run the prompt's **exact verification commands**. Quote the key result line(s).
- Walk the **manual matrix**: the regression case first (old behavior intact), then each new-behavior/edge case.
- If a check fails, fix within scope and re-run — or, if the fix would exceed scope, stop and report.

### 5. Report and stop
Report back:
- **Files changed** with key line numbers.
- **Test/build results** (quote the summary lines).
- **Anything you adapted** from the prompt (and the one-line reason) — e.g. a line reference that had moved, an existing test you updated.
- Any follow-up you noted as out-of-scope.

**Do not commit.** Wait for the user's explicit "commit." When they do, use the project's commit-message format (and honor the no-co-author-trailer preference if that's the project's rule).

## If the prompt is under-specified

A good pack prompt is self-contained. If one isn't — missing files, vague scope, no verification — don't guess:
- Reconstruct what you can from the companion docs and the code.
- State the gap and your proposed interpretation, and ask one sharp question if a decision is genuinely the user's to make.
- Then proceed once unblocked. (And consider noting the gap so the pack can be tightened.)

## Reminders

- One prompt, one chat, one shippable unit. Don't pull in the next prompt "while you're here."
- The pack file is the source of truth. If you're unsure how this prompt fits the whole, read the pack's front matter (How-to-use, Sequencing rationale, Architecture map).
- Leave the app in a working state. If you can't, stop and report rather than committing a half-change.
