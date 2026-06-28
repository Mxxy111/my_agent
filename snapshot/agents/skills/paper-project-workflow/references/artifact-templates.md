# Project Artifact Templates

Use these as concise operational records. Adapt headings to the user's language.

## capability_preflight.md

```markdown
# Capability Preflight

## Tool Discovery

| Need | Tool/Skill Found | Status | Degraded Route |
|---|---|---|---|

## Local Runtime

| Runtime/Tool | Probe Command | Result | Notes |
|---|---|---|---|

## Package Probes

| Language | Package | Required For | Import/Version Result | Action |
|---|---|---|---|---|

## System Constraints

| Constraint | Status | Notes |
|---|---|---|
| Disk space |  |  |
| RAM/runtime estimate |  |  |
| Network/download policy |  |  |
| Credential/API needs |  |  |
| Data sensitivity |  |  |
| Renderer availability |  |  |

## Approval Needed

| Action | Exact Command/Route | Size/Cost/Risk | User Approved? |
|---|---|---|---|

## Not Checked
```

## project_brief.md

```markdown
# Project Brief

## User Goal

## Paper Type And Audience

## Hard Requirements

## User Preferences

## Available Materials

## Analysis/Data Needs

## Approval Gates

## Open Questions

## Initial Route
```

## project_contract.md

```markdown
# Project Contract

## Paper Type / Archetype

## Reader Contract

| Reader Question | Project Answer |
|---|---|
| Why is this relevant? |  |
| What is new or useful? |  |
| Why should the reader trust it? |  |
| What can be reused or acted on? |  |
| What does it mean, and where does it stop? |  |

## One-Sentence Argument

In [system/problem], this paper [argues/shows/proposes] [advance] using [approach/evidence], bounded by [limits].

## Evidence Route

## Source Hierarchy

## Output Contract

## Traceability Plan

| Object | ID Pattern | Where Recorded |
|---|---|---|
| Claim | C001 | claim_evidence_map.md |
| Source | S001 | literature_matrix.md / source_trace_map.md |
| Figure/Table | F001/T001 | figure plan / results_index.md |
| Data/Result | O001 | results_index.md |
| Review Comment | R1.1 | review_log.md / response tracker |
```

## requirements_matrix.md

```markdown
# Requirements Matrix

| Requirement | Source | Must/Should | How We Will Satisfy It | Verification |
|---|---|---|---|---|

## Rubric/Reviewer Expectations

## Prohibited Moves

## Submission Requirements
```

## topic_candidates.md

```markdown
# Topic Candidates

| Candidate | Research Question | Claim/Hypothesis | Evidence Path | Novelty | Feasibility | Risk | Score |
|---|---|---|---|---|---|---|---|

## Recommended Topic

## Rejected Or Deferred Topics

## User Approval
```

## decision_log.md

```markdown
# Decision Log

| Date | Decision | Options Considered | Reason | User Approved? |
|---|---|---|---|---|
```

## review_log.md

```markdown
# Review Log

| Date | Stage | Reviewer | Gate | Key Findings | Action Taken | Remaining Risk |
|---|---|---|---|---|---|---|
```

## style_revision_log.md

```markdown
# Style Revision Log

| Date | Draft Version | Skill/Reviewer | Sections Revised | AI-Flavor Or Style Issues | Changes Made | Integrity Check | Remaining Risk |
|---|---|---|---|---|---|---|---|

## Claim/Citation Drift Check

| Section | Original Claim | Revised Claim | Citation/Data Changed? | Verified? | Notes |
|---|---|---|---|---|---|
```

## literature_matrix.md

```markdown
# Literature Matrix

| Key | Citation | Type | Main Finding | Methods/Data | Strength | Limitation | Claim Supported | Verification |
|---|---|---|---|---|---|---|---|---|

## Search Log

| Date | Database/Tool | Query | Filters | Notes |
|---|---|---|---|---|
```

## claim_evidence_map.md

```markdown
# Claim-Evidence Map

| Claim ID | Section | Claim | Evidence Anchor | Source/Data/Figure | Claim Strength | Boundary/Limitation | Status |
|---|---|---|---|---|---|---|---|

## Unsupported Or Deferred Claims

| Claim | Problem | Action |
|---|---|---|
```

## source_trace_map.md

```markdown
# Source Trace Map

| Source ID | Type | Citation/Path | DOI/PMID/URL/Page | Used For | Verification Status | Notes |
|---|---|---|---|---|---|---|

## Figure/Table Trace

| ID | Source | Page/Panel/File | Manuscript Location | Caption Status | Provenance Notes |
|---|---|---|---|---|---|

## Reviewer Comment Trace

| ID | Reviewer/Editor Comment | Response Location | Manuscript Change | Evidence/Source | Status |
|---|---|---|---|---|---|
```

## analysis_plan.md

```markdown
# Analysis Plan

## Research Question

## Data Sources

## Inclusion/Exclusion

## Primary Outcome/Analysis

## Secondary/Exploratory Analyses

## Preprocessing And QC

## Statistics/Models

## Figures/Tables

## Reproducibility

## Risks And Fallbacks

## User Approval
```

## results_index.md

```markdown
# Results Index

| Result | File Path | Script/Notebook | Input Data | Key Finding | QC Status | Manuscript Use |
|---|---|---|---|---|---|---|
```

## final_checklist.md

```markdown
# Final Checklist

| Check | Status | Evidence/Path | Notes |
|---|---|---|---|

## Remaining Risks

## Final Deliverables
```
