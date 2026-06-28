# Humanization Techniques

Use these strategies only after the user has approved a rewrite. Diagnose first
(see `ai-tells-checklist.md`), then apply matching techniques.

Each technique pairs with one or more dimensions from the checklist. Don't try
to apply all of them — pick the 3-5 most relevant for the specific document.

---

## Strategy 1: Cut Template Phrases (Single Highest-Yield Move)

Maps to dimension 1 (vocabulary), 3 (paragraph rhythm).

### English templates to delete

- `it is worth noting that` → just delete
- `it is important to note that` → just delete
- `in essence`, `at its core`, `fundamentally` → usually delete
- `moreover`, `furthermore`, `additionally` (sentence-initial) → delete or replace with logical connectors that aren't transition words
- `as previously mentioned` → delete
- `in conclusion`, `in summary`, `to sum up` → delete (let the conclusion be the conclusion)

### Chinese templates to delete

- `值得注意的是` → 删
- `综上所述` → 删
- `不难发现` → 删
- `总而言之` → 删
- `不仅如此` / `与此同时` → 删或换成具体的逻辑连接
- `在...的过程中` → 直接说"在...时"

### Why this works

These phrases give the illusion of structure without contributing meaning.
Removing them leaves the actual content visible. A surprisingly large fraction
of AI text shrinks by 15-25% from this single pass.

---

## Strategy 2: Vary Sentence Length

Maps to dimension 2 (syntactic), 3 (paragraph rhythm).

### Target distribution

A natural English paragraph has sentences ranging from ~5 words to ~35 words.
A natural Chinese paragraph has sentences ranging from ~10 字 to ~50 字.

CV (standard deviation / mean) should exceed 0.4.

### Technique

After the cut-templates pass, run a sentence-length sweep:

1. Identify sentences > 30 words. Split them. Each main clause gets its own sentence.
2. Identify regions where 3+ sentences in a row are 18-25 words. Add a 5-10 word punchy sentence.
3. Identify regions where 3+ sentences in a row are < 12 words. Combine some into a longer compound or complex sentence.

### Example

**AI version:**
> The model achieves high accuracy. The training is fast. The architecture is simple. These advantages make it useful.

**Human version:**
> The model is accurate, fast to train, and simple — three things rarely true at once.

---

## Strategy 3: Replace Abstract Scaffolding with Concrete Details

Maps to dimension 6 (content and stance).

### English replacements

- `various aspects` → name the actual aspects (3-4 of them)
- `multiple factors` → list the factors
- `in many cases` → give a specific case
- `studies have shown` → cite a specific study with author and year
- `significant improvement` → state the actual delta (15%, 0.3 SD, etc.)
- `challenges remain` → name the specific challenges

### Chinese replacements

- `许多研究表明` → 引具体一篇 (Joshi 2018 在 SEER 中)
- `在某些情况下` → 在 X 病例 / 在 Y 数据上
- `显著改善` → 改善了 15% / 提升 0.3 SD
- `多种因素` → 列出具体因素 (年龄、性别、肿瘤大小)

### Why this works

Concrete details are nearly impossible for an AI to fabricate. When they appear,
the writing reads as someone who actually knows the topic.

### Calibration

Don't over-do specificity. If the original document genuinely doesn't contain
the data, the rewrite cannot invent it. Tell the user where you couldn't be
specific and why. **Never fabricate citations or numbers.**

---

## Strategy 4: Reduce Markdown Over-Formatting

Maps to dimension 4 (markdown formatting). Most relevant for AI agent output.

### Format pass checklist (apply in order)

1. **Cut headers.** For each `##` and `###`, ask: is this a real topic boundary, or just a "section break for visual rhythm"? Delete the latter.
2. **Cut bold.** For each `**word**`, ask: does emphasizing this word change how the reader processes the sentence? If no, delete.
3. **Convert vertical bullet lists to prose** when:
   - the list has only 2-3 items, OR
   - the items are not strongly parallel, OR
   - the items together form a single argument (use a sentence)
4. **Remove decorative emoji** (✅ ❌ 🔥 💡 ⚡ as section markers, not as actual semantics).
5. **Convert "Pros and Cons" tables to prose**. A two-line sentence beats a 2x4 table for capturing trade-offs.
6. **Delete the closing "Summary"** section if it restates the body. If the user genuinely wants a summary, that goes at the top, not the bottom.
7. **Delete invented "Next Steps" / "TODO" / "FAQ"** sections that the user didn't ask for.

---

## Strategy 5: Add Author Stance

Maps to dimension 6 (content and stance).

### One-sentence injections

A single sentence anywhere in a paragraph can dramatically reduce AI flavor.
Templates:

- `我们之所以选 X 而不是 Y, 是因为 ___`
- `这里我倾向 ___, 主要是看中 ___`
- `the reason we picked X over Y is ___`
- `our take is that ___, mainly because ___`

### Avoid passive evasion

Replace:

- `is generally considered to be` → `we / I consider`
- `it is widely accepted that` → `most clinicians agree that` (specify who)
- `被普遍认为` → `临床上多数 X 都认为`

### Don't fake stance

If the original document is a neutral overview, don't inject opinions the
author didn't have. Ask the user for their actual position before rewriting.

---

## Strategy 6: Replace AI Vocabulary with Plain Verbs

Maps to dimension 1 (vocabulary).

### English swaps

| AI verb | Plain verb |
|---|---|
| delve into | look at, study, examine |
| leverage | use |
| utilize | use |
| conceptualize | think of, define |
| operationalize | measure, define how to measure |
| underscore | show, point out |
| showcase | show, demonstrate |
| streamline | simplify |
| harness | use, take advantage of |
| unlock | reveal, enable |
| navigate (the challenges of) | handle, deal with |
| facilitate | help, allow |
| commence | start, begin |
| terminate | end |
| in lieu of | instead of |
| in order to | to |

### Chinese swaps

| AI 词 | 朴素词 |
|---|---|
| 进行分析 | 分析 |
| 实现优化 | 优化 |
| 开展研究 | 研究 |
| 至关重要 | 重要 (or 删除) |
| 不可忽视 | 删除 |
| 显著 | 明显 (or 给具体数字) |
| 综上所述 | 删除 |
| 与此同时 | 同时 |

---

## Strategy 7: Cut Em Dash Overuse

Maps to dimension 5 (punctuation). NPR 2025 highlighted this as the most
visible 2025 AI tell.

### Rule of thumb

- < 2 em dashes per 1000 words is normal.
- 5+ per 1000 words is suspicious.
- 15+ per 1000 words is a giveaway.

### Replacements

- `X — Y — Z` style appositives → use commas: `X, Y, Z`.
- Em dash for emphasis → period and short follow-up sentence.
- Em dash as colon substitute → use the colon, or restructure.
- Em dash as parenthesis substitute → use parentheses.

### Don't ban em dashes entirely

Real writers use em dashes — Emily Dickinson built her style on them. The
problem is frequency, not presence. Keep 1-2 well-placed em dashes per 1000
words; that's natural.

---

## Strategy 8: Allow Imperfect Rhythm

Maps to dimension 3 (paragraph rhythm).

This is the hardest to teach an AI rewriter, but the most distinctive of human
writing. Techniques:

- **Allow a single-sentence paragraph.** One short paragraph that just states a
  point, surrounded by longer paragraphs.
- **Allow an aside in parentheses.** "(I tried it once on the wrong dataset and
  it was a disaster.)"
- **Allow self-correction.** "Actually, this isn't quite right — the difference
  is..."
- **Allow a half-sentence.** "Not because of speed. Because of memory."
- **Allow a tangent that returns.** "Side note: this is also why X. Anyway, back
  to the main point: Y."

### Example

**AI version:**
> The model is fast. The model is accurate. The model is also memory-efficient. These three properties make it suitable for production deployment.

**Human version:**
> Fast, accurate, and memory-efficient — and that last one mattered more than I expected. We picked it for production after we ran out of RAM on the previous model.

---

## Strategy 9: Chinese-Specific Considerations

### Avoid 成语 stacking

成语 are fine in moderation. The tell is density. Aim for at most one 成语
per paragraph, and only when it actually fits.

### Avoid 副词 chains

`非常...真的...十分...相当...` — pick at most one per paragraph. Strip the
others. Better still, replace with a concrete number or example.

### Avoid 书面化 over-formality

AI Chinese tends to use 书面语 phrases everywhere:

- `进行` instead of action verb
- `进行了一系列的` instead of just doing it
- `在...的基础上` instead of `根据`

Chinese readers register these as bureaucratic.

### Allow 口语化 (when appropriate)

For blog posts, internal reports, or conversational writing:

- 行 / 不行 instead of 可以 / 不可以
- 挺 / 还行 / 凑合 instead of 较好 / 一般 / 尚可
- 第一人称 + 真实经历: "我之前踩过这个坑..."

For formal academic writing, keep 书面 register but cut the worst AI fillers.

---

## Strategy 10: Preserve What Should Stay

Don't over-humanize. The following must be preserved:

- **Citations.** Author names, years, DOIs, page numbers stay exact.
- **Numbers.** Statistics, sample sizes, percentages stay exact.
- **Technical terms.** Field-specific vocabulary should stay; replace only generic AI words.
- **Logical structure.** If the original document has a clear argument, the
  rewrite should preserve it. Don't make text look more "human" by introducing
  contradictions or removing necessary connections.
- **Formal register where required.** Journal manuscripts, grant proposals,
  legal documents need formal English/Chinese; don't casualize them.

---

## Diagnostic-Aware Rewriting

The most efficient rewriting routine is diagnostic-driven:

1. From the diagnostic report, identify the 3 dimensions with the highest
   tell counts.
2. Apply only the strategies that target those 3 dimensions.
3. Run a second diagnostic pass to confirm the rewrite hit its target.
4. Stop. Don't keep editing.

Over-rewriting is a real risk. Many AI texts are improved by 80% with just
strategies 1, 2, and 4. Reach for the more aggressive strategies only when
the document still feels mechanical after the first pass.

---

## Output Format for Rewrites

For each rewritten paragraph:

```
### Paragraph N (line N)

**Original:**
<original text>

**Revised:**
<rewritten text>

**Why changed:**
<1-2 sentences listing the specific tells fixed and which strategies were applied>
```

For a full-document rewrite, additionally provide:

- a list of strategies actually applied
- a brief diff of the document's structure (e.g., "cut 6 redundant `##` headers, 22 `**bold**` emphases, 4 emoji decorations")
- a re-scored diagnostic snapshot showing the improvement
