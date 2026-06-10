# Design Critique — the iterated visual loop (the *See* step in detail)

This is how the *See* step actually runs when **design/feel is load-bearing** (the brief's "Design load-bearing?" field is YES). It is **mandatory and iterated**: you render the running UI, critique it against the bar, emit design defects, and the rebuild fixes the top ones — *every* iteration, alongside the objective machine facts. A passing unit/coupling test **never** substitutes for this (that shortcut ships a build that works but doesn't *feel* designed).

For a **plain utility** (design not load-bearing) you still glance at the rendered UI for "plain-but-clear / nothing broken," but this full ritual is optional — don't gold-plate.

## Step A — render the real UI (compose real tools; don't hand-wave)

Render the *running* app — not a mock, not a description. Prefer an interactive renderer so you can actually click and play with it; fall back to scripted screenshots.

1. **Interactive renderer (preferred — you can drive it):**
   - **Preview MCP** — `preview_start` (boot the app), `preview_screenshot` (capture), `preview_click` / `preview_fill` (drive states + flows), `preview_console_logs` (catch errors). Best when available: you see *and* exercise in one place.
   - **Claude-in-Chrome** — navigate, screenshot, click, read the DOM/console.
   - **computer-use** — drive a real desktop app or browser when the above don't fit.
2. **Fallback (always available): a Playwright script** that launches the app (dev server or `vite preview` on the built `dist/`), navigates to each key state, sets each viewport, and screenshots. Capture console + page errors while you're there.
3. **No renderer at all?** Report the visual loop **NOT RUN**, and — because design is load-bearing — the design bar is **unmet**, so the run **cannot PASS** (it stops at BLOCKED/PLATEAU and hands off). **Never** fake a visual pass or infer "it probably looks fine" (execute-discipline).

## Step B — capture the matrix (states × viewports)

Don't screenshot one happy-path view and call it seen. Capture the **key states**:

- **empty** (no data yet) · **loading** · **error** · **filled** (realistic content, including long/overflowing values) · **hover** · **focus** (keyboard focus visible?) · plus any state the product's core promise depends on (open/closed, selected, disabled).

…across **≥2 viewports**: **mobile** (~375px) and **desktop** (~1280px+); add tablet if the brief cares. A layout that's clean on desktop and broken on mobile is a real defect, not a footnote.

## Step C — critique against TWO things

For each captured screenshot, critique against:

**(a) The brief's design direction** — does it match the target aesthetic/vibe, the reference points, the stated principles, the intended "feel"? This is why the brief must carry a *substantive* direction (not just "yes, design matters") — without it you're grading against your own taste, which is the monoculture.

**(b) General design craft** — the heuristics checklist:

- **Visual hierarchy** — does the eye land on the most important thing first? Is emphasis earned or noisy?
- **Spacing & rhythm** — consistent spacing scale; aligned to a grid; breathing room; no cramped or random gaps.
- **Typography** — clear type scale; readable line-length/leading; limited, intentional font set; no orphaned sizes.
- **Color & contrast** — coherent palette; text/background contrast meets WCAG (this overlaps the objective `axe` check — fix it once); state colors meaningful.
- **Motion & interaction feel** — transitions purposeful, not gratuitous; durations/easing feel right; nothing janky; respects reduced-motion.
- **State coverage** — empty/loading/error states are *designed*, not afterthoughts; disabled/selected/hover are distinct and legible.
- **Responsiveness** — no overflow, truncation, overlap, or tap-targets-too-small at any captured viewport.
- **Polish** — alignment, consistent corner radii/shadows/borders, icon sizing, copy tone, favicon/title, loading skeletons vs. spinners — the details that separate "scaffold" from "feels good."

**Compose `frontend-design`** for the *direction + craft* — i.e. *how to make it good*, not merely to detect what's bad. The heuristics above flag problems; `frontend-design` is where the positive design expertise comes from.

## Step D — emit design defects (exactly like machine defects)

Turn the critique into a **defect list with severity** (Blocker / High / Medium / Low), each tied to a design-bar criterion or a named heuristic. Examples:

- *[High] Mobile (375px): control panel overflows, horizontal scroll. — responsiveness*
- *[High] No empty state — first load shows a bare frame. — state coverage*
- *[Medium] Type scale has 5 ad-hoc sizes; no clear hierarchy. — typography*
- *[Medium] Primary action and secondary action are visually identical. — hierarchy*

These join the machine defects in the iteration's critique; the rebuild fixes the **top** ones from **both** tracks. Concrete design defects (a missing state, an overflow, a contrast failure) are nearly as checkable as machine facts — keep those distinct from the genuinely subjective residue ("does this feel premium?"), which stays soft.

## Step E — the different-model critic (default when design is load-bearing)

Run a critic on a **different model** as the taste check. Give it **only** the screenshots + the brief's design direction + the design acceptance criteria — **not** the builder's own rationale (blind review). Ask for a blind score and a concrete defect list. Merge its defects into the critique.

It is **default-on** when design is load-bearing (the single biggest blunt against self-graded taste) and **optional** for plain utilities. It never gates the objective machine facts, and it never substitutes for rendering the UI. Honest limit: even with it, you have **two correlated models, not a user**.

## Step F — the human spot-check is the final taste gate

"Looks good to two models" is **not** "a designer signed off." When design is load-bearing, the honest hand-off names a **human spot-check** as the final taste gate — the loop drives quality hard toward the bar and clears every checkable design defect, but the last increment of genuine taste (and any "is this actually delightful?" call) belongs to a human. State this in the report; don't let a clean screenshot imply a designer approved it.

## How this feeds PASS

When design is load-bearing, **PASS requires the design bar met via this visual loop** — not just green build/tests. If the visual loop couldn't run, the design bar is unmet and the run cannot PASS; it hands off (BLOCKED) with the gap named. The objective machine facts remain co-equal and are never replaced by design — both tracks must be green to PASS.
