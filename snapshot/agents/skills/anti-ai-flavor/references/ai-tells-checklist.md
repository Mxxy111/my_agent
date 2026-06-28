# AI Tells: Full Bilingual Checklist

This is the diagnostic reference. Use it line-by-line when the user wants a
detailed audit. Each item is in the form: `[ ] Tell description (with example)`.
Mark hits and quote the offending text with line/paragraph anchors.

---

## Dimension 1: Vocabulary Tells

### English red-flag words

These words appear at unusually high frequency in AI-generated text.
Sources: NPR 2025-11-10, The Conversation 2025, Wikipedia *Signs of AI writing*.

#### Verbs

- [ ] `delve / delves into` — single most reported AI tell. Real writers usually use `examine`, `look at`, `study`.
- [ ] `leverage` (as verb in non-finance context) — `use` is almost always better.
- [ ] `conceptualize`, `operationalize` — abstract verbs that bury concrete actions.
- [ ] `underscore`, `showcase`, `highlight` — every other paragraph emphasizes something.
- [ ] `streamline`, `unlock`, `harness`, `foster` (as transitive verb).
- [ ] `delineate`, `elucidate` — academic-sounding fillers.
- [ ] `navigate` (as transitive non-physical) — "navigate the challenges of...".

#### Adjectives

- [ ] `crucial`, `pivotal`, `paramount`, `vital`, `essential` — used as throwaway intensifiers.
- [ ] `comprehensive`, `holistic`, `multifaceted`, `nuanced` — vague positive labels.
- [ ] `robust`, `seamless`, `cutting-edge`, `state-of-the-art` — corporate-marketing tone.
- [ ] `intricate`, `complex`, `sophisticated` — when not actually establishing complexity.
- [ ] `unprecedented`, `groundbreaking`, `revolutionary`.

#### Connecting phrases

- [ ] `it is worth noting that` — almost always cuttable.
- [ ] `it is important to note that`, `it should be emphasized that`.
- [ ] `moreover`, `furthermore`, `additionally`, `in addition` — at sentence start.
- [ ] `in essence`, `at its core`, `fundamentally`, `ultimately`.
- [ ] `on the other hand` paired with `on one hand`.
- [ ] `not only ... but also ...` (more than once per paragraph).

#### Abstract metaphor nouns

- [ ] `tapestry`, `landscape`, `realm`, `journey`, `ecosystem`, `paradigm`.
- [ ] `the world of X`, `the realm of Y`.

### Chinese red-flag words

Sources: 鱼皮博客 2025, 知乎朱雀检测派.

#### 形容词大词

- [ ] 深入、全面、精准、卓越、显著、巨大、重大
- [ ] 至关重要、不可忽视、不容忽视、值得关注、值得一提
- [ ] 全方位、高效率、高品质、高水准
- [ ] 独特、独到、独具匠心
- [ ] 显而易见、不言而喻

#### 空话连接

- [ ] 综上所述、总而言之、由此可见、不难发现
- [ ] 值得一提的是、值得注意的是
- [ ] 不仅如此、与此同时、更进一步
- [ ] 在...的过程中、在...的背景下
- [ ] 总的来说、整体而言

#### 副词依赖症

每段密集出现的程度副词:

- [ ] 非常、十分、相当、极其、特别
- [ ] 真的、确实、的确
- [ ] 完全、彻底、绝对

鱼皮原文截图里 "非常" 在 4 行内出现 4 次,这是典型 AI 模式。

#### 成语堆砌

- [ ] 古色古香、跌宕起伏、应有尽有、无微不至
- [ ] 独具匠心、细致入微、面面俱到
- [ ] 引人入胜、扣人心弦、令人叹为观止

成语本身不是问题,问题在密度——AI 喜欢每段都来一个。

#### 中文 agent 输出特有

- [ ] "首先...其次...最后..."
- [ ] "一方面...另一方面..."
- [ ] "众所周知" / "我们都知道"
- [ ] "在当今社会" / "在数字化时代"

---

## Dimension 2: Syntactic Tells

### Sentence-level

- [ ] **Length variance too small.** Most sentences land in 20-25 words / 25-35 字. Real writers swing 5-40+.
- [ ] **Every sentence is "complete and tidy".** No half-sentences, no asides, no parentheticals as afterthoughts.
- [ ] **Triple parallels.** `首先 / 其次 / 最后`; `既...又...`; `不仅...而且...`. More than once per page = AI.
- [ ] **Heavy nominalization.** `进行了分析` instead of `分析了`; `make a decision` instead of `decide`; `实施了优化` instead of `优化了`.
- [ ] **Passive voice density high.** "被广泛认为", "被普遍接受", "is considered to be".
- [ ] **Long modifier chains.** "具有重要的临床意义和应用价值的研究"; "the crucial and pivotal role that this approach plays".
- [ ] **Through/via constructions.** `通过 X 实现 Y`, `通过 X 来 Y` — repeated mechanically.
- [ ] **Hedge stacking.** "可能" + "也许" + "或许" in adjacent sentences.

### Phrase-level

- [ ] **Empty modifiers.** `各种各样的 X`, `多种多样的 Y`, `various different`, `multiple diverse`.
- [ ] **Tautologies.** `重要的关键因素`, `the crucial key element`.
- [ ] **Filler verbs.** `进行 / 实施 / 实现 / 开展` followed by a noun that is itself the verb.

---

## Dimension 3: Paragraph Rhythm Tells

- [ ] Every paragraph follows topic-sentence + body + mini-summary template.
- [ ] Paragraph word-count standard deviation is small. Run a quick visual check: do all paragraphs look about the same height?
- [ ] No single-sentence paragraphs anywhere.
- [ ] No paragraph exceeds 6 lines.
- [ ] No abrupt topic shifts; everything is smoothly connected.
- [ ] No self-correction or "wait, let me reconsider" moments.
- [ ] Each paragraph opens with a transition word: `接下来`, `另一方面`, `更重要的是`, `Moreover`, `Furthermore`, `On the other hand`.
- [ ] Each paragraph ends with a wrap-up sentence ("综上,...", "These results suggest...").

---

## Dimension 4: Markdown Formatting Tells (AI Agent Output)

See `markdown-agent-tells.md` for the dedicated detailed list. Quick top items:

- [ ] `##` headers every 3 sentences; nested 3-4 levels deep.
- [ ] 8+ `**bold**` words per paragraph.
- [ ] Bullet nesting hell.
- [ ] Emoji decoration: ✅ ❌ 🔥 💡 ⚡.
- [ ] Tables for any two-thing comparison.
- [ ] Task list hallucination: `- [ ]` `- [x]`.
- [ ] Code block abuse for non-code content.
- [ ] Mandatory closing "Summary / Key Takeaways" section.

---

## Dimension 5: Punctuation Tells

### Em dash overuse — the most reported tell of 2025

Source: NPR 2025-11-10, *Inside the unofficial movement to save the em dash — from A.I.*
NPR coined the term "ChatGPT hyphen". One quoted writer:
*"It's like it's the only piece of punctuation they've learned other than a period."*

- [ ] Em dash (`—`) appears more than 5 times per 1000 words.
- [ ] Em dash used where a comma or period would suffice.
- [ ] Em dash setting off emphatic appositives in nearly every paragraph.
- [ ] Chinese text uses English-style em dashes mid-clause.

Note: em dash itself is fine and useful — Emily Dickinson loved it. The tell
is *frequency*, not presence.

### Other punctuation tells

- [ ] Colon-then-list repeats: "This means: 1. ...; 2. ...; 3. ...".
- [ ] Exclamation marks either rigidly "one per sentence" or completely absent.
- [ ] Quotes always paired and closed correctly (real writers leave dangling quotes).
- [ ] Semicolons appear at unusual frequency.
- [ ] Chinese-English mixed text has perfectly regular spacing around English words.
- [ ] Ellipses (`...`) used as dramatic pauses, not as actual omissions.

---

## Dimension 6: Content and Stance Tells

### No author stance

- [ ] Cannot find any sentence where the author commits to a position.
- [ ] No `我认为 / 我觉得 / I believe / I think / we argue that`.
- [ ] No reasons given for design choices: "we chose X because..." is missing.

### Symmetric two-sided framing

- [ ] Every claim has "this has both A advantages and B limitations".
- [ ] Every recommendation comes with "however, it should be noted that there are also challenges".
- [ ] Conclusions always include "more research is needed" or "需要进一步研究".

### Abstract over concrete

- [ ] `许多研究表明 / many studies have shown` without specific citations.
- [ ] `在某些情况下 / in certain cases` without specifying which cases.
- [ ] Generic examples instead of named instances. "A patient with kidney cancer" vs. "Mrs. K, age 62, ccRCC pT1b".
- [ ] No numbers, or only round-number placeholders.

### Lack of insight

- [ ] No counter-intuitive claims, no "huh, didn't expect that" moments.
- [ ] No genuine surprise, contradiction, or revision in the argument.
- [ ] Conclusions are exactly what one would predict from the setup.

### Cheerful filler

鱼皮 observation: AI 写结尾常加正能量, 像乖巧学生希望被表扬.

- [ ] Closing sentences sound forcibly upbeat.
- [ ] "These findings open exciting new avenues..."
- [ ] "未来值得期待 / promising prospects".
- [ ] Praises the field, the methodology, or the data itself ("this rich dataset").

### No real experience

- [ ] Cannot write "我做 X 时踩到的坑" / "the gotcha we ran into".
- [ ] Cannot write insider tricks: "in practice, you have to..."
- [ ] Failures and false starts are absent.

---

## Dimension 7: Agent Behavior Tells (Conversational Context)

### Meta-narration

- [ ] "接下来我会..." / "Now I'll analyze..." / "我们先来..."
- [ ] "让我们一起来看..." / "Let's take a look at..."
- [ ] "在我开始之前,先..." / "Before I begin, let me..."

### Self-praise / praise to user

- [ ] "这是一个很好的问题" / "Great question!"
- [ ] "你的观察很敏锐" / "That's a sharp observation".
- [ ] "你说得很对" / "You're absolutely right".

### Safety hedges

- [ ] "作为 AI 助手..." / "As an AI assistant..."
- [ ] "我没有个人情感,但..." / "I don't have personal feelings, but..."
- [ ] "我无法访问实时信息" / "I don't have access to real-time data".

### Closing rituals

- [ ] "还有什么我可以帮你的吗?" / "Anything else I can help with?"
- [ ] "你希望我继续深入哪一部分?" / "Which part would you like me to expand on?"
- [ ] "如果还有问题,请随时告诉我" / "Feel free to ask if you have more questions".

### Solution shape

- [ ] One big "complete plan" delivered without dialog.
- [ ] Unprompted risk listing: "Potential risks / Caveats" the user did not ask for.
- [ ] Over-apology: "非常抱歉给您带来困扰" / "I apologize for the confusion".
- [ ] Repeats user's question back as a heading: "## How to do X" when user asked "How do I do X?".

---

## Dimension 8: Quantitative Diagnostics

When you want to anchor the verdict in numbers, use these thresholds. These
are heuristics, not strict cutoffs.

### Fast-to-compute metrics

| Metric | Human typical | AI typical | How to estimate |
|---|---|---|---|
| Sentence length CV (SD/mean) | > 0.4 | < 0.25 | count words in each sentence; SD/mean |
| Paragraph length SD | large (1 to 6+ lines) | small (similar heights) | visual scan |
| Adverb density (`非常 / 真的 / 十分`) | < 1% | 3-5% | grep + total word count |
| Bold word ratio (markdown) | < 2% | 5-15% | count `**` pairs / total words |
| Em dash per 1000 words | < 2 | 5-15 | count `—` / (words/1000) |
| Header / paragraph ratio (md) | < 0.2 | 0.4-0.8 | count `#` lines / paragraph count |
| First-person pronouns | present (genre-dependent) | near zero or only "we" | grep |
| Triple-parallel patterns per 500 words | 0-1 | 3+ | search `首先...其次` etc. |

### Slower / qualitative metrics

| Metric | Human typical | AI typical |
|---|---|---|
| Has at least one self-correction | yes | almost never |
| Has at least one specific named example | yes | rare |
| Has author stance sentence | yes | rare |
| Has counter-intuitive claim | sometimes | almost never |
| Has half-sentence or aside | sometimes | almost never |

### Composite scoring

For each of the 8 dimensions:

- 0 tells found in dimension → 0 points
- 1-2 tells → 1 point
- 3-5 tells → 2 points
- 6+ tells → 3 points

Total score (max 24):

- 0-3: likely human
- 4-9: AI-assisted, lightly edited
- 10-16: AI heavy
- 17+: raw AI output

---

## How to Use This Checklist in a Diagnostic Pass

1. Read the document once for context.
2. For each dimension above, scan for the specific tells.
3. Quote the offending snippet with anchor (line N or paragraph N).
4. Score each dimension (0-3 points).
5. Sum to get severity verdict.
6. Identify the **top 5 worst sentences** (worst = most tells per sentence).
7. Output report following the template in `SKILL.md`.

Do not aim for exhaustive listing. Focus on the most diagnostic 1-3 examples
per dimension. The user wants actionable signal, not a full inventory.
