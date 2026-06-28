---
name: medical-research-ops
description: Use when starting, evaluating, creating, managing, analyzing, or reporting a medical research project; when a topic needs evidence-backed feasibility assessment; or when public datasets, AutoDL, email delivery, or multiple research agents must be coordinated.
---

# Medical ResearchOps

## Overview

Coordinate medical research through auditable artifacts rather than conversational
memory. Use the deterministic CLI for state changes and existing specialist skills
for literature, datasets, statistics, NGS, writing, and review.

ResearchOps root: the cloned repository root, or the path supplied with
`researchops --root`.

## Route the Request

| User intent | Action |
|---|---|
| Explore or assess a topic | Create a deep-dive dossier |
| Approve a feasible topic | Create a registered project |
| Plan or run analysis | Create/read an analysis plan, then route to specialist skills |
| Interpret results or write | Create/read a report artifact and cite source outputs |
| Need GPU | Prepare an AutoDL bundle; stop before upload or paid compute |
| Need email | Create an email preview; stop before sending |

Run commands from the ResearchOps root:

```powershell
python -m researchops.cli --root . deep-dive <topic-id> --topic "<topic>"
python -m researchops.cli --root . agent-plan <topic-id> --topic "<topic>"
python -m researchops.cli --root . create-project <project-id> --title "<title>" --approved-by-user
python -m researchops.cli --root . analysis <project-id> --name primary
python -m researchops.cli --root . report <project-id> --name initial
python -m researchops.cli --root . validate <project-id>
python -m researchops.cli --root . health-all
```

## Evidence Rules

1. Record search dates, queries, source URLs, DOI/PMID, and dataset accessions.
2. Verify public availability and analytical suitability separately.
3. Do not invent citations, sample sizes, journal metrics, variables, or results.
4. Label planned, exploratory, negative, and inconclusive findings.
5. Cite an output path for every numeric result used in a report.

Read [workflow-contract.md](references/workflow-contract.md) before formal project
creation or analysis. Read [integrations.md](references/integrations.md) before
AutoDL, email, Zotero writes, or multi-agent work.

## Approval Gates

Stop and obtain explicit user approval before:

- formal project creation after a deep-dive;
- changing a locked protocol, primary outcome, or primary analysis;
- uploading any data to cloud services or starting paid compute;
- importing or modifying Zotero records;
- sending email, submitting work, or contacting collaborators.

Preparation and previews do not imply approval.

## Specialist Routing

- Broad evidence and public dataset discovery: use Life Science Research.
- Sequencing inputs or pipelines: use Life Sciences NGS Analysis.
- Local references and citations: use Zotero, with writes approval-gated.
- Code, versioning, CI, and publication: use GitHub.
- Methods and reporting: use statistical-analysis and scientific-writing when available.

For multi-agent work, split only independent read-only lanes such as literature,
datasets, methods, and reviewer critique. Keep scope decisions, evidence conflicts,
scientific approval, and final synthesis with the coordinating agent.
