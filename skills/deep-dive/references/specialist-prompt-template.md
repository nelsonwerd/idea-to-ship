# Specialist Agent Prompt Template

Every specialist agent dispatched during Phase 1 of a deep dive receives a prompt built from this template. Substitute the bracketed placeholders.

The template is intentionally explicit. Specialist agents are instantiated fresh — they have no memory of the parent conversation. Treat each prompt like a self-contained brief to a smart colleague who just walked into the room.

## Template

```
You are one of [N] specialist research agents working on [project / scope summary in 1-2 sentences]. Your lane is [SPECIFIC LANE — e.g., "the core decision logic itself" or "data ingestion, normalization, and the external-API integration"]. The other [N-1] agents are covering [BRIEFLY LIST OTHER LANES] — stay focused on your lane and do not duplicate their work.

CONTEXT: [2-4 sentences setting the stage. What was built or what is being asked. Where the relevant files live. Any prior research the user has done. Constraints the user has stated.]

YOUR JOB: [Restate the objective sharply. Be honest about whether the answer might be "this doesn't work" — the agent should not feel pressure to find positive results.]

EVALUATE / RESEARCH:

1. [First evaluation area with specific sub-questions]
   - Sub-question
   - Sub-question
   - What sources to check

2. [Second area]
   - ...

[Continue for 6-12 areas as appropriate to the scope.]

For any load-bearing numerical claim, find at least 2 independent sources confirming the value. Single-source claims (especially marketing tweets or vendor blogs) must be flagged for follow-up verification, not accepted at face value.

For code review work: provide file:line references for every specific finding.

Categorize all findings by severity:
- Blocker (must fix before any forward motion)
- High (must fix before scaling)
- Medium (should fix)
- Low (hygiene)
- Note (observation only)

OUTPUT: Write a detailed analysis to `[ABSOLUTE FILE PATH — e.g., /Users/X/project/research/topic/NN-lane-name.md]`. Target [2500-6000] words. Use clear sectioning. Use inline citations like [source: <url>] for non-trivial claims.

End your turn with:
1. A 250-word executive summary
2. The top 5 most concerning findings (or top 5 strongest validated points if it's a positive review)
3. Honest 1-10 confidence rating with explicit reasoning. Avoid marketing-grade numbers. If the answer is "I don't have enough evidence to be confident", say so.

CRITICAL:
- This is research/analysis only — do NOT modify any source code unless the parent prompt explicitly authorized it.
- Read actual code/sources carefully; don't skim. Use multiple Read calls if needed for large files.
- Be skeptical. Your value is in catching errors, not validating optimism.
- The user is sophisticated and wants the honest answer, not a diplomatic one. If the conclusion is "this doesn't work" or "the evidence isn't there", say so clearly.
```

## Key principles encoded in the template

### Anti-duplication

Stating what other agents are NOT covering prevents agents from drifting into adjacent territory and producing redundant work. It also signals scope boundaries clearly.

### Single-lane focus

Each specialist must produce 2500-6000 words of focused, deep analysis on ONE lane. Spreading across multiple lanes produces shallow work everywhere.

### Severity tiers

Forcing every finding into a tier prevents the common failure mode of "the agent produced a long list of issues with no prioritization signal." The user can ignore Notes; they cannot ignore Blockers.

### Source verification

The single-most-important rule. Multiple deep dives I've seen failed because a specialist accepted a marketing number (e.g., a "10x faster" figure from a vendor's own blog) at face value, weighted it heavily in the synthesis, and only follow-up verification revealed it was a single unverified source with no methodology.

### Confidence with reasoning

A bare 1-10 number is meaningless. The reasoning is what makes it useful. "5/10 because the underlying signal is plausible but the cited effect size is from a single un-replicated source" tells the synthesis agent exactly how to weight the input.

### No code changes by default

This is a safety default. Deep dives often run while concurrent code work is happening. Silent code edits from a specialist destroy the user's other workstreams.

### Explicit honesty mandate

The phrase "If the answer is 'this doesn't work', say so clearly" combats the pattern where agents soften negative findings to avoid sounding pessimistic. Most users prefer honest negative findings to softened ones — they're trying to make decisions, not feel good.

## Variants for different scopes

### For code/system audits

Add to "EVALUATE":
- File:line references for every finding
- A "what does NOT work" section (subtractive findings)
- A "common silent-bug categories to hunt for" list specific to the domain

### For strategy / quantitative analysis

Add to "EVALUATE":
- Quantitative effect size with confidence intervals
- Comparison to a baseline (the do-nothing / naive-rule alternative)
- Honest realistic success rate after real-world costs (not the marketing number)
- "Where does this fail" section

### For open research questions

Add to "EVALUATE":
- Cite Google Scholar / SSRN / arXiv for academic claims
- Cite at least 2 independent sources per non-trivial claim
- Distinguish "marketing claim" from "peer-reviewed finding"
- Surface dissenting views the question may have

### For design evaluations

Add to "EVALUATE":
- Alternative approaches that were not taken
- Trade-offs implicit in the design
- Failure modes under stress
- Whether the design's assumptions hold

## Calibration: how big should specialist output be?

| Scope | Words per specialist | Total package |
|---|---|---|
| Narrow question (single feature, single decision) | 1500-2500 | ~10k |
| Single subsystem audit | 3000-5000 | ~25-40k |
| Full codebase audit | 4000-6000 | ~30-60k |
| Multi-domain research | 4000-6000 | ~40-80k |

Bigger is not better. A focused 3000-word specialist produces more actionable findings than an unfocused 8000-word one. Push back on bloat.
