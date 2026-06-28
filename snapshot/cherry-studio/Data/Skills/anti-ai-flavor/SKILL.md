---
name: anti-ai-flavor
description: >-
  Detect and remove "AI flavor" / "AI 味" from any document, including AI agent
  markdown output (over-bold, bullet hell, emoji decoration, em dash overuse,
  template phrases like "delve / leverage / 综上所述 / 至关重要 / 不可忽视").
  Provides an 8-dimension identification checklist (60+ tells) and humanization
  strategies for both English and Chinese text, covering prose, academic drafts,
  and AI agent markdown reports. Use when the user asks to 去AI味, 去除AI痕迹,
  让文章不像AI写的, 识别AI生成内容, AI味重, AI味太浓, humanize AI text,
  remove AI tells, detect ChatGPT writing, ChatGPT hyphen, em dash overuse,
  朱雀检测分析, AIGC检测, polish AI-drafted markdown documents, or 减少AI痕迹.
when_to_use: >-
  Use this skill before or after any AI-generated draft when the user wants the
  output to read like a human wrote it. Triggers include: identifying AI patterns
  in their own or third-party AI text, diagnosing why a markdown document feels
  "AI-written", reviewing AI agent output for over-formatting, preparing
  AI-drafted reports/notes/articles for human-facing distribution, or auditing
  existing documents for AI tells before submission. Use this skill instead of
  humanize-academic-writing when the document is general-purpose (blog, report,
  agent output, mixed-language) rather than strictly an English social-science
  manuscript.
version: 1.0.0
author: Built from NPR (2025), The Conversation, Microsoft 365 Copilot guide, 鱼皮博客 and 知乎朱雀检测派
---

# Anti-AI-Flavor: Detect and Humanize AI Writing

Two-stage workflow: **diagnose first**, rewrite only after user confirmation. Covers general prose, AI agent markdown output, and mixed Chinese-English drafts.

For English social-science manuscripts, prefer `humanize-academic-writing`. For Nature-style manuscripts, prefer `nature-polishing`.

## Default Stance

- **Diagnose before rewriting.** Anchor every tell to a quoted snippet with line/paragraph reference, not vague impressions.
- **Never claim AI authorship with certainty.** Use phrases like "high AI-tell density" or "patterns consistent with AI generation".
- **Preserve facts when rewriting.** Citations, numbers, technical terms, and the document's argument must stay intact.
- **Goal is authentic communication, not evading detection.** Do not help users bypass legitimate AI-disclosure requirements in journals, classrooms, or workplaces.

## When to Open Reference Files

| File | Open when |
|---|---|
| [references/ai-tells-checklist.md](references/ai-tells-checklist.md) | You need the full 60+ item checklist with bilingual examples for diagnostic line-by-line review |
| [references/markdown-agent-tells.md](references/markdown-agent-tells.md) | The target document is AI agent markdown output (RAG report, code review summary, technical note) and you need the format-specific tell list |
| [references/humanize-techniques.md](references/humanize-techniques.md) | The user has approved a rewrite and you need the detailed strategy library |
| [examples/before-after.md](examples/before-after.md) | You need to show the user concrete before/after rewriting examples for calibration |

## Core Workflow

### Step 1: Diagnose

Read the document and run the 8-dimension audit below. Produce a report with:

1. **AI-tell density score** per section (0-10 per dimension).
2. **Specific tells found**, each with a quoted snippet and line/paragraph anchor.
3. **Overall severity verdict**: likely human / AI-assisted / AI heavy / raw AI.

Open `references/ai-tells-checklist.md` for the full 60+ item list when needed.
For markdown-format-heavy documents, also open `references/markdown-agent-tells.md`.

### Step 2: Confirm with User

Before rewriting, ask the user explicitly:

- whether they want a full rewrite, a section rewrite, or just the diagnosis
- whether to preserve the existing markdown structure or relax it
- whether the target audience expects formal or conversational tone

Do not rewrite unilaterally.

### Step 3: Rewrite (Only if Approved)

Open `references/humanize-techniques.md` for the strategy library. Highest-yield moves first: cut template phrases, vary sentence length, replace abstract scaffolding with concrete details, reduce markdown over-formatting.

For each rewritten paragraph output: `Original` → `Revised` → `Why changed` (1-2 sentences listing the specific tells fixed).

## 8 Dimensions of AI Tells

When diagnosing, scan all 8 dimensions. Full 60+ item bilingual checklist with examples lives in `references/ai-tells-checklist.md`. For markdown agent output specifically, also open `references/markdown-agent-tells.md`.

1. **Vocabulary** — `delve / leverage / 综上所述 / 至关重要` and similar AI-flag words
2. **Syntactic** — sentence length uniformity, triple parallels, heavy nominalization
3. **Paragraph rhythm** — uniform paragraph shapes, no half-sentences or asides
4. **Markdown formatting** — over-bold, bullet hell, emoji decoration, table strafing
5. **Punctuation** — em dash overuse (NPR 2025 "ChatGPT hyphen"), colon-list templates
6. **Content & stance** — no author position, abstract over concrete, no counter-intuitive claims
7. **Agent behavior** — meta-narration, self-praise, closing rituals
8. **Quantitative diagnostics** — see thresholds below

### Quick Quantitative Thresholds

| Metric | Human range | AI typical |
|---|---|---|
| Sentence length CV | > 0.4 | < 0.25 |
| Bold word ratio (markdown) | < 2% | 5-15% |
| Em dash per 1000 words | < 2 | 5-15 |
| Header / paragraph ratio (md) | < 0.2 | 0.4-0.8 |
| Adverb density (`非常 / 真的 / 十分`) | < 1% | 3-5% |
| Triple-parallel patterns / 500 words | 0-1 | 3+ |

Full thresholds and per-dimension scoring rubric: `references/ai-tells-checklist.md`.

## Severity Verdict

Count how many of the 8 dimensions show 3+ tells:

- **0-2 dimensions hit**: likely human writing.
- **3-4 dimensions hit**: AI-assisted, lightly edited; minor cleanup helpful.
- **5-6 dimensions hit**: AI-heavy; substantial rewrite recommended.
- **7-8 dimensions hit**: raw AI output; full humanization pass needed.

## Output Format

### Diagnosis Report (default)

```
# AI-Flavor Audit: <document>

## Severity Verdict
<likely human | AI-assisted | AI heavy | raw AI>  (X / 8 dimensions hit)

## Tells by Dimension
### N. <dimension name>
- "<quoted snippet>" (line N): <tell description>

## Quantitative Snapshot
- <metric>: <value> (<verdict>)

## Top 5 Most AI-Sounding Sentences
1. "..." (paragraph N)

## Recommended Next Step
<full rewrite | section rewrite | self-edit checklist>
```

### Rewrite Output (when approved)

For each paragraph: `Original` → `Revised` → `Why changed` (1-2 sentences listing the specific tells fixed).

## Important Boundaries

For authentic communication, not for deceiving AI detectors or academic-integrity systems.

- Do not help bypass plagiarism / AI-detection tools or remove legitimate AI-use disclosures.
- Preserve accurate citations and data in journal submissions, formal reports, grant applications.
- Remind users to follow institutional rules about disclosing AI assistance.

## Sources

Synthesized from NPR (2025-11-10) on em dash overuse, The Conversation 2025 on AI vocabulary, Microsoft 365 Copilot humanize guide, 鱼皮博客 (cnblogs.com/yupi), 知乎朱雀检测派, and Wikipedia *Signs of AI writing*. Per-dimension citations live in the reference files.
