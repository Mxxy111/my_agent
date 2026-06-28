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
