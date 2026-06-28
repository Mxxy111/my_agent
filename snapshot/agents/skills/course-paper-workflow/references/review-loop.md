# Lightweight Review Loop

Use this file whenever a course-paper stage needs critique before advancing.

## Loop Shape

1. Freeze the current artifact: topic list, argument contract, outline, draft, or final paper.
2. Review only against the assignment requirements and the current stage.
3. Return findings ordered by severity.
4. Revise the artifact.
5. Record what changed and what risk remains.
6. Repeat only the necessary reviewers.

For most course papers, inline reviewer passes are enough. Use subagents only when available and useful.

## Reviewer Roles

| Stage | Reviewer Focus |
|---|---|
| Requirements | assignment fit, hidden rubric expectations, missing prompt details |
| Topic | feasibility, course fit, arguability, source availability |
| Thesis | specificity, debatable stance, "so what", scope |
| Source plan | source quality, course reading use, citation risk |
| Outline | argument flow, section jobs, evidence distribution |
| Draft | thesis alignment, paragraph logic, evidence analysis, transitions |
| Humanization | AI-flavor, natural academic voice, meaning/citation drift |
| Final | rubric fit, citations, formatting, word count, submission readiness |

## Inline Reviewer Template

```text
Reviewer: <role>
Gate decision: pass / revise / blocked
Major issues:
- ...
Minor issues:
- ...
Required revisions:
- ...
Remaining risk:
- ...
```

## Review Ledger

```markdown
| Date | Stage | Reviewer | Gate | Key Findings | Action Taken | Remaining Risk |
|---|---|---|---|---|---|---|
```
