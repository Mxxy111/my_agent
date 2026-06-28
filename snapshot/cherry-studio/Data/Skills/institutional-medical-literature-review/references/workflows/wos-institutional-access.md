# Web of Science Institutional Access Workflow

Use this workflow when the user wants Web of Science coverage in addition to PubMed.

## Preferred Routes

1. Official Clarivate Web of Science API through institutional entitlement.
2. User-exported Web of Science records in RIS, BibTeX, CSV, or plain text.
3. Manual browser-assisted lookup for small numbers of records while the user is authenticated.

## Avoid

- Do not default to scraping Web of Science pages.
- Do not automate actions that violate Web of Science or publisher terms.
- Do not store institutional credentials.

## If WoS API Is Available

Ask the user to configure credentials outside source code, usually as environment variables or client configuration. Then use an MCP server or local script that provides:

- Query search.
- Record retrieval.
- Times cited.
- DOI/UT accession number.
- Export to RIS/BibTeX/CSV.

## If WoS API Is Not Available

Ask the user to export records manually from WoS. Then process the export:

1. Parse DOI, title, authors, journal, year, abstract, keywords, accession number.
2. Deduplicate against PubMed by DOI first, then PMID, then normalized title.
3. Use CrossRef/PubMed to complete missing identifiers.
4. Merge into the master literature table.

## Output Fields

- Source database.
- WoS accession number, if available.
- PMID, if mapped.
- DOI.
- Title.
- Journal.
- Year.
- Times cited, if available.
- Abstract.
- Keywords.
- Access status.
- Zotero match status.

## Role in Evidence Synthesis

WoS should be used mainly for citation network completeness, highly cited articles, and cross-disciplinary coverage. For biomedical topic formulation and reproducible search strings, PubMed remains the primary source.
