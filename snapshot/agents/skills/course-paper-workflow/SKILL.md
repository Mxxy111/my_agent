---
name: course-paper-workflow
description: Lightweight course paper and academic report workflow for humanities, social sciences, education, management, communication, law-adjacent, history, philosophy, literature, politics, sociology, media studies, and general college writing assignments. Use when the user needs to parse an assignment prompt or rubric, choose or refine a topic, build a thesis and argument map, plan sources and readings, draft a course essay/report/literature review/book review/case analysis/policy memo, revise prose, remove AI-flavored writing while preserving integrity, check citations and formatting, or prepare a final class submission. Prefer the heavier paper-project-workflow for journal submission, thesis-scale projects, bioinformatics, reproducible data/code analysis, clinical/medical review, or publication packages.
---

# Course Paper Workflow

## Purpose

Run a course paper or class report as a compact, auditable workflow:

`assignment intake -> requirements matrix -> topic options -> user topic approval -> thesis/argument contract -> source plan -> outline -> draft -> humanization loop -> rubric review -> final submission check`

This skill is intentionally lighter than `paper-project-workflow`. It is for writing-centered assignments, especially humanities and social-science papers, where the main work is framing, argument, evidence, reading, citation, and prose quality.

Always answer in the user's language unless the assignment requires another language.

## Boundaries

Use this skill for:

- course papers, essays, term papers, seminar papers, reading reports, book reviews, literature reviews, case analyses, policy memos, reflection papers, and general academic reports
- humanities, social sciences, education, management, communication, law-adjacent, history, philosophy, literature, politics, sociology, media/cultural studies
- assignments where the expected evidence is readings, cases, policies, news, theories, books, articles, interviews, observations, or qualitative examples

Do not use this as the main workflow for:

- journal submission packages, dissertations, grant proposals, reviewer-response projects, or full publication workflows
- bioinformatics, omics, clinical, medical, or data/code-backed original research
- projects requiring statistical modeling, scraping, machine learning, reproducible notebooks, or large dataset analysis

If the task unexpectedly needs those heavier routes, switch to `paper-project-workflow` or a specialist skill and explain why.

## Non-Negotiable Gates

1. Do not start drafting before the assignment prompt, grading target, required structure, word count, citation style, and deadline are understood enough to avoid misalignment.
2. Do not finalize a topic without user approval unless the user explicitly asks you to choose.
3. Do not invent sources, quotes, page numbers, case facts, statistics, course readings, teacher preferences, or grading rules.
4. Keep the user's intellectual ownership visible: thesis, examples, class context, and stance should reflect the user's course and choices.
5. When using AI-humanization or anti-AI-flavor skills, improve naturalness without hiding required AI-use disclosure or changing the argument, citations, facts, quotations, or author stance.
6. Ask explicit approval before external downloads beyond ordinary web pages/PDF reading, paid/credentialed services, writes outside the workspace, or formal submission.

## Capability And Routing

Before doing specialist work, read `references/specialist-routing.md` and load only the relevant skill(s). Typical choices:

- `research-writing`, `nature-writing`, or `scientific-writing` for academic argument and section drafting
- `nature-academic-search`, `nature-citation`, or academic search tools for literature and citation verification
- `nature-reader`, `paper-analyzer`, or PDF/document skills for reading source materials
- `anti-ai-flavor`, `humanizer-zh`, `humanize-academic-writing`, or `nature-polishing` for post-draft humanization
- `documents:documents`, PDF, or local document tooling only when the user needs DOCX/PDF formatting

For multi-turn or file-backed assignments, keep concise operational artifacts using `references/artifact-templates.md`. For quick chat-only work, do not create files unless useful.

## Stage 0: Intake

Ask only the missing questions needed to frame the assignment. Usually 4-7 questions are enough.

Resolve:

- assignment type: essay, course paper, literature review, reading report, book review, case analysis, policy memo, reflection, presentation report, or other
- course/discipline and target audience
- prompt, rubric, required readings, required theories, allowed topic range
- word count/page count, language, citation style, formatting, deadline
- source requirements: number, type, recency, course readings vs outside sources
- user preference: safest high-score route, more original angle, easier workload, theory-heavy, case-heavy, or balanced
- available materials: prompt file, notes, PDFs, draft, teacher feedback, examples, course slides

Output a compact project brief and initial route.

## Stage 1: Requirements Matrix

Convert the assignment into a checkable matrix:

- required sections and order
- grading dimensions and hidden expectations
- citation/source minimums
- required theories, concepts, cases, or course readings
- prohibited moves: plagiarism, uncited AI use, unsupported claims, wrong format, off-topic scope
- final deliverable format and deadline

If the prompt or rubric is referenced but missing, ask for it. If only a partial prompt is available, proceed with visible assumptions and mark risks.

Use the `Course Requirements Gate` in `references/rubrics-and-gates.md`.

## Stage 2: Topic Options And Approval

Generate 3-6 topic options unless the user already has a topic. For each option include:

- working title
- research question or guiding question
- tentative thesis
- scope boundary
- likely evidence and readings
- difficulty and risk
- why it fits the assignment

If the user already supplied a topic, test whether it is too broad, too narrow, too descriptive, under-supported, or weakly connected to the course.

Run a light topic review using `references/review-loop.md`, then present a recommended topic plus alternatives. Stop for user approval before building the full paper plan.

## Stage 3: Thesis And Argument Contract

After topic approval, create a short argument contract:

- final or working title
- one-sentence thesis
- "so what" significance
- key concepts/theories
- scope boundary
- counterargument or tension
- expected contribution for the course

For most course papers, the best thesis is debatable, specific, and bounded. Avoid theses that merely announce a topic, summarize a book, or promise a list.

Use the `Thesis Gate` in `references/rubrics-and-gates.md`.

## Stage 4: Source And Reading Plan

Build a source plan proportional to the assignment:

- required course readings first
- primary texts/cases/policies/media artifacts where relevant
- peer-reviewed or scholarly secondary sources when required
- credible public sources only when suitable for the assignment
- optional background sources for context, not as main evidence

For each source, record what job it performs: concept, context, evidence, counterargument, example, method, or comparison.

Use a conservative source hierarchy:

1. assignment prompt, rubric, course readings, teacher-provided materials
2. primary text/case/policy/data artifact being analyzed
3. peer-reviewed articles, academic books, university press books, authoritative reports
4. news, websites, blogs, encyclopedias, or AI summaries only as context or discovery aids unless the assignment permits them

Do not cite a source unless it has been inspected enough to know what it supports.

## Stage 5: Outline

Create an outline that maps each section to a job, not just a topic label.

Common structures:

- argumentative essay: problem/context -> thesis -> reasons/evidence -> counterargument -> conclusion
- literature review: search scope -> themes -> debates/gaps -> synthesis
- reading/book report: central argument -> structure -> evidence -> critique -> course connection
- case analysis: case context -> analytical framework -> diagnosis -> evidence -> implications
- policy memo/report: issue -> criteria -> options -> recommendation -> limitations
- comparative essay: basis of comparison -> case A/B -> synthesis -> implication
- reflection paper: experience/text -> concept -> analysis -> changed understanding

For each major section, include:

- section claim
- evidence/source anchor
- paragraph purpose
- likely citation placement
- risk or missing evidence

Use the `Outline Gate` in `references/rubrics-and-gates.md`.

## Stage 6: Drafting

Draft from the outline in two passes:

1. Build paragraph-level key points with evidence anchors.
2. Convert them into full prose with clear transitions and citation placement.

Use a `claim -> evidence -> analysis -> link back` rhythm for body paragraphs. Course papers usually fail when they summarize sources instead of explaining how evidence supports the thesis.

Avoid:

- literature dumping
- five-paragraph template when the assignment needs real analysis
- unsupported generalizations
- fake profundity or inflated novelty
- vague "society should pay attention" endings
- citations that merely decorate a sentence
- overpolished prose that hides a weak argument

Maintain a lightweight claim-evidence map for major claims.

## Stage 7: AI-Flavor And Humanization Loop

Run this after the first full draft when the paper will be submitted, graded, or shared.

Choose the smallest relevant specialist skill:

- `anti-ai-flavor` for general AI-tell diagnosis and markdown/report cleanup
- `humanizer-zh` for Chinese prose
- `humanize-academic-writing` for English social-science academic prose
- `nature-polishing` when the draft needs serious academic English polish
- `nature-writing` or `research-writing` when sentence polish cannot fix weak argument structure

Loop:

1. Diagnose AI-flavored patterns first.
2. Revise structure or paragraphs only where needed.
3. Preserve thesis, facts, quotations, citations, examples, and course-specific voice.
4. Compare revised text against the draft for meaning drift.
5. Keep or add required AI-use disclosure when the course requires it.

Use the `Humanization Integrity Gate` in `references/rubrics-and-gates.md`.

## Stage 8: Review And Revision

Run a compact review loop before finalization. Use separate labeled reviewer passes or subagents when available:

- rubric/assignment-fit reviewer
- thesis and logic reviewer
- evidence and citation reviewer
- style and humanization reviewer
- formatting/final checklist reviewer

Record major findings, revise, and rerun only the necessary checks. Do not smooth over unresolved high-risk problems.

Use `references/review-loop.md` and the `Final Course Paper Gate` in `references/rubrics-and-gates.md`.

## Stage 9: Finalization

Before final delivery:

- confirm section order and required components
- check word count/page count
- verify citation style, in-text citations, reference list, and source minimums
- check title, headings, footnotes/endnotes, page numbers, filename, and submission format
- ensure quotations have page numbers when required
- ensure the conclusion answers the "so what" without overclaiming
- include AI-use disclosure if required by the course
- render or open DOCX/PDF when producing those formats, if tooling allows

Return the final paper plus a short submission checklist and remaining risks, if any.

## Project Artifacts

For multi-turn or file-backed course papers, use only the artifacts that help:

- `project_brief.md`
- `requirements_matrix.md`
- `topic_options.md`
- `argument_contract.md`
- `source_notes.md`
- `outline.md`
- `claim_evidence_map.md`
- `revision_log.md`
- `final_checklist.md`

Use `references/artifact-templates.md`. Keep process files short; the paper is the main deliverable.

## References

- `references/artifact-templates.md`: concise templates for course-paper working files.
- `references/rubrics-and-gates.md`: pass/fail gates for assignment fit, thesis, outline, evidence, humanization, and final submission.
- `references/review-loop.md`: lightweight reviewer roles and ledger format.
- `references/specialist-routing.md`: when to invoke writing, literature, citation, reading, document, and humanization skills.
