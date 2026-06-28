---
name: zotero-citation
description: >-
  Find citation support for manuscript text from the user's LOCAL Zotero library and export a
  reference-manager-ready file (BibTeX/RIS/JSON). Use when the user asks to add citations from their
  own library, "从我自己的Zotero库找引用", "用我已有的文献支撑这段话", "本地文献配引用",
  "给段落配引用（库里）", "导出BibTeX/RIS", or wants to ground a paragraph/manuscript in papers
  they have already collected. Differs from nature-citation (which searches the open web for
  Nature/CNS journals) — this skill is strictly bounded to the user's Zotero items via zotero-mcp.
---

# Zotero Citation

Turn manuscript text into citations sourced **only** from items already in the user's Zotero library.
Output is a per-segment evidence table plus a single import file for their reference manager.

Depends on the [[zotero-mcp]] skill for tool semantics and safety.

## When this skill, vs. nature-citation

- This skill: source = user's local Zotero library (`mcp__zotero_mcp__*`). No journal restriction.
- `nature-citation`: source = open web, restricted to Nature Portfolio / Science / Cell families.
- If the user wants both ("先看我库里有没有，没有再去网上找"), run this first; for any segment with
  no acceptable local support, hand off to `nature-citation` and merge the exports.

## Operating mode

Default to Chinese responses if the user writes in Chinese. Search queries against Zotero should be
in English unless the topic is China-specific.

### 1. Segment the text

Break the input into atomic citable claims. A segment is one factual assertion that needs one or
more references. Keep segment text verbatim.

### 2. Search the local library

For each segment, run searches in this order until you have enough candidates:

1. `search_library` with concept keywords (title + fulltext fields).
2. `semantic_search` with a natural-language paraphrase of the claim.
3. `search_fulltext` if the claim is specific enough that exact wording might appear in PDFs.
4. For a top hit, optionally `find_similar` to pull adjacent items.

Cap candidates at ~5 per segment before evaluating. Do not dump raw search output to the user.

### 3. Evaluate support honestly

For each candidate, assess support level using the user's library content (abstract via
`get_item_abstract`, then targeted `search_fulltext` or `get_content` with `mode: "preview"` if
needed). **Never claim a paper supports a segment based on title alone.**

Use these labels (Chinese by default):
- `强支撑` — paper directly demonstrates/states the claim
- `部分支撑` — paper supports a related but narrower/broader version
- `背景支撑` — paper provides context but doesn't establish the claim
- `不建议引用为该句支撑` — title looks relevant but content doesn't back the claim

### 4. Present the evidence table

Before exporting anything, show the user a compact table:

```
段落 1: <verbatim text>
  [强支撑]  Smith 2023, "Title…" (key: ABCD1234) — 摘要节选: …
  [部分支撑] Lee 2021, "Title…" (key: WXYZ5678) — 节选: …
  [不建议] Wang 2024, "Title…" (key: …) — 仅标题相关
```

Ask the user which candidates to keep. Do not auto-pick.

### 5. Export

Once selections are confirmed, build the export file. Default format is BibTeX; offer RIS/CSL-JSON
on request.

**Export limitation**: zotero-mcp does not expose a direct BibTeX export endpoint. Build entries
manually from `get_item_details` (`mode: "complete"`) for each kept item:
- Use the Zotero item key as the BibTeX cite key fallback (`zotero-<key>`) unless `extra` contains
  a Better BibTeX `Citation Key:` line — in that case use that.
- Required fields by item type: journalArticle → author, title, journal, year, volume, number,
  pages, doi; book → author/editor, title, publisher, year; etc.
- Escape `{`, `}`, `%`, `&`, `_`, `#`, `$` in titles. Wrap proper nouns in `{...}` to preserve case.

Save the file to a path the user picks (default: current working directory, filename
`zotero-citations-<date>.bib`).

### 6. Output bundle

Deliver:
1. The evidence table (segment ↔ kept citations ↔ support level).
2. The export file path.
3. A short note on segments with no acceptable local support, with a one-line offer to hand off to
   `nature-citation` for open-web search.

## Safety rules

Inherits all safety rules from [[zotero-mcp]]. Plus:

- **Never fabricate items.** If Zotero returns nothing, say so. Do not invent BibTeX entries.
- **Never silently downgrade support.** If you initially flag `强支撑` and then can't verify it in
  the PDF text, downgrade and tell the user why.
- **Quote PDF excerpts verbatim.** Do not paraphrase the evidence snippet — the user needs to see
  the actual sentence to judge.
- **Read-only by default.** This skill does not write to the Zotero library. If the user wants the
  citations also added as a Zotero collection, that's a separate explicit step with confirmation.

## Failure modes

- **No local support for a segment**: list it under "需要外部检索" and offer `nature-citation`.
- **PDF not indexed / `get_content` returns empty**: fall back to abstract-only evaluation and
  flag the segment as "支撑度未充分核验 — 建议人工查验全文".
- **Better BibTeX not installed**: cite keys will be the fallback `zotero-<key>` form. Mention this
  once so the user can fix import keys if needed.
