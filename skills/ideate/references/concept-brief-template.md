# CONCEPT_BRIEF Template

The CONCEPT_BRIEF is `ideate`'s product: one self-contained file that holds the locked concept, the honest verdict, and the phased roadmap. Copy this scaffold to **`docs/CONCEPT_BRIEF.md`** *inside the workspace the user has open* (for a no-repo greenfield idea, save it under the current working directory and tell the user the path — never a scratch folder they aren't viewing). Fill the `<placeholders>`, delete guidance comments, and **edit it in place every turn — never regenerate it from scratch** (and mirror key changes inline so the user can see them).

Rules that make the brief work:
- **One file, edited in place.** Each phase reads it first and diffs new decisions into it. Regenerating it loses the decision log and re-opens settled questions.
- **Self-contained.** Assume zero chat memory — the build happens in other chats/tools that only have this file.
- **Mark `[required]` fields before handoff.** `[optional]` fill when relevant; `[refinement-only]` only when improving an existing thing.
- **Label cited fact vs your own estimate** everywhere numbers appear.
- **Single source of truth for naming** — all names live in exactly one block (see bottom).

---

## Template

````markdown
# CONCEPT_BRIEF — <one-line human title>

<!-- HEADER / STATUS -->
- **Codename:** `<placeholder-codename>`  <!-- [required] flagged placeholder until the concept is locked; may differ from public name -->
- **Mode:** <greenfield | refinement>  <!-- [required] -->
- **Last updated / current state:** <one line the user refreshes each session; for refinement, the done-vs-not-done reality>  <!-- [required] -->
- **Confidence verdict:** <N/10> — would move to <higher> if <named delta>; down if <named delta>  <!-- [required] updated as the concept hardens -->

## The concept
- **One-line promise:** <what this *actually* delivers, in plain English — not a feature list>  <!-- [required] -->
- **Problem + who feels it:** <2–3 plain bullets; include the founder's insider edge / personal pain>  <!-- [required] -->
- **Beachhead persona:** <ONE primary target, even if the product serves many; optional named secondary flagged "not v1">  <!-- [required] -->
- **The wedge / differentiator:** <why this wins; the core idea/data-model *concept* in plain English, NOT a schema>  <!-- [required] -->
- **Market evidence:** <cited external data — label [cited] vs [estimate]>  <!-- [optional] -->
- **Competitive landscape:** <buckets: incumbents who could add it / direct clones / adjacent — and why we win anyway>  <!-- [optional; required if pressure-test surfaced incumbents] -->

## The gate  <!-- do NOT omit — these are the pieces real sessions skip and pay for later -->
- **Success metric:** <the REAL definition of "this is working" — not a proxy>  <!-- [required] -->
- **Aha / activation moment:** <the single event where the user first feels the value; reused as gating + funnel logic later>  <!-- [required] -->
- **Kill criterion / smallest proof:** <"if X doesn't happen by Y, we stop or shelve">  <!-- [required] a committed gate, not a footnote -->

## Scope & roadmap  <!-- the part prompt-pack consumes most directly -->
- **Scope IN (v1):** <explicit list>  <!-- [required] -->
- **Scope OUT / deferred:** <each deferred item NAMED + a one-line reason>  <!-- [required] -->
- **Locked decisions:** <bulleted; each with a one-line rationale — this is the decision log>  <!-- [required] -->
  - LOCKED: <decision> — <why>
- **Open decision-forks:** <unresolved sub-decisions stated as explicit binaries to resolve, not half-built>  <!-- [optional] -->
- **Phased roadmap:** <ordered phases; FIRST phase verifiable; spine locked, rest deferred>  <!-- [required] -->
  - Phase 1 (spine / correctness): <...>
  - Phase 2 (…): <...>
- **Risks + mitigations:** <including the single biggest risk named as a CATEGORY (e.g. trust / distribution), not "missing features">  <!-- [required] -->

## Tech & constraints (high-level only — enough to seed the build, not full schemas)
- **Tech approach:** <platform, backend, key services/APIs; for existing code, POINT at the repo>  <!-- [required] -->
- **Hard constraints:** <platform/store rules, regulatory landmines, payment/identity requirements>  <!-- [optional] -->
- **Core domain primitives:** <units/enums that bite if left unlocked>  <!-- [optional] -->
- **Source-of-truth rules:** <e.g. "backend is source of truth; client is thin" — become per-prompt tiebreakers downstream>  <!-- [optional] -->

## Refinement-only
- **Parity contract:** <inventory of existing screens/flows/endpoints + the hand-tuned details to preserve + an explicit, testable "done relative to the current thing">  <!-- [refinement-only, required in that mode] -->
- **Current state — done vs not-done:** <two columns>  <!-- [refinement-only, required in that mode] -->
- **Pre-mortem:** <what will silently drift in a rebuild, and how we'll know we matched the original>  <!-- [refinement-only] -->

## Validated facts vs assumptions  <!-- [required] keeps the brief honest -->
- **Verified:** <empirically / repo / web confirmed>
- **Still a bet:** <unverified assumptions the concept rests on>

## Naming (single source of truth)  <!-- the ONLY place names live -->
- Codename: `<placeholder>`  · Display name: `<TBD until Phase 4>`  · Slug/domain/bundle-id: `<TBD>`
<!-- Name LATE, lock ONCE. Cross-chat naming drift causes real rework (deeplink schemes, bundle ids, folders). -->

## Handoff  <!-- [required] -->
> Concept locked. Next step: hand this brief to the **prompt-pack** skill to turn the roadmap into sequenced, self-contained build prompts.
````

---

## What maps to prompt-pack

When `prompt-pack` authors a pack, it pulls directly from this brief (full table in `handoff-guide.md`):
- **Locked decisions** → prompt-pack's "Locked decisions" block
- **Scope OUT / deferred** → prompt-pack's "What this pack does NOT cover"
- **Phased roadmap** → prompt-pack's phases + sequencing rationale
- **Tech approach / source-of-truth rules / constraints** → inform prompt-pack's RULES + build/test block (it derives exact commands from the actual repo)

`ideate` delivers the **what and why**; `prompt-pack` derives the **how** (file maps, commands, per-prompt guardrails) by reading the codebase. `ideate` does **not** produce file:line architecture maps.

---

## Filled mini-example (neutral, abbreviated)

````markdown
# CONCEPT_BRIEF — a "shared inbox" tool for small client-service teams

- **Codename:** `relaybox` (placeholder)
- **Mode:** greenfield
- **Last updated / current state:** Concept locked; roadmap drafted; not yet built.
- **Confidence verdict:** 7/10 — would move to 8 if 5 target users confirm the triage pain in interviews; down to 4 if they already tolerate shared Gmail.

## The concept
- **One-line promise:** Every client message handled by the right person, fast — without anyone owning a chaotic shared inbox.
- **Problem + who feels it:** Small agencies share one email login; messages get dropped or double-answered. (Founder ran a 4-person studio and lived this.)
- **Beachhead persona:** 2–6 person creative/client-service studios. (Secondary: solo freelancers — not v1.)
- **The wedge:** Assignment + status on top of the inbox they already use, not a new CRM to migrate to.

## The gate
- **Success metric:** % of client messages with a clear owner + reply within 1 business day.
- **Aha moment:** First message auto-assigned and replied to without a "who's got this?" Slack ping.
- **Kill criterion:** If 5 target studios won't try a 2-week pilot, shelve it.

## Scope & roadmap
- **Scope IN (v1):** Gmail connect, assignment, status, reply.
- **Scope OUT / deferred:** Outlook (smaller beachhead), analytics dashboard (post-validation), mobile app (web-first proves it).
- **Locked decisions:**
  - LOCKED: Layer on existing email, don't replace it — lowers switching cost (the wedge).
  - LOCKED: Web-first — fastest path to validating the core loop.
- **Phased roadmap:** Phase 1 (spine): connect + assign + reply loop. Phase 2: status/SLA. Phase 3: team analytics.
- **Risks + mitigations:** Biggest risk is *distribution*, not features — mitigate with founder's agency network for pilots.

## Tech & constraints (high-level)
- **Tech approach:** Web app + a hosted backend + the email provider's API. (No code yet — Phase 1 scaffolds it.)
- **Hard constraints:** Email-provider API review/scopes for production access.

## Validated facts vs assumptions
- **Verified:** Founder's own studio had the pain (firsthand).
- **Still a bet:** That other studios feel it strongly enough to switch workflows.

## Naming
- Codename: `relaybox` · Display name: TBD (Phase 4) · Domain: TBD

## Handoff
> Concept locked. Hand to prompt-pack to sequence Phase 1 into build prompts.
````
