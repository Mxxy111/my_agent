# Specialist Skill Routing

Use this map before each major stage. `paper-project-workflow` coordinates the project; specialist skills do the domain work. Do not load every skill. Select the smallest set that matches the current stage and read each selected `SKILL.md` before applying it.

Skill names may appear with plugin prefixes in the active session, for example `academic-research-skills:academic-research-suite`, `zotero:Zotero`, `documents:documents`, or `ngs-analysis:ngs-analysis-router`. If a listed skill is not visible, search for it with `tool_search` or inspect local skill metadata.

## Core Academic Workflow

| Stage | Prefer These Skills | Use For |
|---|---|---|
| Broad research pipeline | `academic-research-skills:academic-research-suite` | deep research, literature reviews, manuscript review, full research-to-paper workflows, experiment planning |
| Scientific manuscript drafting | `scientific-writing` | IMRAD structure, full-prose drafting, citations, figures/tables, reporting guidelines |
| General research writing | `research-writing`, `nature-writing` | academic argument, Chinese/English research prose, Nature-style framing when appropriate |
| Topic narrowing | `idea-refine`, `academic-research-suite` Socratic/deep-research route | turn broad interests into answerable questions |
| Medical project operations | `medical-research-ops`, `institutional-medical-literature-review` | medical research feasibility, audit trail, dataset/evidence governance |

## Literature, Citation, And Paper Reading

| Need | Prefer These Skills |
|---|---|
| Local library and BibTeX | `zotero:Zotero` |
| PDF extraction/inspection | `pdf:pdf`, `nature-reader`, `paper-analyzer` |
| Literature search and source checking | `academic-research-suite`, `nature-academic-search`, `institutional-medical-literature-review` |
| Citation style and reference integrity | `nature-citation`, `academic-research-suite`, `scientific-writing` |
| Paper-to-notes or deep paper explanation | `paper-analyzer`, `nature-reader`, `paper-comic` |

## Drafting, Polishing, And Review

| Need | Prefer These Skills |
|---|---|
| Reviewer simulation and manuscript critique | `academic-research-suite`, `nature-response`, `code-review-and-quality` for code-backed artifacts |
| Nature/Cell-like polish | `nature-polishing`, `nature-writing`, `nature-response` |
| Humanize academic writing | `humanize-academic-writing`, `anti-ai-flavor`, `humanizer-zh` |
| Remove AI-style traces from general text | `anti-ai-flavor` |
| Response to reviewers | `nature-response`, `academic-research-suite` |

## Figures, Tables, And Visual Artifacts

| Need | Prefer These Skills |
|---|---|
| Publication figures | `nature-figure`, `visualize-data`, `data-analytics:visualize-data` |
| Conceptual paper diagrams | `paper-comic`, `nature-figure`, `imagegen`, Mermaid when suitable |
| Data workbooks and literature matrices | `spreadsheets:Spreadsheets` |
| Analytical reports | `data-analytics:build-report`, `data-analytics:validate-data`, `data-analytics:analyze-data-quality` |
| Dashboards or interactive reports | `data-analytics:build-dashboard`, `data-analytics:build-report` |

## Documents And Submission Formats

| Need | Prefer These Skills |
|---|---|
| DOCX/Word/Google Docs | `documents:documents` |
| PDF deliverables | `pdf:pdf` |
| PowerPoint/defense deck | `presentations:Presentations`, `paper-deck`, `nature-paper2ppt` |
| LaTeX manuscripts | `latex:latex-compile`, `latex:latex-doctor`, `latex:texlive-runtime-installer` |
| Spreadsheets/Excel | `spreadsheets:Spreadsheets` |

## Bioinformatics And Life Science Data

| Need | Prefer These Skills |
|---|---|
| Broad life-science question routing | `life-science-research:research-router-skill` |
| NGS intake and routing | `ngs-analysis:ngs-analysis-router` |
| Bulk RNA-seq | `ngs-analysis:ngs-bulk-rnaseq`, `ngs-analysis:ngs-bulk-rnaseq-counts-qc`, `ngs-analysis:ngs-bulk-rnaseq-differential-expression` |
| scRNA-seq | `ngs-analysis:ngs-scrna-seq`, `ngs-analysis:scrna-seq-qc` |
| DNA variants | `ngs-analysis:ngs-dna-variant-calling`, `ngs-analysis:ngs-dna-germline-variants`, `ngs-analysis:ngs-dna-somatic-variants`, `ngs-analysis:ngs-dna-umi-panel-variants` |
| ATAC/ChIP/CUT&RUN/CUT&Tag | `ngs-analysis:ngs-epigenomics-peaks`, `ngs-analysis:ngs-atacseq-peaks-qc`, `ngs-analysis:ngs-chip-cutrun-peaks-qc` |
| Amplicon/metagenomics | `ngs-analysis:ngs-amplicon-microbiome`, `ngs-analysis:ngs-shotgun-metagenomics` |
| Runtime readiness | `ngs-analysis:ngs-runtime-env`, `debugging-and-error-recovery` |

## Life Science Database Lookups

Use only the specific lookup skills needed for the question:

- genetics/variants: `clinvar-variation-skill`, `gnomad-graphql-skill`, `gwas-catalog-skill`, `finngen-phewas-skill`, `ukb-topmed-phewas-skill`, `biobankjapan-phewas-skill`, `tpmi-phewas-skill`
- gene/protein/expression: `ensembl-skill`, `uniprot-skill`, `human-protein-atlas-skill`, `gtex-eqtl-skill`, `eqtl-catalogue-skill`, `bgee-skill`
- target/pathway/network: `opentargets-skill`, `reactome-skill`, `quickgo-skill`, `string-skill`, `locus-to-gene-mapper-skill`
- cancer/clinical: `cbioportal-skill`, `civic-skill`, `clinicaltrials-skill`, `pharmgkb-skill`
- chemistry/drugs/metabolites: `chembl-skill`, `bindingdb-skill`, `pubchem-pug-skill`, `chebi-skill`, `hmdb-skill`, `rhea-skill`
- structure: `alphafold-skill`, `rcsb-pdb-skill`
- public datasets: `ncbi-datasets-skill`, `ncbi-entrez-skill`, `ncbi-pmc-skill`, `biostudies-arrayexpress-skill`, `biorxiv-skill`, `cellxgene-skill`, `encode-skill`, `pride-skill`, `proteomexchange-skill`, `metabolights-skill`, `mgnify-skill`

## Code, Reproducibility, And Publication Infrastructure

| Need | Prefer These Skills |
|---|---|
| Plan code work | `spec-driven-development`, `planning-and-task-breakdown`, `source-driven-development` |
| Build/debug analysis code | `debugging-and-error-recovery`, `test-driven-development`, `tdd`, `performance-optimization` |
| Code review | `code-review-and-quality`, `security-and-hardening` when data/privacy/security matters |
| Git/GitHub | `git-workflow-and-versioning`, `github:github`, `github:yeet`, `github:gh-fix-ci` |
| Verify before completion | `superpowers:verification-before-completion` when available |

## Routing Rules

1. Use this workflow skill to decide stage, gates, approvals, and artifacts.
2. Hand the stage's technical work to the most specific relevant skill.
3. Load only the selected specialist skill and its directly relevant references.
4. Record which specialist skills were used in `capability_preflight.md` or `review_log.md`.
5. If a specialist skill is unavailable, note the degraded route and do the safest local equivalent.
6. Do not let a specialist skill override this workflow's approval gates, topic-approval requirement, privacy boundaries, or result-readiness gates.
