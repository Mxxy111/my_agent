---
name: zotero-annotation-digest
description: >-
  Aggregate the user's Zotero annotations (highlights, notes, comments) — filtered by color, tag,
  item, or topic — into a structured markdown study note. Use when the user asks "把我标过的红色
  汇总成笔记", "整理我Zotero里的高亮", "按主题归并我做过的标注", "annotation digest", "导出我的批注",
  "汇总#important标签的笔记", or wants to recycle their reading notes into a coherent document.
  Optionally hands off to [[obsidian-feed]] to push the digest into the Obsidian vault.
---

# Zotero Annotation Digest

Goal: turn scattered Zotero highlights/notes into a single structured markdown digest organized by
topic, item, or tag. The user's annotations are the user's own thinking — preserve them verbatim.

Depends on [[zotero-mcp]] for retrieval and safety.

## Inputs

Accept any of:
- A color filter ("红色 = 重要", "黄色 = 疑问")
- A tag filter (`#important`, `to-revisit`, etc.)
- An item or item set (specific keys, a collection, or a list from a previous skill)
- A topic ("把我关于MoE的标注整理一下")
- A combination ("红色 + #LLM 标签")

If filters are missing entirely, ask **one** question: "按颜色 / 按标签 / 按某个收藏夹 / 按主题？"

## Procedure

### 1. Retrieve annotations

Choose the narrowest matching tool:
- `search_annotations` with `colors` and/or `tags` for filtered pulls (most common path).
- `get_annotations` with `itemKey` for a specific paper.
- `search_annotations` with `q` for topic search across the library.
- For "all annotations on these N items", iterate `get_annotations` per item.

Always pass `colors` / `tags` filters when known — narrows result set and avoids dumping the whole
annotation store.

Default `mode: "preview"` initially. Escalate to `standard` only if previews are truncating
useful context.

### 2. Group results

Decide grouping with the user before writing prose. Common choices:
- **By item** (default): all annotations under each paper, in PDF reading order.
- **By topic**: cluster annotations by what they're about, across papers. Use semantic grouping
  when annotation count is large.
- **By color**: e.g., separate sections for 红色(重要) / 黄色(疑问) / 绿色(同意).
- **By tag**: one section per tag, items as subsections.

Show the proposed grouping briefly before generating the full digest.

### 3. Build the digest

For each group, output:
- Group heading + 1-line summary of what's in it
- Per-annotation entry:
  - **Quote verbatim** in a blockquote (highlight text or the user's note text)
  - Source: `Author Year, "Title" — page N` if available, plus item key
  - Annotation tags / color in a small line below
  - Optional: 1-sentence connective tissue *only* if the user asked for synthesis. Default is
    no synthesis, just clean aggregation.

Example block:

```markdown
## MoE 路由

> "Routing collapse occurs when a small subset of experts dominates training, leading to capacity
> waste."
— Smith 2024, "Sparse Routing in Practice", p.7 (key: ABCD1234) · 红色 · #MoE #important

> 我的批注: 这跟我们看到的 expert imbalance 一致，可能要试试 load-balancing loss
— Smith 2024, p.7 · 黄色 · #MoE
```

### 4. Optional synthesis layer

If the user explicitly asks for synthesis ("帮我总结一下" / "提炼要点"), add a short top section
summarizing themes across the annotations — but always keep the verbatim aggregation below it. The
verbatim block is the source of truth; the synthesis is your interpretation and must not replace
it.

### 5. Deliverables

- A single markdown file. Default path: working directory, `annotation-digest-<filter>-<date>.md`.
- Offer to push to Obsidian via [[obsidian-feed]] (matches the user's "外部投喂" workflow).
- Offer to write it back to Zotero as a standalone note via [[zotero-mcp]] `write_note` (requires
  explicit confirmation per safety rules).

## Safety & quality

Inherits all rules from [[zotero-mcp]]. Plus:

- **Verbatim, always.** Never paraphrase the user's highlights or notes. Never "fix" their typos
  or grammar. They wrote it that way for a reason.
- **Cite source for every quote.** Item key + page if available. The user must be able to jump
  back to the original.
- **No fabrication.** If page numbers aren't in the annotation metadata, leave them out — don't
  guess.
- **Synthesis is opt-in.** Default behavior is aggregation, not interpretation. Don't write a
  "summary of the user's thinking" unless asked.
- **Read-only by default.** Writing the digest back into Zotero as a note, or pushing to Obsidian,
  is an explicit follow-up step requiring user confirmation per [[zotero-mcp]] write rules.
- **Don't dump everything.** If the filter returns >50 annotations, ask the user whether to
  (a) tighten the filter, (b) split by item, or (c) proceed with a longer digest.

## Failure modes

- **No matches**: tell the user what filter you tried and offer alternatives ("没找到红色#MoE标签的
  标注，你最近的MoE批注是黄色高亮，要看那批吗？").
- **Annotations exist but lack context**: a 3-word highlight with no surrounding sentence is
  often unhelpful in isolation. Pull a small context window from `get_content` (`mode: "preview"`)
  around the highlight if needed — but mark added context clearly so the user can distinguish
  their own words from PDF context.
- **Mixed languages**: preserve original language per annotation. Do not auto-translate.
