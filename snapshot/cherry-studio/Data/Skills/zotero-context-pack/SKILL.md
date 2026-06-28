---
name: zotero-context-pack
description: >-
  Build a focused literature context pack from the user's Zotero library to feed into AI coding or
  research projects. Use when the user says things like "我要做X项目，从我Zotero里挑相关文献作为支撑",
  "给这个课题准备背景资料", "把我库里相关的文献打包给AI看", "context pack from Zotero",
  "为AI开发项目准备文献上下文". Output is a single markdown bundle that can be pasted into another
  agent (Cursor, Claude Code, ChatGPT) as project context — not a citation export and not a written
  literature review.
---

# Zotero Context Pack

Goal: turn a project topic / requirement description into a compact, agent-ready markdown bundle of
the most relevant items from the user's Zotero library. Different from [[zotero-citation]] (which
attaches refs to existing prose) and [[zotero-litreview]] (which writes review prose).

Depends on [[zotero-mcp]] for tool semantics and safety.

## Inputs

Accept any of:
- A free-text project description ("我在做基于X的Y系统，需要……")
- A draft spec / README
- A list of sub-questions the user wants the AI agent to be informed about

If the input is too vague to generate good search queries, ask **one** clarifying question (scope?
domain? methods of interest?) — then proceed.

## Procedure

### 1. Decompose the topic into search facets

Extract 3-6 search facets covering different angles:
- core method / technique
- application domain
- adjacent / contrasting approaches
- evaluation methodology
- tooling / datasets

Show the facets to the user briefly so they can correct framing before searching.

### 2. Search the library per facet

For each facet, run in this order until you have ~3-5 candidates:
1. `semantic_search` with a natural-language paraphrase (this is the strongest signal when
   embeddings are available).
2. `search_library` with concept keywords if semantic returns thin results.
3. For top hits, `find_similar` to surface adjacent items.

Pool candidates across facets, dedupe by item key.

### 3. Score and select

Rank candidates by:
- relevance to the project description (semantic score + manual judgment from abstract)
- recency (favor recent unless the user wants foundational works)
- whether the user has annotated the item (`get_annotations` count > 0 → bonus, since the user
  has read it)
- coverage diversity (avoid 5 papers on the same exact sub-topic)

Default cap: **5-10 items**. More than 10 dilutes the pack and exhausts the receiving agent's
context.

### 4. Extract per-item context

For each kept item, produce:
- Citation header: `Author Year, Title, Venue (item key: ABCD1234)`
- 2-4 sentence summary derived from `get_item_abstract` (verbatim quote when possible).
- Key takeaway in 1 sentence — *why this paper matters for the user's project specifically*.
- Optional: 1-2 verbatim quotes from `get_content` (`mode: "preview"`) if a specific section is
  load-bearing. Use `search_fulltext` to locate the right passage rather than dumping pages.
- Optional: any user annotations on this item (`get_annotations`) — quote verbatim, never
  paraphrase the user's own notes.

### 5. Assemble the bundle

Output a single markdown document with this structure:

```markdown
# Context Pack: <project topic>

> Generated from <N> items in user's Zotero library on <date>.
> Facets covered: <facet1>, <facet2>, ...

## Quick map
| # | Author Year | Why it matters here | Item key |
|---|---|---|---|
| 1 | ... | ... | ABCD1234 |

## Sources

### 1. Author Year — Title
- Venue: ...
- Item key: `ABCD1234`
- Summary: ...
- Why for this project: ...
- Key excerpts:
  > "verbatim quote from PDF…"
- User annotations:
  > "user's own highlight, verbatim"

### 2. ...
```

End with a short **Gaps** section: facets where the library had no good match, so the receiving
agent knows to ask for external sources.

### 6. Deliver

Save to a path the user picks (default: working directory, `context-pack-<slug>-<date>.md`).
Offer to also push to Obsidian via [[obsidian-feed]] if the user uses that workflow.

## Safety & quality

Inherits all rules from [[zotero-mcp]]. Plus:

- **Verbatim user content.** Annotations are the user's own thinking — never reword them.
- **No fabrication.** If the abstract doesn't say something, don't invent it. Say "abstract does
  not address X" rather than guessing.
- **Honest gaps.** If a facet has no good library coverage, list it under Gaps explicitly. Better
  to admit a gap than to pad with weak matches.
- **Token discipline.** The output bundle is meant to be pasted into another agent. Keep each item
  block under ~200 words unless the user asks for more depth. Prefer `mode: "preview"` for any
  PDF read.
- **No writes.** This skill is read-only against Zotero. If the user wants the selected items
  collected into a Zotero collection (a separate write action), confirm first and use
  `add_items_to_collection` per [[zotero-mcp]] rules.

## Failure modes

- **Empty library coverage**: tell the user, list the facets you searched, and offer
  [[zotero-find-gap]] or [[nature-academic-search]] to fill from the open web.
- **Embeddings not yet built**: if `semantic_search` returns nothing or errors, fall back to
  `search_library` + `find_similar`. Tell the user once that semantic is unavailable so they can
  rebuild the index if needed.
- **Pack too large**: if relevant items exceed 10, ask whether to (a) tighten facets, (b) split
  into multiple packs by facet, or (c) proceed with a longer pack accepting context cost.
