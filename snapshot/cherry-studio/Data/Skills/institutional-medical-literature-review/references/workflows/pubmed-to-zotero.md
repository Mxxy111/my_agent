# PubMed to Zotero Institutional Full-Text Workflow

Use this workflow when the user wants a robust medical literature review pipeline that can include non-OA papers available through a school subscription.

## Inputs

- Research topic or PICO/PECO question.
- Optional date range.
- Optional study design restrictions.
- Optional target journal or manuscript section.
- Optional school library resolver template, EZproxy prefix, or LibKey link resolver.

## Steps

1. Convert the topic into structured concepts.
2. Build PubMed search blocks using MeSH and free-text terms.
3. Run PubMed search with `mcp1_search_articles`.
4. Fetch metadata for selected PMIDs with `mcp1_get_article_metadata`.
5. Convert identifiers with `mcp1_convert_article_ids`.
6. Classify full-text route:
   - PMCID available.
   - OA full text likely available.
   - DOI/publisher page requires institutional access.
   - Metadata only.
7. Give the user a Zotero acquisition list with DOI, PMID, title, and access route.
8. User opens subscription papers through school VPN/library login and saves them with Zotero Connector.
9. Use Zotero MCP to read local PDFs, notes, and annotations.
10. Produce evidence table, literature map, and review draft.

## Output Format

Return these sections:

1. Search strategy.
2. Search log.
3. Candidate article table.
4. Full-text access status.
5. Zotero acquisition checklist.
6. Evidence synthesis plan.
7. Draft literature review or citation support.

## Access Status Labels

- `PMC_FULL_TEXT`
- `OPEN_ACCESS`
- `INSTITUTION_REQUIRED`
- `ZOTERO_FULL_TEXT_AVAILABLE`
- `METADATA_ONLY`
- `MANUAL_CHECK_REQUIRED`

## Compliance Rules

Do not bypass paywalls. Do not ask for institutional passwords. Do not automate bulk PDF downloading unless the user has confirmed that the institution and publisher terms allow it. Prefer Zotero Connector and authenticated browser sessions for subscription PDFs.
