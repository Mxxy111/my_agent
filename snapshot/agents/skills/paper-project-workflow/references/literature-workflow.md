# Literature Workflow

Use this for evidence planning, literature matrices, and citation checks.

## Route By Paper Type

| Paper type | Literature mode |
|---|---|
| Course or narrative paper | targeted search plus curated matrix |
| Mechanism/hypothesis paper | evidence-chain search: background, gap, mechanism, counterevidence, methods |
| Original research | background/gap search plus methods comparators |
| Bioinformatics paper | data-source, pipeline, method, benchmark, and biological interpretation search |
| Systematic/scoping review | protocol-like search, screening, extraction, and PRISMA-style reporting |
| Clinical/medical paper | current guidelines, peer-reviewed evidence, risk-of-bias, and date-sensitive verification |

## Search Strategy

Build 2-4 query families:

- concept terms: synonyms, abbreviations, MeSH/ontology terms
- population/system terms
- mechanism/exposure/intervention terms
- outcome/application terms
- method/database terms for computational papers

Record:

```markdown
| Date | Database/tool | Query | Filters | Hits/notes | Follow-up |
|---|---|---|---|---|---|
```

Use filters only when justified by the user requirement or study design. For "latest" or publication status questions, verify with current sources.

## Source Hierarchy

Define the source hierarchy before searching. Use this default unless the project has a better discipline-specific hierarchy:

1. target journal/course instructions, official guidelines, protocols, registry records, repository records, and policy pages
2. primary studies, datasets, code repositories, preprints when appropriate, and official publisher pages
3. structured metadata such as DOI/Crossref/PubMed/arXiv records
4. reviews, textbooks, secondary databases, and search-engine results as framing or discovery aids

Do not let a secondary database result become the sole evidence for a precise manuscript claim when a primary source or official record is available.

## Screening And Appraisal

For narrative or course papers, screen by relevance and evidence role. For systematic/scoping reviews, use explicit inclusion/exclusion criteria.

Minimum appraisal fields:

```markdown
| Citation key | Paper type | Why included | Main finding | Methods/data | Strength | Limitation | Where used |
|---|---|---|---|---|---|---|---|
```

For empirical or clinical studies, add sample size, population, comparator, endpoint, and bias/confounding notes.

## Extraction Fields

Use these fields for a general literature matrix:

- stable source ID
- citation key
- authors/year/title/journal
- DOI/PMID/URL
- study type
- model/population/dataset
- methods
- key result
- limitation
- relevance to paper section
- exact claim supported
- quote/page only if needed and allowed
- verification status

For citation-heavy or source-grounded work, also keep stable claim IDs:

```markdown
| Claim ID | Source ID | Exact claim supported | Support grade | Boundary | Section |
|---|---|---|---|---|---|
```

Support grades should be conservative: `strong`, `partial`, `background`, `contradictory/limiting`, or `metadata-only candidate`. Do not cite a metadata-only candidate as support until the abstract, full text, or publisher page has been checked.

## Citation Metadata Verification

Before finalization, check:

- DOI resolves and matches title
- year, volume, issue, pages/article number match the venue record
- author order is plausible and not truncated incorrectly for the required style
- preprint vs peer-reviewed status is clear
- retraction/expression-of-concern risk is checked for high-stakes or surprising sources
- in-text citations all appear in references and references all appear in text unless bibliography-only is allowed
- duplicate records are merged

Use official journal pages, PubMed, Crossref, DOI pages, Zotero metadata, or the best available primary bibliographic source. Do not rely only on a language model's memory.

## Evidence Use Rules

- Cite primary studies for specific findings.
- Cite high-quality reviews for field framing, not as the only support for narrow empirical claims.
- Include counterevidence when the field is controversial.
- Do not turn correlation into causation.
- Do not hide weak evidence by using vague phrases such as "studies show" without naming the type of evidence.
