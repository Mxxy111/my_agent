---
name: institutional-medical-literature-review
description: >-
  Institution-aware medical literature review workflow using PubMed API, MeSH,
  DOI/PMID/PMCID conversion, CrossRef/OpenAlex/Semantic Scholar expansion,
  optional Web of Science, school-library subscription access, Zotero full-text
  management, and AI evidence synthesis. Use when the user asks to conduct
  medical literature research, build a PubMed/WoS search strategy, use an
  institutional subscription for non-OA papers, organize papers in Zotero, or
  produce literature maps, evidence tables, and review drafts.
license: MIT
metadata:
  author: local-user
  version: "1.0.0"
---

# Institutional Medical Literature Review

This skill turns medical literature research into a reproducible workflow that avoids fragile web scraping. It prioritizes official databases and APIs for search and metadata, uses the user's legitimate institutional access for subscription full text, stores full text in Zotero, and then performs AI synthesis from verified metadata and locally available PDFs.

## Trigger Phrases

Use this skill when the user says any of the following:

- “做医学文献调研”
- “PubMed 检索式”
- “MeSH 检索”
- “帮我查课题文献”
- “学校订阅全文”
- “非 OA 文献怎么让 AI 读”
- “WoS 文献调研”
- “Zotero 里整理文献”
- “生成证据表/文献地图/综述初稿”

## Core Principle

Do not rely on publisher-page crawling as the primary strategy. Use database APIs and citation identifiers first, then use institutional authentication only for legitimate full-text retrieval.

Preferred order:

1. PubMed / NCBI E-utilities for biomedical search.
2. CrossRef for DOI and publisher metadata completion.
3. OpenAlex or Semantic Scholar for citation graph, related work, and ranking support.
4. Web of Science only through official institutional API or user-exported records.
5. Zotero as the full-text and annotation hub.
6. AI synthesis only after metadata and source provenance are preserved.

## Available Tool Routing

### PubMed

Use the PubMed MCP tools when available:

- `mcp1_search_articles` for PubMed search.
- `mcp1_get_article_metadata` for detailed metadata by PMID.
- `mcp1_convert_article_ids` for PMID / PMCID / DOI conversion.
- `mcp1_find_related_articles` for PubMed related articles.
- `mcp1_get_full_text_article` only for PubMed Central full text.

For multi-source academic search, also use `nature-academic-search` and paper-search MCP tools when relevant.

### Zotero

Use `zotero-mcp` when the user wants to work with local saved PDFs, collections, notes, or annotations. Prefer read-only Zotero operations unless the user explicitly asks to create or modify Zotero items, collections, notes, or tags.

### Web of Science

Do not scrape Web of Science pages as a default workflow. Use one of these routes:

1. Official Clarivate Web of Science API, if the institution provides API access.
2. User-exported WoS records in RIS, BibTeX, CSV, or plain text.
3. Manual browser-assisted access for single records when the user is already authenticated.

If no official WoS API or export is available, state the limitation and fall back to PubMed + CrossRef + OpenAlex/Semantic Scholar.

## Environment and Rate Limits

The PubMed API key should be stored outside prompts and code:

```bash
NCBI_API_KEY=<user_key>
```

With an NCBI API key, respect the user's limit of 10 requests per second. For batch workflows, use conservative batching and avoid unnecessary repeated metadata calls.

Never ask the user to paste secret API keys into manuscript files, notes, public repos, or source code. If configuration is needed, ask the user to set an environment variable or a local ignored `.env` file.

## Workflow 1: Topic to Reproducible PubMed Search

Use this when the user provides a research topic, clinical question, disease, intervention, biomarker, method, or manuscript claim.

### Step 1. Clarify the Research Scope

Extract or ask for:

- Population / disease.
- Exposure, intervention, biomarker, diagnostic test, or method.
- Comparator, if applicable.
- Outcomes.
- Study design preference.
- Date range.
- Species and language limits.
- Whether the goal is scoping review, systematic review, manuscript citation support, or background reading.

For medical questions, convert the request into a PICO/PECO structure when possible.

### Step 2. Build Search Blocks

Create separate concept blocks:

- Disease / population block.
- Intervention / exposure / index-test block.
- Outcome block.
- Study design block, if needed.

Use both MeSH and free-text terms. Include spelling variants, abbreviations, and common synonyms. Do not over-restrict early scoping searches.

### Step 3. Run PubMed Search

Use `mcp1_search_articles` with a clear query, suitable date limits, and an initial result cap. For systematic work, preserve the exact query string and date searched.

Recommended output after search:

- Exact PubMed query.
- Date searched.
- Number of retrieved records.
- Top records with PMID, title, journal, year, DOI, abstract availability.
- Search limitations and likely missing concepts.

### Step 4. Fetch Metadata and Identifiers

Use `mcp1_get_article_metadata` for selected PMIDs. Use `mcp1_convert_article_ids` to obtain DOI and PMCID where possible.

Preserve:

- PMID.
- DOI.
- PMCID.
- Title.
- Authors.
- Journal.
- Publication year.
- Abstract.
- Publication type.
- MeSH terms when available.

### Step 5. Expand Strategically

Use related-article search and citation databases only after the initial PubMed set is stable:

- PubMed related articles for conceptual neighbors.
- CrossRef for missing DOI/publisher records.
- OpenAlex/Semantic Scholar for citation context and related high-impact work.
- WoS only via official API or user-exported records.

## Workflow 2: Institutional Full-Text Retrieval Without Fragile Scraping

Use this when the user wants AI to read papers that are not OA but are available through the user's school subscription.

### Step 1. Classify Access Route

For each DOI / PMID:

1. PMCID exists: retrieve from PubMed Central if appropriate.
2. OA version exists: use OA full text.
3. No OA: generate DOI or publisher landing link for institutional access.
4. If the school has EZproxy/OpenURL/LibKey configuration, generate the resolver link if the user has provided the template.

### Step 2. Use the User's Authenticated Browser or Zotero Connector

The user should access non-OA full text through:

- Campus network.
- School VPN.
- Library EZproxy.
- Shibboleth / institutional login.
- Zotero Connector after authentication.

The agent must not bypass paywalls, share credentials, or automate bulk downloading against publisher terms.

### Step 3. Store in Zotero

Preferred full-text route:

1. User opens the article through institutional access.
2. Zotero Connector saves metadata and PDF.
3. Zotero syncs or stores the PDF locally.
4. Use `zotero-mcp` to read full text, metadata, annotations, and collections.

### Step 4. Report Retrieval Status

For each article, classify:

- Full text in Zotero.
- PMC full text available.
- OA full text available.
- Institutional login required.
- Metadata only.
- Failed / needs manual check.

## Workflow 3: Evidence Table and Literature Map

Use this after metadata or full text has been collected.

### Evidence Table Fields

Use these fields by default:

- Citation.
- PMID / DOI.
- Study design.
- Population / dataset.
- Sample size.
- Exposure / intervention / index variable.
- Comparator.
- Outcome.
- Main quantitative result.
- Adjustment variables.
- Strengths.
- Limitations.
- Relevance to the user's project.
- Confidence level.

### Literature Map Structure

Organize papers by evidence role:

1. Foundational background.
2. Current clinical guideline or consensus.
3. Large cohort / registry evidence.
4. Mechanistic or biological evidence.
5. Methods and statistical design.
6. Contradictory or negative evidence.
7. Gaps and unresolved questions.

## Workflow 4: AI Review Draft from Verified Sources

Before drafting prose, verify that each claim is supported by at least one identifiable source with PMID or DOI.

Default output:

1. Search strategy.
2. PRISMA-style retrieval summary if applicable.
3. Evidence map.
4. Key findings by theme.
5. Contradictions and uncertainty.
6. Research gaps.
7. Draft literature review paragraph or section.
8. Reference list with PMID / DOI.

Do not cite unsupported claims. Do not invent references. If full text was not available, explicitly state that synthesis is based on abstract and metadata only.

## Recommended User Commands

The user can invoke this skill with prompts like:

```text
用 institutional-medical-literature-review 帮我调研：局限性肾癌肿瘤大小阈值和癌症特异生存。优先 PubMed，生成 MeSH 检索式、核心文献表，并告诉我哪些需要学校订阅全文。
```

```text
帮我把这个课题做成文献地图：先查 PubMed，再用相关文献扩展，最后把需要下载的 DOI 清单整理给 Zotero。
```

```text
我已经用学校 VPN 在 Zotero 保存了这些论文，请从 Zotero 读取全文，生成证据表和综述初稿。
```

## When to Build a New MCP Server

Do not build a new MCP server if the existing PubMed MCP tools already satisfy the task. Build or extend an MCP server only if the user needs one of the following:

- Persistent PubMed batch jobs with local caching.
- Automatic deduplication across PubMed, WoS exports, CrossRef, and Zotero.
- Institutional OpenURL/EZproxy resolver integration.
- Zotero collection creation and status synchronization.
- A project-specific literature database stored as SQLite/CSV/Parquet.

If building a new MCP server, prefer a small local read-mostly server with these tools:

- `pubmed_search`
- `pubmed_fetch_metadata`
- `pubmed_convert_ids`
- `literature_deduplicate`
- `resolver_build_links`
- `zotero_match_items`
- `evidence_table_export`

Keep credentials in environment variables and return actionable errors when keys or resolver templates are missing.

## Safety and Compliance

- Do not bypass paywalls.
- Do not store institutional credentials in code or notes.
- Do not bulk-download publisher PDFs unless the user confirms it complies with institutional and publisher terms.
- Prefer metadata APIs, DOI links, OpenURL resolvers, and Zotero Connector over page scraping.
- Preserve provenance: query, date, database, PMID, DOI, and access status.

## Default Final Deliverables

For most literature research tasks, produce:

1. Reproducible PubMed query.
2. Search log with date and database.
3. Deduplicated article table.
4. Full-text access status table.
5. Priority reading list.
6. Evidence table.
7. Thematic literature map.
8. Review draft or manuscript citation support.
