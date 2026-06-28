# Final Package

Use this before telling the user the paper is ready.

## Package Manifest

Create a manifest when there are multiple deliverables:

```markdown
# Final Package Manifest

| Deliverable | Required? | Path | Status | Notes |
|---|---|---|---|---|
| Manuscript | yes |  |  |  |
| References/BibTeX | depends |  |  |  |
| Figures | depends |  |  |  |
| Tables | depends |  |  |  |
| Supplement | depends |  |  |  |
| Code | data/code papers |  |  |  |
| Data provenance | data/code papers |  |  |  |
| Data availability statement | publication manuscripts |  |  |  |
| Code/materials availability statement | publication manuscripts |  |  |  |
| Claim-evidence map | publication-grade or citation-heavy papers |  |  |  |
| Figure/table source manifest | figure/table-heavy papers |  |  |  |
| Reviewer response package | revision projects |  |  |  |
| Capability preflight | data/code or artifact-heavy papers |  |  |  |
| Review summary | recommended |  |  |  |
| Submission checklist | venue/course dependent |  |  |  |
```

## Naming Convention

Use the user's required naming when provided. Otherwise prefer:

```text
<short-topic>_manuscript_<YYYYMMDD>.<ext>
<short-topic>_figures_<YYYYMMDD>/
<short-topic>_references_<YYYYMMDD>.bib
<short-topic>_supplement_<YYYYMMDD>.<ext>
<short-topic>_final_package_manifest_<YYYYMMDD>.md
```

Avoid spaces and ambiguous "final_final" names.

## Deliverable Checks

Manuscript:

- required section order
- word count or page count
- headings and numbering
- citations/references consistency
- declarations and AI-use statement when needed

Figures/tables:

- numbered and captioned
- cited in text
- readable at expected size
- generated/source provenance recorded
- source data or dataset links identified when the figure/table supports a result claim
- file format and resolution fit the requirement

Code/data:

- scripts/notebooks run for every result claim; otherwise the deliverable is labeled as planned-methods-only and contains no observed result claims
- environment and command logs included
- workflow-specific executable/package checks are recorded
- raw data not redistributed unless permitted
- outputs linked to manuscript claims
- data, code, materials, and protocol availability statements name repositories, accessions, DOIs, licences, restrictions, or justified request routes when applicable
- reused datasets are cited with stable identifiers where available

Reviewer response:

- every editor/reviewer comment is preserved or faithfully summarized with stable IDs
- each response maps to a manuscript change, evidence source, justified disagreement, or `AUTHOR_INPUT_NEEDED`
- no invented line numbers, experiments, citations, or figure panels
- tone is professional and non-defensive

DOCX/PDF/PPTX:

- render/preview visually when possible
- inspect for clipping, overlapping, missing glyphs, broken tables, and unreadable figures
- disclose if render QA could not run

## Submission Readiness Rubric

Ready means:

- no unmet "must" requirement
- no unresolved high-severity review finding
- all claims are either cited or traceable to results
- final files open successfully
- user-facing final response names exactly what was produced and any residual limitations

Not ready if:

- topic or analysis plan skipped required user approval
- final result depends on unrun code or unverified citations
- a required declaration is missing
- the package contains private/prohibited data without user-approved handling
