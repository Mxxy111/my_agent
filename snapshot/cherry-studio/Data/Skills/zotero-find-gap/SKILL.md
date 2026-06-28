---
name: zotero-find-gap
description: >-
  Find research gaps in the user's Zotero library — papers they SHOULD have but don't. Given a
  research direction, scan the local library to map coverage, then search the open web (PubMed,
  CrossRef, arXiv via [[nature-academic-search]]) to surface high-impact or recent papers the user
  is missing. Use when the user asks "我Zotero里这方向缺什么文献", "找我没收藏的相关paper",
  "research gap on X", "literature gap", "我这个课题还少哪些文献", "查漏补缺".
---

# Zotero Find Gap

Goal: identify what the user's library is missing on a topic, ranked by likely value, with a
suggested action (download / add to Zotero) per item.

This skill bridges [[zotero-mcp]] (local) and [[nature-academic-search]] (open web). Use it when
the question is *"what don't I have yet"*, not *"what do I have"*.

## Inputs

Accept any of:
- A research direction / topic ("MoE 路由稳定性")
- A specific paper as anchor ("以这篇为种子，找相关我没收藏的")
- A draft outline / proposal where you can extract topics

If too vague to search, ask **one** scoping question (sub-topic, time range, communities of
interest e.g. NeurIPS/ICML vs. biology venues).

## Procedure

### 1. Map current local coverage

For the topic:
1. `semantic_search` (preferred when embeddings available) → top ~15 items.
2. `search_library` keyword search as a complement.
3. Group results into 3-6 sub-topics. Note which sub-topics have lots of items and which are thin.

This becomes the baseline — what the user already has — and surfaces likely gap areas (the thin
clusters, plus sub-topics absent entirely).

### 2. Generate gap candidates from the open web

Hand off to [[nature-academic-search]] for each gap area. Search strategies:
- **Recency**: papers from the last 1-2 years on the sub-topic.
- **Foundational**: highly cited works that should be in any library on this topic.
- **Adjacent**: methods/results from neighboring fields the user might have missed.
- **Contrarian**: papers that critique or contradict the existing library's perspective (especially
  useful — libraries tend to be self-confirming).

Pull title, authors, year, venue, DOI, abstract for each candidate.

### 3. Filter against local library

For each candidate, check whether the user already has it:
- `search_library` by exact title.
- `search_library` by DOI (if zotero-mcp supports DOI field search; otherwise title fallback).
- If unsure, `find_similar` from a closely-related local item to see if the candidate clusters
  with existing items.

Discard candidates already in the library. Discard near-duplicates (preprint vs. published
version of the same work — note the duplication, don't list both as gaps).

### 4. Rank gaps

Rank remaining candidates by likely value:
- **Citation impact** (when retrievable from CrossRef metadata)
- **Recency** for fast-moving fields, **foundational status** for stable fields
- **Coverage of an absent sub-topic** > "5th paper on a sub-topic the user already has 4 of"
- **Contrarian / critique** papers get a small bonus — they're disproportionately valuable for
  research

Cap at ~10-15 candidates total. More than that overwhelms the user.

### 5. Present the gap report

Output a single markdown document:

```markdown
# Zotero Gap Report: <topic>

## Local coverage map
- Sub-topic A: 8 items (well covered)
- Sub-topic B: 2 items (thin) — gap candidates below
- Sub-topic C: 0 items (missing) — gap candidates below

## Recommended additions

### High priority
1. **Author Year. Title.** Venue. DOI: ...
   - Fills gap in: Sub-topic C
   - Why: foundational paper on X, currently no item in the library covers this
   - Abstract: ...
   - Action: download from <DOI link> and add to Zotero

### Medium priority
...

### Worth a look
...

## Notes
- Sub-topic D was searched but no significant papers missing.
- Items already in library: <count> (verified via title/DOI match)
```

### 6. Optional follow-up actions

Offer (do not auto-run):
- For specific items: fetch the PDF if open-access and stage for Zotero import.
- Create a Zotero collection for the gap items via [[zotero-mcp]] (`create_collection` +
  `add_items_to_collection`) — requires confirmation per [[zotero-mcp]] write rules.
- Push the gap report to Obsidian via [[obsidian-feed]].

## Safety & quality

Inherits all rules from [[zotero-mcp]] and [[nature-academic-search]]. Plus:

- **No fabrication.** Every recommended paper must have verifiable metadata (DOI, arXiv ID, or
  PubMed ID). If you can't verify, don't list it.
- **Don't recommend papers already in the library.** Always check before recommending. False
  "gaps" erode trust. When in doubt, mark as "possibly already in library — verify by title".
- **Honest gap = no gap.** If the library is well-covered on the topic and you can't find
  meaningful additions, say so. Don't manufacture gaps to look helpful.
- **Bias awareness.** Surface contrarian / critique papers explicitly. A library that only
  contains papers agreeing with each other is itself a gap.
- **No bulk writes.** This skill is read-only by default. Adding the gap items to a Zotero
  collection is a separate, confirmed step.

## Failure modes

- **Topic too broad**: ask the user to narrow before running open-web searches (broad queries
  produce noise that drowns the real gaps).
- **Open-web search returns nothing**: tell the user — could mean (a) library is comprehensive,
  (b) topic terminology mismatch (try synonyms), or (c) niche field with little published work.
- **Embeddings missing on local side**: fall back to `search_library` + `find_similar`. Note that
  coverage map will be less accurate without semantic clustering.
- **Already-in-library check unreliable**: if title matches are fuzzy (preprints vs. published),
  flag uncertain matches rather than silently dropping them.
