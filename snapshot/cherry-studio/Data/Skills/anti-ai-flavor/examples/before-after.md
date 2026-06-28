# Before / After: Humanization Examples

Concrete rewrites paired with explanations of what tells were fixed. Use these
as calibration when running a real rewrite.

---

## Example 1: Generic Marketing Prose (English)

### Before (raw AI)

> In today's rapidly evolving digital landscape, leveraging cutting-edge
> artificial intelligence solutions has become absolutely crucial for businesses
> seeking to maintain a competitive edge. By delving into the multifaceted
> capabilities of modern AI platforms, organizations can unlock unprecedented
> opportunities for growth — opportunities that streamline operations,
> facilitate data-driven decision-making, and ultimately foster innovation
> across multiple business verticals.

### Tells found

- Vocabulary: `rapidly evolving digital landscape`, `leveraging cutting-edge`,
  `absolutely crucial`, `delving into`, `multifaceted`, `unlock`,
  `unprecedented`, `streamline`, `facilitate`, `foster`, `multiple business
  verticals` — over a dozen AI-flag words in one paragraph.
- Syntactic: 2 sentences, both 35+ words, both passive-leaning.
- Punctuation: 1 em dash for emphasis (here it's borderline, but combined with
  everything else, it's part of the pattern).
- Content: zero specifics. No company, no metric, no actual capability.

### After (humanized)

> AI is now table stakes for most businesses. The teams that get value from it
> aren't the ones with the biggest models — they're the ones who picked one
> workflow (say, support ticket triage), measured it for three months, and
> shipped a real change. Everything else is theater.

### Why changed

- Cut all 12+ AI-flag words; replaced with plain language.
- Replaced abstract claim ("foster innovation") with a concrete recommendation
  (pick one workflow, measure, ship).
- Added author stance ("Everything else is theater" is a position, not a
  hedge).
- Mixed sentence lengths: 8, 38, 7 words.
- Kept one well-placed em dash; cut filler phrases entirely.
- Result: from 78 words of nothing to 50 words of something.

---

## Example 2: Chinese Academic Paragraph

### Before (raw AI)

> 在当今医学影像学迅猛发展的背景下,深度学习技术作为人工智能领域至关重要的一个分
> 支,正在以前所未有的方式深刻改变着临床诊断的方方面面。综上所述,深度学习不仅显
> 著提升了诊断的准确率,而且大幅缩短了诊断时间,与此同时,在多个不同的医学领域中
> 都展现出了不可忽视的应用价值。值得注意的是,虽然该技术取得了显著的进展,但仍然
> 存在一些不可忽视的挑战需要进一步深入研究和探讨。

### Tells found

- 词汇: `当今`、`迅猛发展`、`至关重要`、`前所未有`、`深刻改变`、`方方面面`、
  `综上所述`、`显著`、`不可忽视` (出现两次)、`值得注意的是`、`进一步深入研究` ——
  AI 词密度 ~25%。
- 句法: 三句话句长极相近(60-70 字),全是长复合句。
- 立场: 没有作者观点,没有具体方法、具体疾病、具体数字。
- 段落节奏: 标准"开题 + 总论 + 转折"AI 三段式。

### After (humanized)

> 深度学习近几年在医学影像里跑得很快,但实际进入临床的还是少数几个场景:乳腺钼
> 靶筛查、糖网分级、肺结节检测。这三个能落地是因为它们都有大量已标注的图像和明
> 确的二分类结局。其他大多数任务,标签噪声、域偏移和外部验证不足这三个问题压根
> 还没解决。

### Why changed

- 删掉所有 AI 词:`当今`、`迅猛发展`、`至关重要`、`综上所述`、`不可忽视` 等。
- 把"显著提升 / 大幅缩短"换成具体场景(乳腺钼靶、糖网、肺结节)。
- 把"存在挑战"换成具体的三个问题(标签噪声、域偏移、外部验证)。
- 加入作者立场(只有这三个场景能落地;其他没解决)。
- 句长从 60+/60+/60+ 改为 65/40/45,有节奏。
- 删除"值得注意的是"、"进一步深入研究"等空话。

---

## Example 3: AI Agent Markdown Report

### Before (raw AI agent)

```markdown
## 🎯 项目概述

本项目旨在构建一个 **高性能** 的 **数据分析平台**,通过 **整合多种先进技术**
为用户提供 **全方位** 的解决方案。

### 📋 核心特性

- **可扩展性:** 支持横向扩展,能够 **轻松应对** 海量数据
- **可维护性:** 模块化设计,代码 **清晰易懂**
- **高性能:** 优化的算法,**显著提升** 处理速度
- **易用性:** 友好的 **用户界面**,降低 **使用门槛**

### 🚀 技术栈

我们采用了以下 **业界领先** 的技术:

| 技术 | 用途 | 优势 |
|---|---|---|
| Python | 后端开发 | 生态丰富 |
| React | 前端开发 | 组件化 |

## 📌 总结

综上所述,本项目通过 **现代化的技术栈** 和 **优秀的架构设计**,
能够 **有效地** 满足业务需求,**值得推荐**。
```

### Tells found

- 格式:emoji 装点(🎯 📋 🚀 📌)、bold strafing(每行 2-3 个 `**`)、
  pros-and-cons 表格(只有 2 行内容)、强制"## 总结"。
- 词汇:`高性能`、`先进技术`、`全方位`、`轻松应对`、`清晰易懂`、`显著提升`、
  `业界领先`、`综上所述`、`有效地`、`值得推荐` —— 几乎每行都有 AI 词。
- 内容:零具体信息。没说 Python 哪个版本、什么场景、谁用、性能多好。
- 结构:三个 `##` headers,每个底下又有 `###`,层级冗余。

### After (humanized)

```markdown
# 数据分析平台

后端用 Python (FastAPI),前端 React。横向扩展靠 Kubernetes,数据走 ClickHouse。
单节点目前能扛 200K events/s,加节点线性提升。

主要权衡:
- ClickHouse 写入快,但 update 是个坑,得用 ReplacingMergeTree
- React 组件化好,但 SSR 配起来比 Next.js 麻烦
- FastAPI 的 async 在 CPU 密集任务里反而慢,要走 background worker

适合 1B 行以内的实时分析场景。再大就该考虑 ScyllaDB 了。
```

### Why changed

- 删掉所有 emoji 装点。
- 删掉所有 AI 形容词(`高性能` → 200K events/s 的具体数字)。
- 把 "## 项目概述 / ### 核心特性 / ### 技术栈 / ## 总结" 四级结构压成一段
  prose + 一个 bullet list。
- 删掉空表格(`Python 生态丰富 / React 组件化` 这种废话)。
- 加入真实的 trade-off(ClickHouse update 坑、SSR 配置麻烦、async CPU 密集慢)
  —— 这些是真用过才知道的。
- 加入边界条件("1B 行以内"),给读者清楚的适用范围。
- 删掉"综上所述...值得推荐"。
- 体积从 ~200 字 + 7 处 bold + 4 处 emoji 降到 ~110 字 + 0 bold + 0 emoji,
  信息量反而上升。

---

## Example 4: Agent Conversation Closing

### Before (raw AI)

> 这是一个很好的问题!我已经为你分析了 X 的优缺点,并提供了 Y 个建议。
>
> ## 总结
>
> - ✅ X 适合 A 场景
> - ❌ X 不适合 B 场景
> - 💡 推荐使用 Y 替代方案
>
> 希望这些信息对你有帮助!如果还有其他问题,请随时告诉我!

### Tells found

- 谄媚开头:"这是一个很好的问题"。
- 元叙述:"我已经为你分析了"。
- 强制总结:重复上文已经说过的内容。
- emoji 装饰列表。
- 询问式结尾:"希望这些信息对你有帮助!如果还有其他问题,请随时告诉我!"

### After (humanized)

> X 在 A 场景下管用,B 场景下别用 —— 那场景里 Y 更合适。

### Why changed

- 删掉"这是一个很好的问题"开头。
- 删掉"我已经为你分析了"的元叙述。
- 删掉"## 总结"标题(整段就一句话)。
- 删掉 emoji。
- 删掉"希望对你有帮助 / 如果还有问题"的客套结尾。
- 三条信息(X 适合 A、X 不适合 B、推荐 Y)合并成一句话,信息量不变,字数从
  60+ 降到 25。

---

## Example 5: When NOT to Humanize

Sometimes preserving "AI flavor" is correct. Examples:

### Case 5a: Formal RFP / contract

A formal request-for-proposal needs `本项目`, `综上所述`, `值得注意的是`-style
language because that's the register the audience expects. Stripping it makes
the document feel unprofessional in that context.

**Recommendation**: keep formal register; only cut the worst redundancies.

### Case 5b: Compliance documentation

Regulatory submissions, GxP documents, or formal medical records have strict
formal language requirements. Don't humanize toward casual.

**Recommendation**: rewrite for clarity and accuracy, but keep the formal
register intact.

### Case 5c: Translated content

If the source language uses certain phrasings that look like AI tells in
English, don't strip them — they may be faithful translation. Verify with
the original source first.

**Recommendation**: ask the user for the source text; preserve fidelity over
"humanization".

---

## Calibration Notes

After running a rewrite, do a final sanity check:

- Did meaning change anywhere? It shouldn't.
- Did any citation, number, or technical term get altered? They shouldn't.
- Is the voice consistent across paragraphs? Don't have one paragraph in
  formal register and the next in colloquial.
- Did the document get shorter or longer? Most humanizations end up shorter
  because AI text has high filler density. If your rewrite is much longer
  than the original, you probably added invented content — review.
