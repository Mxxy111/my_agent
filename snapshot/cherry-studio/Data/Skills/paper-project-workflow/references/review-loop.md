# Objective Review Loop

Use this file whenever a stage needs independent critique before advancing.

## Loop Shape

1. Freeze the current artifact for review.
2. Give reviewers only the user requirements, current artifact, and the review role.
3. Ask for findings, risks, required changes, optional improvements, and a pass/fail gate.
4. Synthesize findings without erasing dissent.
5. Revise the artifact.
6. Record what changed and which issues remain.
7. Repeat until the stage passes or the user accepts the residual risk.

Do not pass the intended answer, your preferred conclusion, or your own diagnosis to a subagent unless the review explicitly requires it.

## Reviewer Roles

Use the smallest useful set.

| Stage | Reviewer |
|---|---|
| Topic selection | topic feasibility, novelty/collision risk, evidence sufficiency, rubric/venue fit |
| Literature matrix | source verification, recency/coverage, counterevidence, citation metadata |
| Analysis plan | methods/statistics, bioinformatics pipeline, reproducibility, ethics/privacy |
| Code/results | code correctness, QC/statistics, result interpretation, figure integrity |
| Draft | logic/novelty, field terminology, reviewer skepticism, writing clarity |
| Final package | citation/format, figure/table, AI disclosure, submission checklist |

## Subagent Prompt Template

Use when subagents are allowed:

```text
You are an independent reviewer for a paper project. Review the artifact below against the user requirements. Do not rewrite the artifact unless needed to demonstrate a fix. Return:
1. Pass/fail gate decision
2. Major issues, ordered by severity
3. Minor issues
4. Missing evidence or assumptions
5. Concrete required revisions
6. Residual risk if revised as suggested

User requirements:
<requirements>

Artifact under review:
<artifact or file paths>

Review focus:
<role-specific focus>
```

For code or bioinformatics analysis, ask the reviewer to inspect file paths, logs, outputs, and figures where available, not only prose.

## Inline Reviewer Fallback

If subagents are not available or not permitted, run separate labeled passes in the main conversation:

- "Reviewer A: feasibility"
- "Reviewer B: evidence"
- "Reviewer C: methods"

State that these are not fully independent subagent reviews.

## Review Ledger

Track reviews with this compact schema:

```markdown
| Date | Stage | Reviewer | Gate | Key findings | Action taken | Remaining risk |
|---|---|---|---|---|---|---|
```

Use "blocked" when a missing source, missing data, or user decision prevents a valid review.
