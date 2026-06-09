# Strategy / System Evaluation Variant

Use when the user asks to evaluate, audit, or stress-test a **strategy or formal decision system** — a business or growth strategy, a pricing or bidding scheme, an algorithm, a forecasting/ML model in production, an automation, or any system that makes repeated decisions and claims a measurable payoff. The focus is whether the system has a **real edge** and whether its **claimed performance is honest** once real-world costs and a fair baseline are applied.

This variant is domain-neutral. It covers anything that makes repeated decisions and claims a measurable payoff — "will this growth loop actually compound?", "does this routing algorithm beat the simple rule?", "is this model's reported accuracy real?", a pricing or bidding scheme, or any quantitative decision system. Use the general rigor below and swap in domain specifics where they apply.

## Recommended specialist lanes

Deploy 4–6 in parallel:

### Lane 1: Core logic / decision rules
The agent audits the actual decision logic: the inputs, the rules or model, the accept/reject (or enter/exit) conditions, and parameter sensitivity. Does the logic do what the design claims, and is there a plausible mechanism for it to work?

Specific things to flag:
- Correctness of the core computation (the method matches the stated intent)
- Use of information that wouldn't be available at decision time (the system "knows the future")
- Knife-edge thresholds — does a tiny parameter change flip the outcome?
- Stability across conditions (does it survive a change in conditions or a different segment, or is it tuned to one slice?)
- Honest assessment of edge: is there a real reason this beats the naive alternative, or is it curve-fit?

### Lane 2: Evidence for the edge
The agent catalogs and weighs the evidence that each component actually predicts or improves what it claims. Which claims have strong, independent support vs. a single promotional source?

Specific things to flag:
- Which claims have peer-reviewed / replicated / independently-measured support vs. vendor-blog or single-anecdote support
- Realistic effect sizes (usually much smaller than the marketing claim)
- Persistence after a structural change (does it still hold after the market / platform / user base shifted?)
- Single-source claims that materially affect the verdict — the biggest source of overconfidence; verify them

### Lane 3: Real-world execution and costs
The agent audits what the system costs to actually run, and the gap between the idealized model and reality.

Specific things to flag:
- The real per-decision costs (fees, infra, time, error rate) — often the single decisive economic factor
- Realistic success/conversion rate vs. the optimistic assumption (perfect execution is rarely real)
- Adverse conditions the environment imposes (competition, adversarial inputs, latency, throttling)
- Capacity / scale: at what volume does it stop working? (works small, breaks at the scale you'd actually run)
- Access constraints (geographic, regulatory, platform-policy)

### Lane 4: Validation methodology
The agent audits how the claimed performance was measured. This is the single highest-ROI lane, because most systems die in the gap between a flattering test and reality.

Specific things to flag:
- Information leakage — use of future or otherwise-unavailable data in the test
- Optimistic assumptions baked into the simulation
- Real-world-cost modeling vs. the actual costs
- A genuine holdout reserved and never touched during tuning (separate from the tuning set)
- Multiple-comparisons correction (every parameter combination tested counts against significance)
- Sample-size adequacy — enough independent observations to claim the result isn't noise
- The honest haircut from test conditions to live conditions

### Lane 5: Risk and worst-case
The agent audits exposure control, worst-case outcomes, and whether a bad run can be catastrophic.

Specific things to flag:
- Sizing / exposure rules and whether they can be silently bypassed
- Throttling or circuit-breakers on a losing streak / degraded conditions
- Honest worst-case (worst-case loss, peak-to-trough decline, blast radius) — not the average case
- Probability-of-ruin / unrecoverable-failure analysis
- Hard caps that hold even under operator error or a partial outage

### Lane 6: Honest baseline comparison
The agent compares the system's projected benefit to the simplest alternatives the user could do instead — including doing nothing.

Specific things to flag:
- The do-nothing / passive baseline (what happens with no system at all)
- The naive / simple-rule baseline (a one-line heuristic often captures most of the value)
- Off-the-shelf or managed alternatives
- Operator opportunity cost (build + monitoring time vs. the upside)
- Honest decision: when does the system win vs. lose vs. the baseline?
- Do not skip this — many "successful" systems still lose to the obvious baseline.

## The most important rule

**Verify every load-bearing numerical claim.** Strategy/system evaluations are dominated by "this gets X% success" or "this lifts Y%" claims. If the source is a single post, a vendor's own blog, or an unreplicated one-off result, downweight aggressively. Demand 2+ independent confirmations for any number that materially affects the final assessment.

A single promotional headline number taken at face value is the most common reason these evaluations come out overconfident.

## Synthesis output structure

For strategy/system evaluations:

1. **TL;DR with honest verdict** — does this work? Is it net-positive after real costs? Does it beat the baseline?
2. **Validated edges** — components with real, independent evidence
3. **Falsified or downweighted claims** — what failed verification
4. **Realistic expectancy math** — success rate, payoff, costs, expected outcome, worst case, all post-haircut
5. **Comparison to baseline** — explicit
6. **Worst-case / ruin analysis** — quantitative
7. **What would change the verdict** — explicit list of things that move confidence up or down
8. **Decision tree** — "Build this if A, don't build if B, build it differently if C"

## The standard confidence ladder

Use this calibration explicitly in the executive briefing:

- **1–3/10**: Demonstrably broken, or no real evidence
- **4/10**: Plausible mechanism, validation incomplete, will probably lose to the baseline
- **5/10**: Plausible mechanism, partial validation, coin-flip vs. baseline after costs
- **6/10**: Documented edge, clean execution path, favored to beat the baseline in most conditions
- **7/10**: Multiple independent edge sources combined, rigorous validation, favored over a long horizon — rare for a self-built system
- **8/10+**: Reserved for thoroughly-validated, independently-confirmed work. Rare.

Most evaluations land at 4–6. Be honest. The base rate — most clever systems fail to beat the simple baseline once real costs are in — is the gravitational pull working against everyone.

## Common silent overconfidence sources

These appear in nearly every evaluation:

1. **Marketing / vendor success rates** taken at face value
2. **Costs set to zero or near-zero** in the test when reality is materially higher
3. **Optimistic execution assumptions** (100% success/fill when reality is partial)
4. **No multiple-comparisons correction** when many variants were tried and only the best reported
5. **Sample size too small** to claim significance
6. **Survivorship bias** in cited successes — for every winner shown, the many who tried the same and failed are invisible
7. **Selection bias in the time/segment window** — almost anything works in *some* window
8. **Capacity unconsidered** — works at small scale, breaks at the scale you'd actually run
9. **Favorable-conditions bias** — looks great in the environment it was built in, fails when conditions turn
10. **Missing the obvious baseline** — the system "wins" but a simpler or passive option would have won by more

The red-team agent's primary job is to surface these.

## Executive briefing for strategy/system evaluation

Be brutally honest — the user is about to commit time or capital, and soft answers cost them.

```
## Bottom line up front
[Will this work? Will it beat the baseline? Honest answer.]

## Honest probability of net-positive outcome after real costs
[Number with reasoning]

## Honest probability of beating the simple / do-nothing baseline over the long run
[Number with reasoning — usually lower than the "does it work at all" number]

## Validated edge sources
[What has real, independent evidence]

## Falsified or unverified claims
[What didn't survive verification]

## Realistic expectancy math
[Numbers post-haircut: success rate, payoff, frequency, costs, expected outcome, worst case]

## Comparison to baseline
[Specific table: this system vs. do-nothing vs. the simple alternative]

## Decision tree
[Build it if X, don't build if Y, build differently if Z]
```

The user's job is to read this and make a commit/allocate decision. Bury nothing.
