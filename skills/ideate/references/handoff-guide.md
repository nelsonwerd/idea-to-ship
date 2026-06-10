# Handoff Guide — from CONCEPT_BRIEF to prompt-pack

`ideate` is a bounded phase. It ends when the concept is locked and the brief is complete, by **offering** the handoff to the `prompt-pack` skill. This guide is the exact contract so the seam is clean.

## How `ideate` ends

After the locked-in recap, write the brief's final state and offer — verbatim pattern:

> *"Your concept is locked and written to `<the brief's path — e.g. docs/CONCEPT_BRIEF.md>`. Want me to hand this to the **prompt-pack** skill to turn the roadmap into sequenced, self-contained build prompts?"*

- If **yes** → invoke `prompt-pack` and **explicitly name the brief as its source, by its actual path**. Paste-ready: *"Use the prompt-pack skill (its authoring mode) to build a pack from `<the brief's path>` — treat the brief's Locked decisions as fixed and its Scope OUT as the scope fence."* Then `ideate`'s job is done.
- If the user wants to **relay to another tool** (e.g. Codex) → that's `prompt-pack`'s handoff mode (its Mode C), not `ideate`'s.
- `ideate` does **not** author build prompts or execute. That separation is the whole point of two skills.

> **Be honest about the seam:** `prompt-pack` has no built-in awareness of `CONCEPT_BRIEF.md` — the handoff works because you hand it the brief explicitly as its authoritative input (and the brief's structure maps onto what `prompt-pack` asks for). Don't imply an automatic link; name the file.

## The field-mapping contract

`prompt-pack`'s authoring mode (its Mode A) consumes a specific set of inputs. The CONCEPT_BRIEF maps onto them directly:

| `prompt-pack` input | Source field in CONCEPT_BRIEF | Notes |
|---|---|---|
| **Locked decisions** | `Locked decisions` (+ promise, wedge, persona, pricing, tech approach) | Direct 1:1 — the primary feed |
| **What this pack does NOT cover** (scope fence) | `Scope OUT / deferred` (named items) | Direct 1:1 |
| **Phases + sequencing rationale** | `Phased roadmap` (spine-first, each phase verifiable) | Direct — "lock the spine, defer the rest" gives the phase shape |
| **RULES block + build/test commands** | `Tech approach`, `Source-of-truth rules`, `Hard constraints` *inform* these | But the exact commands come from the repo's own `CLAUDE.md`/`AGENTS.md` — `prompt-pack` derives them |
| **Architecture Map** (file:line refs) | **Not `ideate`'s job** | `prompt-pack` produces this in its own read-only architecture reconnaissance. For refinement, the `Parity contract` + repo pointer tell it where to look |
| Companion doc each prompt reads first | The CONCEPT_BRIEF itself | The brief travels with the pack |

## The boundary: what vs how

State this plainly so neither skill over-reaches:

- **`ideate` delivers the *what and why*** — locked decisions, scope fence, sequenced phases, success/kill/Aha, risks. Concept altitude.
- **`prompt-pack` derives the *how*** — file maps, exact build/test commands, per-prompt guardrails — by reading the actual codebase.
- `ideate` does **not** produce file:line architecture maps or exact shell commands. It stays at concept altitude.

**Greenfield note:** for a brand-new concept there is no code yet, so `prompt-pack`'s first phase will necessarily be scaffolding and its Architecture Map starts empty — that's expected. `ideate` should NOT try to pre-fill code-level detail to compensate; hand off the concept and let `prompt-pack` scaffold.

**Refinement note:** the `Parity contract` and the repo pointer are the high-value handoff — they tell `prompt-pack` what already exists and what "done" means relative to it. Make the parity contract testable; `ideate` authors it, downstream phases enforce it.

## Where the brief lives

Prefer **`docs/CONCEPT_BRIEF.md`** — the same `docs/` location `prompt-pack` saves packs to, so the concept and its packs sit together and survive the chats that consume them. For a brand-new greenfield idea with no project structure yet, the working-directory root (`./CONCEPT_BRIEF.md`) is an acceptable fallback so the user can actually see the file. `prompt-pack` discovers the brief in either place (and via a shallow glob), and `ideate` names the exact path at handoff — so the two never disagree about where it lives.

## Resolving decision-forks before handoff

Don't hand off with load-bearing sub-decisions still fuzzy — they'll leak into the build half-formed (a feature "sort of" supported, a pricing model never pinned). Before offering the handoff, scan `Open decision-forks` and either resolve each into a `Locked decision` or explicitly defer it into `Scope OUT` with a reason. The brief that reaches `prompt-pack` should have no silent ambiguity in its v1 spine.

## What `ideate` can't guarantee (be honest)

The parity contract and roadmap are **authored** by `ideate` but **enforced** downstream (in `prompt-pack` and execution), outside `ideate`'s bounded phase. `ideate` hands off a strong, testable artifact; it can't itself guarantee the build won't drift. Say this rather than implying ideate controls the outcome — its job is to make drift *detectable*, not impossible.
