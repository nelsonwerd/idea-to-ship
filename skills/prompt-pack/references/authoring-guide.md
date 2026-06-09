# Authoring Guide — turning a big job into a pack

Use this when the user asks to "make a prompt pack", "break this into prompts/phases", or when a requested change is too large or risky to finish safely in one chat. Output: a complete pack saved to `docs/<TOPIC>_PROMPT_PACK.md`, plus a short message telling the user how to run it.

The scaffold to fill is `references/pack-template.md`. This guide is the *process* to fill it well.

## Step 0 — Decide it's worth a pack, and establish the source of truth

If the work fits comfortably in the current chat and is low-risk, **don't make a pack — just do it**. Packs pay off when the job is large, multi-file, risky, or will outlive one chat's context. (See Scale heuristics in `SKILL.md`.)

Then settle what "settled scope" means here: if a `docs/CONCEPT_BRIEF.md` exists, read it as the source of truth (it was produced upstream — e.g. by the `ideate` skill — and its Locked decisions / Scope OUT / phased roadmap map straight onto this pack). If there's no brief and the request is an *unsettled product idea* rather than a concrete code change, offer `ideate` first if it's available — sequencing an unvalidated concept just ships a guess faster. A concrete, already-decided change (a refactor, a migration, a defined feature) is settled by definition — proceed. (Mode A's step 1 in `SKILL.md` has the exact phrasing.)

## Step 1 — Architecture reconnaissance (read-only)

Do not plan from memory. Read the real code before writing a single prompt.

- Read the project's durable context: auto-memory, `CLAUDE.md`/`AGENTS.md`, and the relevant `docs/`.
- Trace every file the job will touch. Capture them — with paths and key line numbers — into the **Architecture Map**. This is what stops executing chats from rediscovering the codebase each time.
- Note the exact, verified build/test commands for this repo (copy into the pack's commands block).
- Record the commit you're validating against (`git rev-parse --short HEAD`) and the branch — put them in the pack's **Validated against** front-matter line so a later chat can tell if the tree has moved far.
- Surface invariants and fragile areas (money math, currency, migrations, auth) so prompts can carry the right "What MUST NOT change."

If you skip this step, your file lists and sequencing will be wrong. This reconnaissance is the foundation.

## Step 2 — Lock decisions and fence scope

- Write down the **Locked Decisions** the executing chats must treat as fixed (design choices, naming, what's in/out). This prevents re-litigating settled questions in every chat.
- Write the **What this pack does NOT cover** list explicitly. A scope fence is as important as the scope.

## Step 3 — Phase the work

- Group prompts into **phases where each phase is independently shippable** and leaves the app working.
- Order so earlier work unblocks later work (e.g., ship the data/foundation layer before the UI that depends on it; build shared infrastructure before wiring it up; clean up dead code last).
- Write a short **Sequencing Rationale** explaining the order and why each phase is safe to ship alone. Future-you and every executing chat will rely on it.

## Step 4 — Decompose into prompts (one shippable unit each)

For each prompt, fill the per-prompt anatomy from the template:

- **Risk** (very low → HIGH) + a one-line why. Be honest; HIGH-risk prompts deserve extra guardrails and a fuller manual matrix.
- **Files** — the exact files (and tests). Mark line numbers as "verify before editing."
- **Read first** — auto-memory + project context + companion docs + the specific references to verify.
- **Why/Goal** — the problem and the precise outcome. Invite push-back if the code disagrees.
- **Scope — exact changes** — concrete, often with before/after snippets. This is the spec.
- **What MUST NOT change** — the guardrails (response shapes, regression-critical paths, helper signatures, formatting/rounding). The single most important section for safety.
- **Tests** — what to add/update and the cases to cover.
- **Verification** — exact commands + a manual matrix that always includes a **regression case** plus the **new-behavior** cases (and edge cases).
- **Risk register** — what could break + how to detect/mitigate.
- **Commit message** — ready to paste, in the project's format.
- **When done** — what to report; "Do not commit — wait for explicit go."

Sizing rule of thumb: if a prompt touches several unrelated subsystems, or its "Scope" section sprawls past what one focused chat can verify, **split it**. If two tiny prompts always ship together and share all context, merge them.

## Step 5 — Inherit the project's rules

Build the **RULES block** and **Build/test commands** from `CLAUDE.md`/`AGENTS.md`/memory so every prompt is correct for *this* repo: tone, commit-message format and co-author-trailer preference, staging hygiene, platform gotchas (e.g. cross-platform build constraints), and the "don't commit unless told" default.

## Step 6 — Add the closers

- **Combined verification matrix** — the end-to-end checks once a phase (or the whole pack) lands, including backward-compat (e.g. old client ↔ new server).
- **Pre-flight checklist** — prerequisites that must be live first, and the "hand P1 to a fresh chat, verify, commit, then P2…" ritual.

## Step 7 — Save and tell the user how to run it

- Save to `docs/<TOPIC>_PROMPT_PACK.md`.
- Tell the user: the execution order, that each prompt goes in its **own fresh chat**, and the verify→commit→next loop. Offer to also write a companion **handoff** (Mode C) if they're relaying to another tool.
- **(Optional) Offer a status ledger for long packs.** If the pack will be executed across many chats over several days, offer to add a one-line-per-prompt ledger (`docs/<TOPIC>_PROMPT_PACK_STATUS.md`) the user updates as each prompt lands — so any fresh chat can see what's already shipped without reconstructing it from `git log`. Skip it for a small pack (≤3–4 prompts); there it's just overhead.

## Quality bar (self-check before delivering)

- [ ] Could a fresh chat with **zero memory** of this conversation execute each prompt from the prompt text alone? (If not, carry more context into the prompt.)
- [ ] Does every prompt have a **"What MUST NOT change"** and a **verification matrix with a regression case**?
- [ ] Are line references framed as **"verify before editing,"** never blind edits?
- [ ] Is each phase **independently shippable**, leaving the app working?
- [ ] Did you **read the actual code** (not plan from memory), and are the file paths real?
- [ ] Is the **scope fence** explicit ("does NOT cover")?
- [ ] Does the pack default to **local changes only** (no commit without explicit go)?

## Stress-test pass (recommended for HIGH-risk packs)

Before delivering a high-stakes pack, verify the prompts against reality and fix mismatches — then note the corrections in a short **Revisions log** at the top (e.g., "Confirmed `formattedAmount` is `private` → marked that prompt optional"). Bake genuine decision points into the prompt as explicit options ("Path A: widen access / Path B: skip / Path C: integration test — you decide") rather than guessing. A pack that already absorbed reality's surprises is far more likely to execute cleanly across chats.
