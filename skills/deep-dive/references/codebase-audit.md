# Codebase Audit Variant

Use when the user asks to audit, review, or analyze a code repository — particularly for correctness, safety, architecture, or readiness for production / live deployment.

## Recommended specialist lanes

Deploy these in parallel as a single batch. Pick 4–6 based on what the codebase actually contains.

### Lane 1: Core / business logic deep dive
For projects with non-trivial domain logic (pricing, scheduling, matching, ML, optimization, billing, etc.). The agent audits whether the logic actually implements the spec or design intent, looks for silent bugs (off-by-one, state leakage, data leakage, wrong ordering), and assesses whether the logic has a real chance of working.

Specific things to flag:
- Spec compliance per line of the design document
- No use of data that wouldn't be available at decision time (decisions use only information present at that point)
- Edge cases (cold start, ambiguous states, restart/resume behavior)
- Parameter sensitivity / knife-edge thresholds
- Honest assessment of whether the logic has a chance of working

### Lane 2: Architecture and code quality
The agent reviews module boundaries, dependency graph, abstractions, decimal/float discipline, error handling, code quality red flags (file sizes, test ratios, duplication).

Specific things to flag:
- Acyclic vs cyclic dependencies
- Clean interface separation (domain/data/strategy/execution/etc.)
- Type discipline at boundaries
- Configuration validation
- Maintainability for future contributors

### Lane 3: Risk / safety / kill switches
For projects touching money, safety, or production systems. The agent audits the risk controls, kill switch, circuit breakers, deployment gates, fail-closed behavior.

Specific things to flag:
- Every required limit implemented and enforced (not just computed)
- Live gates actually enforced in code, not just documented
- Fail-closed behavior on every failure mode (data, network, storage)
- Secret handling
- Catastrophic failure modes (multiple instances running at once, dependency outages, misconfiguration)

### Lane 4: Data / integration layer
For projects that ingest external data or interact with third-party APIs/services. The agent audits data ingestion, normalization, input/request validation, and any sandbox or mock used in place of the real service.

Specific things to flag:
- Correct API endpoints, rate limit handling, backoff
- Normalization correctness, sequence-gap / missing-data detection
- Request/input validation against the external service's constraints
- Sandbox/mock honesty — does the simulated dependency match real behavior?
- Latency and failure-injection realism
- "Happy-path assumptions" in simulators that won't hold in production

### Lane 5: Validation pipeline
For projects whose correctness rests on empirical validation (ML, analytics, simulations, any data-driven system). The agent audits the validation harness, holdout discipline, metrics, and baseline comparisons.

Specific things to flag:
- Use of data unavailable at decision time (information leakage)
- Optimistic assumptions baked into the simulation
- Real-world cost / error modeling realism
- A genuine holdout set reserved and never touched during tuning
- Multiple-comparisons correction (every parameter combination tested counts)
- Baseline comparisons (do-nothing, naive / simple benchmark)
- How much real data is actually present (often the silent killer)

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

These are the silent killers worth hunting in most codebases — a computed safeguard that nothing enforces, a simulation that flatters reality, a test that passes against almost nothing:

1. **A computed decision nothing enforces.** Code calculates a guard (rate-limit exceeded, permission denied, "should halt/stop") and returns it — but no caller acts on the result. The check exists on paper; the system never actually stops.
2. **A kill switch / feature flag the live path never reads.** The file, env var, or config exists; the production code path never consults it.
3. **Money math in floats.** Currency stored or summed as floating point; rounding drift silently corrupts totals. (Decimal/precision discipline missing at boundaries.)
4. **Retry without idempotency.** A retried request re-runs a side effect — double charge, duplicate email, double write.
5. **Errors swallowed.** A bare `except:` / empty `catch` turns a failure into a silent success; the caller proceeds on bad or empty data.
6. **Stale cache after write.** Cache not invalidated on update; the system keeps serving old data that looks current.
7. **Check-then-act race.** No lock or transaction between "is it available?" and "take it"; two concurrent runs both proceed (double-booking, two instances live at once).
8. **Off-by-one at a boundary.** Pagination, batch windows, or date ranges that drop or double the edge record.
9. **Tests pass against almost no data.** Fixtures so small the suite is green while exercising essentially nothing real.
10. **Time-zone / clock assumptions.** UTC-vs-local, DST, or clock-skew assumptions that quietly produce wrong timestamps, ordering, or scheduling.

Encode the categories relevant to this codebase into the specialist prompts as "common silent-bug categories to hunt for." Add domain-specific ones where the project has non-trivial logic — for a system with its own decision rules, "a safeguard that's computed but never enforced" (#1) is the highest-value pattern to chase.

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

Plain-English impact statements per finding. The user shouldn't need to know what a cache key is to understand that "some users have been served stale data for months."
