# Design Evaluation Variant

Use when the user asks to evaluate a design, architecture proposal, plan, prompt pack, or other forward-looking artifact (not yet built) for correctness, completeness, and feasibility.

## Recommended specialist lanes

Deploy 4–6 in parallel:

### Lane 1: Design intent and clarity
The agent reviews whether the design is internally consistent, whether requirements are stated clearly, whether ambiguous areas exist, and whether the design matches its own stated goals.

Specific things to flag:
- Internal contradictions
- Underspecified areas where a reader would need to guess
- Goals stated but not addressed
- Constraints stated but not enforced

### Lane 2: Assumption validation
The agent identifies every assumption the design makes — explicit and implicit — and checks which ones are validated, which are unvalidated, and which are likely wrong.

Specific things to flag:
- "X is true" claims with no supporting evidence
- "Y will be feasible" without a feasibility check
- Performance / capacity / cost assumptions
- Behavioral assumptions (users, markets, third-party services)
- Time / effort estimates

### Lane 3: Failure modes
The agent imagines stress scenarios and asks how the design behaves: load spikes, dependency outages, data corruption, adversarial inputs, operator error, regulatory changes.

Specific things to flag:
- Single points of failure
- Cascading failure modes
- Recovery paths missing
- Observability gaps
- Resource exhaustion modes

### Lane 4: Alternative approaches
The agent enumerates other designs the user could have chosen and assesses trade-offs.

Specific things to flag:
- Simpler alternatives that solve the same problem
- Off-the-shelf options the user is rebuilding
- Different architectural patterns (event-driven vs request-reply, monolith vs microservices, etc.)
- The "do nothing" alternative

### Lane 5: Feasibility / cost / timeline
The agent stress-tests the project's projected effort, cost, and dependencies.

Specific things to flag:
- Tasks that look 1 day but are 1 week
- External dependencies (APIs, data sources) that might not materialize
- Skill / personnel requirements
- Realistic timeline including review cycles and rework

### Lane 6: Acceptance criteria quality
The agent reviews whether the design's "done" criteria actually prove the work is correct, or whether they admit trivially-passing implementations.

Specific things to flag:
- Tests that test only the happy path
- Acceptance criteria like "tests pass" without specifying what tests
- Missing safety / failure-mode tests
- Vague success metrics ("works well")
- No measurable invalidation criteria

## Prompt pack / instructional design specifics

When the design IS a prompt pack (instructions for an agent or downstream model to execute):

Add a specialist lane:

### Lane 7: Adversarial agent interpretation
The agent imagines what could go wrong if a downstream LLM interprets each prompt slightly creatively. What's the worst plausible reading? Does the prompt protect against it?

Specific things to flag:
- Ambiguities that allow multiple valid interpretations
- Acceptance criteria that admit trivially-passing implementations
- Missing safety constraints
- Prompts that ask for code in areas where research was intended
- File path or naming ambiguity
- Order dependencies between prompts that aren't stated

This lane is specific to instructional / agentic designs — where the "reader" is another agent that will act on the text. Example failure it catches: a prompt that says "update the config" when two different files could plausibly match, so the agent edits the wrong one.

## Synthesis output for design evaluations

```
## Verdict
[Is this design sound? Ready to execute? Major gaps?]

## What the design gets right
[Genuine strengths]

## Critical gaps
[Blockers with specific recommendations]

## Hidden assumptions to validate before executing
[Itemized list with evidence requirements]

## Alternative approaches worth considering
[If the design makes a choice that has a clearly-better alternative]

## Realistic effort / timeline assessment
[Honest comparison to the design's stated estimates]

## Recommended pre-execution edits
[Specific surgical changes to make the design executable]
```

## Red-team for design evaluations

Special focus areas:

1. **Did the design's specialist reviewers catch what the design author missed?** (Authors often have blind spots specialists share.)
2. **Are the recommended pre-execution edits actually surgical?** Or are they secretly structural rewrites?
3. **What's the worst plausible interpretation of any ambiguous section?** And does the design protect against it?
4. **Are the acceptance criteria robust to creative implementation?**

## Executive briefing for design evaluations

Lead with whether the design is ready to execute as-is or needs edits first:

```
## Bottom line
[Ready to execute / needs edits / requires structural rework]

## What this design gets right
[Genuine strengths]

## What must be fixed before execution
[Tier 0 edits, specific and surgical]

## What should be fixed before scaling
[Tier 1 edits]

## What could be fixed for hygiene
[Tier 2]

## Hidden assumptions to validate
[List with evidence requirements]

## Honest timeline assessment
[Stated vs realistic]
```

The user is about to invest effort executing this design. The briefing's job is to tell them whether to start now or to fix things first.
