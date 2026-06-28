# Capability Map

Use this map during preflight. Capabilities may be loaded lazily; if a named tool is not currently visible, use `tool_search` first.

Also read `skill-routing.md` to choose existing specialist skills by workflow stage. Prefer invoking an existing skill over re-implementing its process inside this skill.

## Orchestration And Review

| Need | Capability |
|---|---|
| Independent review, parallel evidence lanes, code review | Search for currently exposed subagent tools with `tool_search`; in many Codex sessions this is `multi_agent_v1.spawn_agent`, `wait_agent`, and `close_agent`, but use the exact namespace exposed in the active session |
| Thread-level continuation | Search for thread tools first; use them only when the user explicitly asks for new/forked threads and callable tools are present |
| Long-running follow-up | Search for automation tools first; use them only when the user asks for reminders/monitors/recurring work and callable tools are present |

Subagents are best for bounded, independent read/review tasks. Keep scope decisions, user approval, conflict resolution, and final synthesis with the coordinating agent. If the user asked for subagents but no subagent tool is available after discovery, state that limitation and use the inline reviewer fallback from `review-loop.md`.

## Literature And Citations

| Need | Capability |
|---|---|
| Peer-reviewed literature search | Consensus MCP (`mcp__codex_apps__consensus` or `mcp__consensus`) |
| Deep academic workflows | `academic-research-skills:academic-research-suite` |
| Current facts, journal guidelines, public web sources | Web browsing with source links; for journal/venue rules, use official author-guideline pages first |
| Local reference library | `zotero:Zotero` helper commands |
| PDFs and visual page checks | `pdf:pdf` plus bundled `pypdf`, `pdfplumber`, Poppler when available |
| Citation metadata verification | DOI/Crossref/PubMed/official journal pages through web or relevant research tools |

Do not cite search results without fetching/verifying enough metadata. For unstable "latest" facts, browse current sources.

## Life Science And Bioinformatics

| Need | Capability |
|---|---|
| Broad life-sciences routing | `life-science-research:research-router-skill` |
| Literature and dataset discovery | NCBI Entrez/PMC, BioStudies/ArrayExpress, NCBI Datasets, biorxiv skills when available |
| Gene/protein/variant/target lookups | Ensembl, UniProt, ClinVar, gnomAD, OpenTargets, GWAS Catalog, GTEx, Human Protein Atlas skills |
| Clinical/cancer evidence | ClinicalTrials, cBioPortal, CIViC, PharmGKB skills |
| Sequencing files and pipelines | `ngs-analysis:ngs-analysis-router`, then the assay-specific NGS skill |
| Local code execution | Shell, bundled Python/Node, R if installed, Git/GitHub for versioning |

For raw sequencing or count-matrix inputs, inspect files before asking broad questions. For human/private data, confirm cloud upload permissions before suggesting cloud compute.

## Data, Figures, And Reports

| Need | Capability |
|---|---|
| Data analysis, tables, charts, dashboards | Data Analytics skills and `mcp__datascienceWidgets` render/validate tools; validate artifacts before rendering, keep snapshots bounded, and require `manifest.title` plus `manifest.blocks` |
| Spreadsheet deliverables | `spreadsheets:Spreadsheets` and `codex_app.load_workspace_dependencies` |
| Scientific figures | local Python/R plotting, `nature-figure`, generated raster images when appropriate, Mermaid for workflows |
| Image generation/editing | `image_gen` for generated raster assets; record generated status in provenance |
| Visual QA | render output to PNG/PDF where relevant and inspect before delivery |

Every figure/table used in a paper needs provenance, caption, and text cross-reference.

## Manuscript And Submission Artifacts

| Need | Capability |
|---|---|
| DOCX/Word/Google Docs-targeted output | `documents:documents` and bundled workspace dependencies |
| PDF creation/inspection | `pdf:pdf` |
| PowerPoint or defense deck | `presentations:Presentations` |
| LaTeX build | LaTeX skills when `.tex` or journal templates are required |
| GitHub repository/code publication | GitHub plugin/tools and local git commands |

For DOCX/PDF/PPTX, render and visually inspect before claiming the artifact is ready. If visual QA cannot run, disclose that limitation.

## Local Runtime Discovery

Use `codex_app.load_workspace_dependencies` before serious DOCX/XLSX/PPTX/PDF artifact work when that callable is available. If it is absent, use the relevant document/spreadsheet/presentation/PDF skill's own runtime guidance and state the degraded route. For code projects, inspect local runtimes (`python`, `R`, `node`, package managers), analysis-critical packages, disk space, network/download policy, credential needs, and data sensitivity before promising runnable analysis. For reproducible computational papers, create or update one of: `environment.yml`, `requirements.txt`, `renv.lock`, `package.json`, or a plain `env/runtime_notes.md`, depending on the project stack and what is actually available.

## Approval-Sensitive Actions

Ask explicit chat approval before:

- installing packages or changing environments
- downloading datasets, reference genomes, software, model weights, or databases beyond ordinary web-page/PDF reading; state expected size when known
- using credentialed APIs or account-gated resources
- uploading or sending data/metadata to web, MCP, cloud, or external services
- running paid compute or long-running jobs
- writing outside the workspace
- modifying Zotero libraries or submitting/publishing/contacting others
