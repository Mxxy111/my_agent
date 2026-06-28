# Minimal MCP Extension Plan

Build this only if existing PubMed MCP, paper-search MCP, and Zotero MCP are not enough.

## Goal

Create a local, institution-aware, read-mostly MCP server that coordinates PubMed metadata, DOI resolution, WoS exports, Zotero matching, and evidence table generation without crawling publisher pages.

## Recommended Tools

- `pubmed_search`: search PubMed with date filters and pagination.
- `pubmed_fetch_metadata`: fetch metadata by PMID list.
- `pubmed_convert_ids`: convert PMID, PMCID, DOI.
- `crossref_complete_metadata`: complete missing DOI and publisher metadata.
- `wos_import_records`: parse user-exported WoS RIS/BibTeX/CSV.
- `literature_deduplicate`: deduplicate by DOI, PMID, and normalized title.
- `resolver_build_links`: build DOI, OpenURL, EZproxy, or LibKey links from a user-provided resolver template.
- `zotero_match_items`: match candidate papers against the local Zotero library.
- `evidence_table_export`: export CSV/Markdown evidence tables.

## Configuration

Use environment variables or local ignored config files:

- `NCBI_API_KEY`
- `WOS_API_KEY`, if available.
- `INSTITUTION_OPENURL_TEMPLATE`, optional.
- `EZPROXY_PREFIX`, optional.
- `ZOTERO_MCP_URL`, optional.

## Rate Limits

- PubMed with API key: maximum 10 requests per second.
- Use batching where supported.
- Cache metadata by PMID/DOI to avoid repeated requests.

## Data Store

Use a small local SQLite database or CSV/Parquet files with these tables:

- `searches`
- `articles`
- `identifiers`
- `access_status`
- `zotero_matches`
- `evidence_extractions`

## Security

Never expose API keys in tool output. Never store institutional credentials. Never download paywalled PDFs automatically unless explicitly permitted by the user's institution and publisher terms.
