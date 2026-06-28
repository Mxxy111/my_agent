---
name: zotero-litreview
description: >-
  Draft a Related Work / literature review section grounded in items from the user's Zotero library,
  with thematic clustering, comparison tables, and chronological narrative. Use when the user asks
  to "写一段综述", "Related Work based on my Zotero", "基于我库里的文献写文献综述", "对比我收藏的几篇方法",
  "做一张方法对比表", or wants prose synthesis (not just a list) of papers they own. For pure
  citation lookup use [[zotero-citation]]; for AI-agent context bundles use [[zotero-context-pack]].
---

# Zotero Literature Review

Goal: produce a defensible Related Work / 文献综述 paragraph or section sourced from items the user
already has in Zotero, with explicit clustering and structured comparison.

Depends on [[zotero-mcp]] for retrieval. Hands off prose styling to [[nature-writing]] /
[[nature-polishing]] when the user wants journal-quality finish.

## Inputs

Accept any of:
- Topic + scope ("MoE 路由方法的综述，限定 2022-2026")
- A draft outline / bullet points the user wants fleshed out
- An existing Zotero collection key (use that as the item set directly, skip search)
- A specific list of item keys

If scope is unclear, ask **one** question covering: (a) topic boundaries, (b) time range,
(c) target length / venue.

## Procedure

### 1. Resolve the item set

Decide the source pool, in this priority:
1. Explicit item keys → use as-is.
2. Collection key → `get_collection_items` with appropriate `mode`.
3. Topic → `semantic_search` + `search_library` per facet (see [[zotero-context-pack]] step 2).
   Cap at ~15-25 items. More than 25 makes a focused review hard.

Show the user the resolved list with title + year + key. Ask for keep/drop before continuing.

### 2. Read enough to cluster

For each kept item:
- `get_item_abstract` always.
- `get_annotations` — user's own highlights are the strongest signal of what mattered to them.
- Targeted `search_fulltext` only when the abstract is too thin to place the paper.

Avoid `get_content` with `mode: "complete"` unless one specific paper is the review's centerpiece.

### 3. Cluster and structure

Group items by 2-4 dimensions appropriate to the topic. Common patterns:
- **Method family** (e.g., contrastive vs. autoregressive vs. diffusion)
- **Problem setting** (supervised / self-supervised / few-shot)
- **Time / generation** (foundational → recent → frontier)
- **Outcome** (positive / negative / mixed results)

Pick clustering with the user before writing prose. A bad cluster wastes the whole review.

### 4. Build a comparison table (optional but recommended)

If the items lend themselves to comparison, output a markdown table with columns chosen for the
topic. Examples:

| Paper | Method | Dataset | Key claim | Limitation |

Fill cells from abstract + targeted fulltext lookups. Mark cells `unclear` when the abstract
doesn't say — don't fabricate.

### 5. Write the prose

Default structure:
1. **Opening** — 1-2 sentences framing the problem.
2. **Cluster narrative** — for each cluster, 2-4 sentences synthesizing the line of work, with
   inline citations like `(Author, Year)` referencing the user's items by key for traceability.
3. **Tensions / open questions** — what the literature disagrees on or hasn't answered.
4. **Positioning** (optional) — if the user is writing this for their own paper, one sentence on
   how their work fits.

Keep paragraphs tight. A Related Work section should rarely exceed 600-800 words unless the user
is writing a standalone survey.

For polishing prose to journal style, hand the draft to [[nature-polishing]] with the user's
target venue. For full Nature-style restructuring, use [[nature-writing]].

### 6. Deliverables

Output a single markdown document containing:
- Resolved item list (title + year + key)
- Comparison table (if used)
- Cluster narrative + prose draft
- Inline (Author, Year) markers tied to item keys, plus a separate **Items referenced** section at
  the bottom listing key → full citation for traceability

Optional follow-ups (offer, do not auto-run):
- Export the cited items as BibTeX → handoff to [[zotero-citation]] export step.
- Push the draft to Obsidian → [[obsidian-feed]].

## Safety & quality

Inherits all rules from [[zotero-mcp]]. Plus:

- **No phantom citations.** Every (Author, Year) in the prose must trace to a real item in the
  resolved list. Never cite from training-data memory.
- **Don't overclaim.** If a paper is in `部分支撑` territory for the cluster narrative, soften the
  language ("suggests", "in related work"). Reserve assertive phrasing ("demonstrates") for items
  whose abstract or fulltext clearly supports the claim.
- **Quote user annotations verbatim** when they're load-bearing for the narrative.
- **Honest scope.** If the library has clear gaps in the topic (e.g., no foundational work pre-2020),
  state it. Offer [[zotero-find-gap]] to identify what's missing before drafting further.
- **No writes** to Zotero unless the user explicitly asks (e.g., "建一个 review-2026 收藏夹把这些
  装进去" → confirm + `create_collection` + `add_items_to_collection`).

## Failure modes

- **Item set too small** (<5 items): say so; offer [[zotero-find-gap]] or
  [[nature-academic-search]] to expand before drafting.
- **Items don't cohere** (no plausible clustering): tell the user the set is too heterogeneous and
  ask whether to narrow scope or split into sub-reviews.
- **Embeddings missing**: fall back to keyword + `find_similar` per [[zotero-mcp]] guidance.
