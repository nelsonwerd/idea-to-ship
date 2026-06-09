# Strategy Evaluation Variant

Use when the user asks to evaluate, audit, or analyze a quantitative trading strategy, betting system, or other formal decision system. Focus is on whether the strategy has real edge and whether the claimed performance is honest.

## Recommended specialist lanes

Deploy 4–6 in parallel:

### Lane 1: Multi-timeframe or technical strategy logic
For chart-based strategies. The agent audits the indicator stack, regime classification, entry/exit rules, parameter sensitivity, and what does/doesn't actually work for the asset class on the relevant timeframes.

Specific things to flag:
- Indicator math correctness (Wilder vs EMA smoothing, etc.)
- Lookahead in rule construction
- Knife-edge thresholds
- Parameter stability across regime changes
- Honest assessment of edge: does this beat always-flat? Does it beat buy-and-hold?
- Strategies that look profitable but are documented to fail (e.g., RSI mean reversion on 5min crypto)

### Lane 2: Microstructure / derivatives signals
For strategies on liquid markets with derivatives. The agent catalogs and quantifies the predictive value of order flow, funding rates, open interest, cumulative volume delta, basis, options skew, liquidations, exchange flows, ETF flows, cross-venue signals.

Specific things to flag:
- Which signals have peer-reviewed evidence vs vendor-blog claims
- Realistic effect sizes (typically much smaller than marketing claims)
- Post-regime-change persistence (does it still work after ETF launch / institutional adoption / venue migration?)
- Single-source claims that need verification (the biggest source of overconfidence)

### Lane 3: Execution and venue mechanics
The agent audits the proposed venue, fee structure, depth of book, maker fill rate reality, slippage assumptions, what existing bots do that the user would be competing against.

Specific things to flag:
- Maker vs taker fee schedules (often the single decisive economic factor)
- Realistic fill rates (taking quotes at the touch != 100% fill)
- Toxic flow / adverse selection on the venue
- Latency reality for retail (always behind co-located MMs)
- Capacity / what AUM does the strategy break at
- Regulatory accessibility (some venues are US-restricted)

### Lane 4: Validation / backtesting methodology
The agent audits the backtest methodology: lookahead, friction modeling, walk-forward, CPCV, deflated Sharpe, bootstrap CIs, multiple-testing correction. This is the single highest-ROI lane because most strategies die in the backtest-to-live haircut.

Specific things to flag:
- Lookahead bias mechanisms
- Optimistic fill assumptions
- Friction modeling realism vs actual venue fees
- Out-of-sample reservation (separate from validation)
- Multiple-testing correction (every parameter tested counts)
- Sample-size adequacy
- Deflated Sharpe vs naive Sharpe
- Backtest-to-live haircut estimate

### Lane 5: Risk management and capital efficiency
The agent audits position sizing, drawdown control, kill switches, expected drawdown, risk of ruin, capital allocation framework.

Specific things to flag:
- Kelly vs fractional Kelly vs fixed-fractional sizing
- Drawdown throttling
- Stop placement (not at known liquidity levels)
- Risk of ruin calculation
- Hard caps that cannot be silently bypassed
- Honest expected max drawdown

### Lane 6: Honest baseline comparison
The agent compares the strategy's projected return/risk to simpler alternatives the user could do instead.

Specific things to flag:
- Passive buy-and-hold of the underlying
- DCA into the underlying
- Yield-enhanced HODL (covered calls)
- Professional managed alternatives (crypto hedge funds, ETFs)
- Honest decision: when does the strategy win vs lose vs passive?
- Operator opportunity cost (developer time, monitoring overhead)
- Do not skip this — most "profitable" strategies still lose to the passive baseline

## The most important rule

**Verify every load-bearing numerical claim.** Strategy evaluations are dominated by "X has Y% win rate" claims. If the source is a single tweet, vendor blog, or unreplicated study, downweight aggressively. Demand 2+ independent confirmations for any number that materially affects the final assessment.

The Hyblock-style "68.8% win rate from a single X post" failure mode is the single most common reason deep dives produce overconfident strategy evaluations.

## Synthesis output structure

For strategy evaluations:

1. **TL;DR with honest verdict** — does this work? Is it net-positive after costs? Does it beat the baseline?
2. **Validated edges** — signals/components with real evidence
3. **Falsified or downweighted claims** — what failed verification
4. **Realistic expectancy math** — win rate, R:R, fees, expected monthly return, expected drawdown, all post-haircut
5. **Comparison to baseline** — explicit
6. **Risk of ruin** — quantitative
7. **What would change the verdict** — explicit list of things that would push confidence up or down
8. **Decision tree** — "Build this if A, don't build if B, build it differently if C"

## The standard confidence ladder for strategy evaluation

Use this calibration explicitly in the executive briefing:

- **1–3/10**: Demonstrably broken or no evidence
- **4/10**: Plausible mechanism, validation incomplete, will probably lose to baseline
- **5/10**: Plausible mechanism, partial validation, coin-flip vs baseline after costs
- **6/10**: Documented edge components, clean execution path, favored to beat baseline in most regimes
- **7/10**: Multiple independent edge sources combined, validation rigorous, favored to beat baseline over multi-year window — RARE for retail systematic strategies
- **8/10+**: Essentially nonexistent for retail systematic strategies in 2024+. Reserved for inst-grade work.

Most evaluations land at 4–6. Be honest. The 70%-of-pro-funds-fail-to-beat-HODL stat is the gravitational pull working against everyone.

## Common silent overconfidence sources

These appear in nearly every strategy evaluation:

1. **Vendor / marketing win rates** taken at face value
2. **Backtest fees set to zero or near-zero** when reality is 40-60 bps
3. **Optimistic maker fill assumptions** (100% when reality is 35-70%)
4. **No multiple-testing correction** when 100 parameter combinations were tested
5. **Sample size too small** to claim significance
6. **Survivorship bias** in cited "successful traders" — for every Wynn there are 1000 who blew up
7. **Selection bias** in time windows — strategy works in 2021-2023 then fails
8. **Capacity unconsidered** — strategy works at $1k but breaks at $1M
9. **Long-only bias** — strategy looks good in a bull market, would lose in 2018 or 2022
10. **Missing the obvious baseline** — strategy returns 30%/yr but BTC returned 70%/yr same period

The red-team agent's primary job is to surface these.

## Executive briefing for strategy evaluation

Critical to be brutally honest. The user is trying to allocate capital; soft answers cost them money.

```
## Bottom line up front
[Will this work? Will it beat baseline? Honest answer.]

## Honest probability of net-positive EV after costs
[Number with reasoning]

## Honest probability of beating the passive baseline over 3+ years
[Number with reasoning — usually much lower than the EV number]

## Validated edge sources
[What has real evidence]

## Falsified or unverified claims
[What didn't survive verification]

## Realistic expectancy math
[Numbers post-haircut: win rate, R:R, trades/day, fees, expected monthly return, max DD]

## Comparison to baseline
[Specific table: this strategy vs HODL vs covered calls vs T-bills]

## Decision tree
[Build it if X, don't build if Y, build differently if Z]
```

The user's job is to read this and make a capital allocation decision. Bury nothing.
