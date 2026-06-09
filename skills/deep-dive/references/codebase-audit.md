# Codebase Audit Variant

Use when the user asks to audit, review, or analyze a code repository — particularly for correctness, safety, architecture, or readiness for production / live deployment.

## Recommended specialist lanes

Deploy these in parallel as a single batch. Pick 4–6 based on what the codebase actually contains.

### Lane 1: Strategy / business logic deep dive
For projects with non-trivial domain logic (trading, optimization, ML, etc.). The agent audits whether the logic actually implements the spec or design intent, looks for silent bugs (lookahead, off-by-one, repaint, data leakage), and assesses whether the logic has a real chance of working.

Specific things to flag:
- Spec compliance per line of the design document
- No-lookahead enforcement (uses closed/completed data only)
- Edge cases (warmup, ambiguous states, restart behavior)
- Parameter sensitivity / knife-edge thresholds
- Honest assessment of whether the strategy/logic has a chance of working

### Lane 2: Architecture and code quality
The agent reviews module boundaries, dependency graph, abstractions, decimal/float discipline, error handling, code quality red flags (file sizes, test ratios, duplication).

Specific things to flag:
- Acyclic vs cyclic dependencies
- Clean interface separation (domain/data/strategy/execution/etc.)
- Type discipline at boundaries
- Configuration validation
- Maintainability for future contributors

### Lane 3: Risk / safety / kill switches
For projects touching money, safety, or production systems. The agent audits the risk engine, kill switch, drawdown control, live deployment gates, fail-closed behavior.

Specific things to flag:
- Every required limit implemented and enforced (not just computed)
- Live gates actually enforced in code, not just documented
- Fail-closed behavior on every failure mode (data, network, storage)
- Secret handling
- Catastrophic failure modes (multiple instances, exchange outages, fat-finger configs)

### Lane 4: Data / execution layer
For projects that ingest external data or interact with exchanges/APIs. The agent audits data ingestion, normalization, order validation, paper broker fill model.

Specific things to flag:
- Correct API endpoints, rate limit handling, backoff
- Normalization correctness, sequence-gap detection
- Order validation against exchange filters
- Fill model honesty — does paper match live behavior?
- Latency simulation, slippage modeling
- "Happy assumptions" in simulators that won't hold live

### Lane 5: Backtester / validation pipeline
For projects with quantitative validation. The agent audits the backtester, walk-forward, CPCV, metrics, baseline comparisons.

Specific things to flag:
- Lookahead bias
- Optimistic fills
- Friction modeling realism
- Out-of-sample reservation
- Multiple-testing correction
- Baseline comparisons (HODL, always-flat, simple benchmark)
- How much historical data is actually present (often the silent killer)

### Lane 6: Tests / operational readiness
The agent reviews test coverage and quality, observability, QA checks, deployment readiness, monitoring, runbooks.

Specific things to flag:
- Test count and pass rate
- Critical-path coverage (the safety surface)
- Observability instrumentation
- Runbook completeness
- Operational gaps (memory leaks in long-running processes, WS backoff, supervisor docs)
- Honest assessment of weeks-to-ready

## Common silent bugs to hunt across all lanes

These are the silent killers that have appeared in multiple real audits:

1. **Strategy exit logic dead in production paths.** Runner constructs a placeholder position state with hardcoded stops; the strategy's real exit logic never fires.
2. **Anchored VWAP not actually anchored.** Indicator called without anchor parameter; accumulates from buffer start instead of daily reset.
3. **Risk engine HALT actions computed but never enforced.** Engine returns HALT_NEW_ORDERS or FLATTEN_AND_HALT; nothing in src/ reads `decision.action`.
4. **Backtest fees orders-of-magnitude too low.** Config ships with 1 bp taker when reality is 40-60 bps.
5. **Market lake holds one day of data.** Backtest reports look real but tested against nothing.
6. **r_multiples or similar metric hardcoded empty.** Sample-size checks silently broken.
7. **LIMIT_MAKER fills assumed 100%.** No queue position model; once a through-tick occurs, fill is assumed.
8. **MARKET orders skip latency simulation** while LIMITs respect it. Emergency exits appear faster in paper than live.
9. **Manual kill switch not consulted in live path.** File exists, code never reads it.
10. **Process lock missing.** Two simultaneous bot instances architecturally allowed.

Encode these patterns into the specialist prompts as "common silent-bug categories to hunt for."

## Phase 0 setup for codebase audits

Before deploying specialists:

```bash
# Lay of the land
find . -maxdepth 3 -type d -not -path '*/.*' -not -path '*/__pycache__/*' | head -40
git log --oneline | head -30                # commit history
wc -l src/**/*.py | tail -1                 # rough scope
ls docs/                                    # documentation
ls tests/                                   # test scope
cat README.md                               # purpose
cat pyproject.toml || cat package.json      # dependencies
```

Read the README, the entry-point file, and 1-2 representative source files yourself. This 5-minute investment lets you write much better specialist prompts.

## Synthesis output structure

The synthesis agent for a codebase audit should produce:

1. **TL;DR / Executive verdict** (one paragraph)
2. **Where the codebase shines** (genuine praise; specific findings)
3. **Critical bugs (load-bearing)** (Blocker list, file:line refs, plain-English impact each)
4. **The architectural pattern** (meta-finding — where the effort went vs where the risk lives)
5. **The "is it testing the right thing" check** (when bugs invalidate prior testing)
6. **Comparison to original design** (if a design doc exists)
7. **Realistic probability assessment** (will this work? what's the honest number?)
8. **Prioritized fix list** (Tier 0 / 1 / 2 / 3, file:line refs)
9. **Should-you-proceed answer** (one-sentence honest verdict)

## Red-team for codebase audits

Focus the red-team agent on:
- Single-source numerical claims in specialist reports
- Acceptance criteria that admit trivially-passing implementations
- Findings that depend on assumptions the specialist didn't verify
- Risk-tier assignments that seem inflated or deflated

## Executive briefing for codebase audits

Lead with verdict. Use this structure:

```
## Bottom line up front
[Honest one-paragraph answer]

## Where the build genuinely shines
[Specific praise]

## Critical bugs
[Numbered list of Blockers with plain-English impact]

## The architectural pattern observation
[Meta-finding]

## Honest probability of [what user is trying to do]
[Number with reasoning]

## Prioritized fix list (Tier 0/1/2/3)
[Specific actions, file:line refs, sized for one Codex/PR work session each]

## Should you proceed?
[One-sentence answer with caveats]
```

Plain-English impact statements per finding. The user shouldn't need to know what `r_multiples` is to understand that "the sample-size warning in every backtest is broken."
