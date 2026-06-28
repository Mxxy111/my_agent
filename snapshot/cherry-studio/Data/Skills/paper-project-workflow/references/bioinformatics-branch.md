# Bioinformatics And Computational Paper Branch

Use this branch when a paper depends on data, code, statistics, omics, public databases, or computational figures.

## Trigger Conditions

Activate this branch when the project involves:

- raw sequencing files: BCL, FASTQ, BAM/CRAM, VCF
- processed omics: count matrices, `h5ad`, `rds`, expression tables, methylation, proteomics, metabolomics, microbiome
- public cohorts: TCGA, GEO, SRA, ArrayExpress, GTEx, cBioPortal, OpenTargets, UK Biobank-like resources, or disease-specific portals
- computational methods: differential expression, enrichment, network analysis, survival, immune infiltration, drug sensitivity, ML models, multi-omics integration
- code reproduction or custom pipeline construction

## Extra Intake Questions

Ask only what is missing:

- What data are already available? Local files, accessions, public databases, or no data yet?
- What is the biological/clinical endpoint?
- What organism, tissue, disease, cohort, and sample groups are intended?
- Is this exploratory, hypothesis-testing, validation, or reproduction?
- Are human/private data involved, and is cloud upload allowed?
- What deliverables are expected: figures, tables, code, manuscript, supplementary files?
- What runtime is allowed: local, HPC, cloud, Docker/Conda, package installs?

## Data And Method Discovery

Before code, create a data/method inventory:

- dataset accession, source URL, access date, license or access restrictions
- sample count, groups, metadata fields, assay type, platform
- inclusion/exclusion criteria
- pipeline/software candidates and citations
- known limitations: batch effects, confounding, missing metadata, small sample, class imbalance

Use life-science and NGS routing skills when relevant. For broad database discovery, use the life-science research router. For sequencing files, use the NGS analysis router.

For human/private data, do not send data, identifiers, private accessions, or sensitive metadata to web/MCP/cloud tools unless the user explicitly approves that route. Prefer local-only inspection and de-identified summaries.

Routing examples:

- Local FASTQ to counts: inspect filenames/sample sheet, then route through `ngs-analysis:ngs-analysis-router` to bulk RNA-seq, scRNA-seq, amplicon, metagenomics, or epigenomics as appropriate.
- Public expression matrix from GEO/ArrayExpress: record accession and platform, download or document access, then run matrix-level QC before differential or survival analysis.
- TCGA/cBioPortal-style cancer paper: define cohort, endpoint, molecular feature, and covariates before survival, immune, or mutation analyses.
- Gene/target paper: use life-science research router for entity normalization, pathway/interaction lookups, expression/tissue context, and clinical/cancer evidence.

When invoking NGS plugin scripts, resolve `scripts/` and `references/` relative to the installed NGS plugin root unless those files actually exist in the workspace. Do not assume `plugins/ngs-analysis/...` exists under the user's repo.

## Analysis Plan Gate

Write `analysis_plan.md` before substantial execution. Include:

- primary question and endpoints
- dataset version/access path
- preprocessing and QC
- normalization/transformation
- statistical tests
- multiple-testing correction
- model covariates and confounders
- validation strategy
- figure/table outputs
- expected failure modes

Get user approval before running expensive, cloud, invasive, or protocol-defining steps.

Do not claim a workflow is runnable until a workflow-specific preflight checks the actual runner's required executables and language packages. A generic preflight or partial success is not enough.

## Reproducible Project Layout

Prefer a clear layout:

```text
data_raw/
data_processed/
metadata/
scripts/
notebooks/
results/
figures/
tables/
logs/
env/
docs/
```

Keep generated outputs separate from source data. Record commands, package versions, parameters, and random seeds when relevant.

Minimum reproducibility standard:

- one environment record: `environment.yml`, `requirements.txt`, `renv.lock`, `package.json`, or `env/runtime_notes.md`
- one command log or notebook execution log
- explicit random seed policy for stochastic steps
- data provenance table with accession/path, access date, version, sample count, and license/access restrictions
- output provenance table linking each manuscript figure/table to the script/notebook and input data
- no hand-edited final figures without a note explaining the edit

Before package installs, write an approval-ready command list and propose an isolated environment. Do not install into a global/system environment unless the user explicitly asks and understands the tradeoff.

## Build-Debug-QC Loop

0. Run capability preflight: executable probes, language package probes, disk/RAM estimate, network/download policy, credential needs, data sensitivity, and renderer availability.
1. Build the smallest script that proves data access and shape.
2. Add preprocessing/QC.
3. Add the primary analysis.
4. Generate initial figures/tables.
5. Inspect outputs.
6. Run objective method/code/result review.
7. Patch code or revise the plan.
8. Re-run and record changes.

Do not continue to manuscript claims until key outputs pass QC.

## QC Checklist

Use the relevant checks:

- sample identifiers match metadata
- groups and labels are not swapped
- missingness and outliers are reported
- normalization is appropriate for assay type
- batch effects and confounders are assessed
- multiple testing is controlled
- enrichment uses a defensible gene universe
- survival models check censoring and proportional hazards when applicable
- ML models avoid leakage and use proper train/test or cross-validation
- single-cell analyses document QC thresholds, doublet handling, normalization, clustering, marker validation, and annotation evidence
- figures are reproducible from scripts
- negative or unstable results are not reframed as strong positive claims

Environment-lock checklist:

- record language/runtime versions
- record package versions for analysis-critical packages
- record external tool versions for aligners, callers, and workflow engines
- pin reference genome/build and annotation versions
- document any manual downloads or account-gated resources

Runnable-analysis checklist:

- required executables are present or an approved install plan exists
- required Python/R/Node packages import successfully or an approved install plan exists
- dry run or minimal smoke test exercises the actual script/workflow path
- disk/RAM/runtime expectations are compatible with the machine or are escalated to the user
- external dataset/reference/software/model-weight downloads are size-scoped and approved unless they are ordinary web-page/PDF reading

## Manuscript Integration

Only write Results from verified outputs. Each result claim needs:

- output file path
- method/script that generated it
- statistic or effect size where applicable
- figure/table reference
- limitation or sensitivity note when relevant

Methods must be specific enough to reproduce the analysis: data source, software versions, parameters, statistics, and filtering logic.
