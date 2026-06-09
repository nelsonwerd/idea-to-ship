# Research Deep Dive Variant

Use when the user asks for thorough investigation of an open question — "research X", "deep dive on Y", "what should I know about Z before deciding". The output is structured evidence and a synthesized recommendation, not code.

## Recommended specialist lanes

Lanes vary heavily by topic. Use the user's question to define lanes that:
- Are substantively different (not overlapping)
- Have findable evidence (sources exist)
- Combine to answer the user's question

Common patterns:

### Pattern A: Topic mapping
For "research [topic]" questions, lanes typically include:
- **Lane 1: Empirical landscape** — what's been documented, with sources
- **Lane 2: Theoretical foundation** — why this works (or doesn't)
- **Lane 3: Practical implementation** — how it's done in practice
- **Lane 4: Failure modes / limitations** — when it breaks
- **Lane 5: Alternatives / competing approaches** — what else exists
- **Lane 6: Honest baseline** — does it actually beat doing nothing?

### Pattern B: Decision support
For "should I [decision]" questions:
- **Lane 1: Case for** — strongest argument supporting the decision
- **Lane 2: Case against** — strongest argument opposing
- **Lane 3: Alternatives** — what else could the user do
- **Lane 4: Cost / risk analysis** — what could go wrong, what does it cost
- **Lane 5: Honest baseline** — what happens if they do nothing

### Pattern C: Cross-domain investigation
For complex multi-domain questions (e.g., "should I build X on platform Y for use case Z?"), assign one specialist per major domain:
- Technical feasibility
- Economic viability
- Regulatory / legal posture
- Operational requirements
- Competitive landscape

## Source quality hierarchy

For research deep dives, source quality matters more than for code audits. Encode this in specialist prompts:

| Quality | Source types | How to treat |
|---|---|---|
| Strong | Peer-reviewed papers, replicated studies, large-N datasets, primary regulatory filings | Accept with normal caveats |
| Medium | Major news outlets, well-cited blog posts, industry reports from credible firms, primary data with documented methodology | Accept if 2+ sources confirm |
| Weak | Single-source claims, vendor marketing, anonymous social accounts, unreplicated one-off results | Treat as hypothesis only; flag for follow-up |
| Discount | Promotional content, undisclosed-methodology claims, viral but unverified posts | Mention but don't weight |

Specialists must categorize their sources. Single-quality-weak claims that materially affect the conclusion must be flagged for follow-up verification.

## Specialist prompt additions for research deep dives

Add these to the standard template:

```
For every non-trivial claim:
- Cite at least 2 independent sources of medium or higher quality
- Distinguish "this has been documented to work in [specific window]" from "this is widely believed to work"
- Surface dissenting views if they exist
- Note where the evidence is thin

For numerical claims:
- Cite the source and the methodology
- Note effect size, sample size, time window
- Apply realistic haircuts when the source is promotional

Where the literature contradicts itself, present both sides honestly. Do not silently pick a winner.
```

## Follow-up verification triggers

These are the patterns that should trigger follow-up verification specialists:

1. **Surprising magnitude** — a claimed effect far larger than what established work in the area shows. Verify.
2. **Single-source headline number** — one tweet, one vendor blog, one keynote. Verify.
3. **Recency claim** — "still works in 2024" with no recent data cited. Verify.
4. **Mechanism unexplained** — claim accepted without theory. Investigate the mechanism.
5. **Convenient story** — finding aligns suspiciously well with what the user wants to hear. Especially verify.

Don't skip follow-up verification on research deep dives. The synthesis agent will inherit specialist errors otherwise.

## Synthesis output structure

For research deep dives:

1. **TL;DR with honest answer** to the user's question
2. **Strongest validated findings** with source quality noted
3. **Falsified or downweighted claims** — what didn't survive verification
4. **Where the evidence is thin** — open questions
5. **Recommendation** — what should the user actually do?
6. **Decision tree** when the answer depends on the user's specifics
7. **What would change the recommendation** — explicit list

## Common pitfalls in research deep dives

1. **Asymmetric source treatment** — accepting confirming sources while scrutinizing dissenting ones (or vice versa)
2. **Recency bias** — over-weighting recent claims that haven't been replicated
3. **Anchoring on the first specialist's framing** — synthesis must read all specialists and reconcile, not just summarize sequentially
4. **Survivorship bias in case studies** — citing winners without noting how many tried and failed
5. **Selection bias in time windows** — most strategies work in some window
6. **Confusing correlation with mechanism** — explaining what a signal does, not whether it predicts

Encode these into the red-team agent's review checklist.

## Executive briefing for research deep dives

Lead with the answer, not with the journey:

```
## Bottom line up front
[Direct answer to the user's question]

## Honest confidence: N/10
[Why this number]

## What we know
[Strongest validated findings, with source quality]

## What we don't know
[Open questions, thin evidence, dissenting views]

## What this means for the user's decision
[Recommendation, with conditional branches]

## What would change this
[Explicit triggers for revisiting]
```

The user wants to make a decision. Help them decide.
