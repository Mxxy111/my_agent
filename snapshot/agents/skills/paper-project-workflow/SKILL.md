---
name: paper-project-workflow
description: End-to-end academic paper project workflow from initial requirements to final submission package. Use when the user gives a course, thesis, manuscript, review, grant-style paper, journal, or research-writing requirement and wants topic scoping, user-approved topic selection, literature review, optional bioinformatics/computational analysis, drafting, post-draft AI-flavor/humanization revision, multi-pass objective review with subagents when allowed, evidence/data/logic/citation checks, document export, or final paper delivery.
---

# Paper Project Workflow

## Purpose

Run a paper project as a staged, auditable workflow instead of a one-shot draft. The central contract is:

`intake -> requirements matrix -> candidate topics -> objective review loop -> user topic approval -> evidence/method plan -> optional analysis loop -> outline -> draft -> AI-flavor/humanization loop -> review loop -> final package`

Always answer in the user's language unless a target venue or assignment requires another language.

## Non-Negotiable Gates

1. Ask targeted intake questions before analysis when the user's context, constraints, data, or preferences are unclear.
2. Do not finalize the topic before user approval. Recommend, but do not silently decide.
3. Use objective review loops before advancing major stages. Prefer Codex subagents when the active user request and platform rules allow them; otherwise run separate inline reviewer passes and label them as less independent.
4. For bioinformatics, data science, computational, or code-backed papers, do not write result claims until code has run, results have been inspected, and the analysis has passed a QC/review loop.
5. After a draft is produced, run an AI-flavor/humanization loop when the paper will be submitted, graded, published, or shared as polished prose. The loop must improve naturalness without changing verified claims, citations, data, limitations, authorship responsibility, or required AI-use disclosure.
6. Before major production work, establish a compact project contract: paper type, reader, central question, one-sentence argument, evidence route, boundary, output format, and traceability plan.
7. Keep a decision and review trail for multi-step projects: requirements, assumptions, candidate topics, project contract, review findings, humanization changes, revisions, evidence sources, analysis outputs, and final checks.
8. Stop for explicit chat approval before package installs, external downloads of datasets/references/software/model weights beyond ordinary web-page/PDF reading, credentialed APIs, external uploads, paid compute, cloud processing of human/private data, Zotero library writes, writes outside the workspace, long-running jobs, formal submission, or changing a locked protocol/primary outcome.

## Capability Preflight

At the beginning of a full project, inspect what capabilities are available and choose the smallest working toolset. Read `references/capability-map.md` before promising a deliverable that depends on a plugin, local runtime, subagent, document renderer, reference manager, or bioinformatics pipeline.

Use `tool_search` when a needed MCP/app tool may be lazily available. Use local shell/runtime inspection for installed command-line tools and packages. Prefer official documentation or primary sources for unstable or technical facts.

For publication-grade, thesis, or data/code-backed projects, also read `references/pass-fail-gates.md` before advancing beyond topic selection.

For multi-turn, file-backed, or computational projects, record a `capability_preflight.md` using `references/artifact-templates.md`: tools found, tools absent, degraded routes, runtime versions, package probes, disk/network constraints, data sensitivity, renderer availability, and what was not checked.

Before executing any stage, check `references/skill-routing.md` and reuse existing specialist skills whenever they fit. This skill is the project orchestrator, not a replacement for dedicated literature, citation, document, figure, bioinformatics, data-analysis, debugging, or review skills.

## Project Contract Before Production

For publication-grade, thesis, data/code-backed, or multi-deliverable projects, create or update `project_contract.md` before heavy searching, drafting, analysis, figure building, or document export. Borrow the "contract first" pattern from the Nature skills:

- paper type/archetype: mechanism, method/tool, resource/dataset, clinical/population, review/perspective, course paper, proposal, or revision package
- reader contract: what the reader must understand in order: relevance, novelty, trust, reuse, meaning, and boundary
- one-sentence argument: `In [system/problem], the paper argues/shows [advance] using [approach/evidence], bounded by [limits].`
- evidence route: literature, dataset, code analysis, figures/tables, policy/guidelines, or mixed route
- source hierarchy: official guidelines and primary sources first, structured bibliographic metadata next, secondary databases only as discovery aids unless the task permits otherwise
- output contract: manuscript, reader, report, PPTX, response letter, figures, tables, data/code package, or final submission bundle
- traceability plan: stable IDs for claims, sources, figures/tables, data outputs, reviewer comments, and unresolved risks

Do not treat this as bureaucracy. It is the short shared contract that prevents later prose, citations, figures, and review responses from drifting away from the user's real objective.

## Stage 0: Intake Interview

Ask only the missing questions needed to frame the project. Keep the first interview short, usually 4-8 questions.

Resolve:

- paper type: course paper, thesis, review, systematic review, original research, bioinformatics paper, grant/proposal, response/revision, or presentation-derived paper
- audience and success target: grade, advisor approval, journal submission, publication exploration, internal report, or reproducible analysis
- hard constraints: title rules, structure, word count, language, citation style, figure/table requirements, formatting, deadline, AI disclosure rules
- user preference: safe/high-score, frontier/innovative, publishable, minimal workload, methods-heavy, writing-heavy, or balanced
- available materials: prompt, rubrics, draft, notes, data, code, PDFs, Zotero library, target journal, examples, advisor feedback
- risk tolerance: new but uncertain vs established and defensible
- data/analysis need: whether public datasets, sequencing, clinical cohorts, statistics, modeling, or code execution are expected

Output a compact project brief: task type, constraints, user preferences, open questions, and initial route.

Use `references/artifact-templates.md` for the project brief template when writing files.

## Stage 1: Requirements Matrix

Convert the initial requirements into a checkable matrix:

- required sections and order
- scoring dimensions or reviewer expectations
- citation minimums and recency rules
- evidence types required
- figure/table/dataset/code requirements
- formatting and submission requirements
- prohibited moves and academic integrity rules
- approval gates

If the assignment or journal guidelines are referenced but not provided, ask for the file/link or browse official sources when allowed/required.

Record pass/fail criteria from `references/pass-fail-gates.md` when the project will proceed beyond quick advice.

## Stage 2: Candidate Topic Generation

Generate a broad-to-narrow topic set. For each candidate include:

- working title
- research question
- central claim or hypothesis
- scope boundary
- evidence availability
- novelty and collision risk
- feasibility within word/time/data constraints
- likely structure
- main risks

If the user already supplied a topic, still test whether it is too broad, too narrow, stale, under-supported, ethically risky, or misaligned with the rubric.

Score candidates with the topic rubric in `references/pass-fail-gates.md` unless the user asks for a lighter brainstorming pass.

## Stage 3: Topic Review Loop

Run at least one objective review pass before presenting final topic choices. For complex or high-stakes projects, use multiple reviewers:

- topic feasibility reviewer
- novelty/collision-risk reviewer
- evidence sufficiency reviewer
- rubric/venue-fit reviewer
- methods/statistics reviewer when empirical claims are planned

Use `references/review-loop.md` for reviewer prompts and review ledger structure.

Then revise the candidates and present the user with:

- recommended topic
- 1-2 viable alternatives
- why weaker candidates were rejected
- evidence and feasibility caveats
- what the paper would argue

Stop here until the user approves a topic or asks to iterate.

## Stage 4: Evidence And Source Plan

After topic approval, build an evidence plan:

- search strategy and databases/tools
- inclusion/exclusion logic when applicable
- core papers, reviews, datasets, guidelines, or primary sources
- reference manager plan
- citation style
- evidence gaps and controversy map
- literature matrix fields

Define the source hierarchy for the project before collecting citations. For most papers, prefer:

1. target journal/course instructions, official guidelines, protocols, repositories, or policy pages
2. primary articles, datasets, code repositories, preprints when appropriate, and official publisher records
3. structured metadata sources such as DOI/Crossref/PubMed/arXiv records
4. review articles for framing and secondary databases for discovery

Use literature tools proportionally. For current or high-stakes claims, verify with live sources. For local PDFs, extract and summarize from the actual files rather than relying on memory.

Run an evidence review loop before drafting major claims. Check for invented citations, weak source fit, overreliance on one paper, missing counterevidence, and outdated metadata.

For long manuscripts, systematic/scoping reviews, citation-heavy drafts, or source-grounded readers, split work into stable batches by section or paragraph. Use stable IDs such as `C001` for claims, `S001` for sources, `F001` for figures, `T001` for tables, and `R1.1` for reviewer comments when relevant.

Read `references/literature-workflow.md` for search strings, screening, appraisal, extraction fields, and citation metadata verification.

## Stage 5: Route Analysis Needs

Decide whether the project is writing-only, evidence-synthesis, empirical/statistical, or bioinformatics/computational.

Use the bioinformatics branch when the project involves any of:

- FASTQ/BAM/VCF/count matrices, scRNA-seq, bulk RNA-seq, ATAC/ChIP/CUT&Tag, microbiome, metagenomics
- public omics databases, TCGA/GEO/SRA/ArrayExpress/GTEx/cBioPortal/OpenTargets or similar sources
- survival modeling, differential expression, enrichment, immune infiltration, machine learning, multi-omics integration
- code reproduction, package pipelines, notebooks, or figure generation from data

Read `references/bioinformatics-branch.md` before designing or running that branch.

## Stage 6: Analysis Plan Gate

For any data/code-backed project, write an analysis plan before coding:

- data source and access path
- sample inclusion/exclusion
- primary and secondary outcomes
- pipeline/method choices and rationale
- QC checks
- statistical tests and multiple-testing correction
- figure/table plan
- expected outputs
- failure modes and fallback analyses

Stop for user approval before running substantial analysis or changing a locked analysis plan.

Use the analysis-plan gate in `references/pass-fail-gates.md` and the template in `references/artifact-templates.md`.

## Stage 7: Build, Debug, And Result Loop

For code-backed projects:

1. Create a reproducible project layout.
2. Build minimal runnable scripts/notebooks.
3. Run them locally when feasible.
4. Debug errors systematically.
5. Save logs, parameters, intermediate data descriptions, figures, and tables.
6. Review results for quality and interpretation.
7. Revise code/methods when the review finds flaws.

Do not force a positive story. If results are negative, unstable, underpowered, or contradictory, either report that honestly or return to the user for a scope decision.

## Stage 8: Outline And Figure Plan

Create an outline that maps every major section to claims, evidence, methods/results, and figures/tables.

For standard scientific manuscripts, use an appropriate structure such as IMRAD. For course papers or proposals, follow the required order exactly. For reviews, decide whether the structure is narrative, scoping, systematic, mechanism-based, theme-based, or problem-solution.

Classify the paper route before outlining:

- discovery/mechanism: question to evidence to model to boundary
- methods/tool/algorithm: bottleneck to method to fair evaluation to reuse limits
- resource/dataset/atlas: need to generation/QC to validation to access/reuse
- clinical/population: design to endpoints to inference to bias/limits
- review/perspective: evidence map to controversy to synthesis to future boundary

For figures and tables, write a figure contract before creating or polishing assets: core conclusion, panel purpose, source data/provenance, statistics and `n`, caption job, export/format needs, and review risks.

Run a structure review loop before drafting. Check:

- Does the paper answer one clear question?
- Does each section have a job?
- Are claims arranged from background to gap to argument to implication?
- Are figures/tables serving the argument rather than decorating it?
- Are analysis results integrated where they belong?

For a compact demonstration of the staged workflow, see `references/worked-example.md`.

## Stage 9: Drafting

Draft in full prose unless the required format calls for bullets, tables, or protocol language.

Use a two-step pattern:

1. Make section-level key points with evidence anchors.
2. Convert to polished paragraphs with transitions and citation placement.

Maintain a claim-evidence map while drafting. Each major claim should carry an evidence anchor, status, and boundary. Keep claims close to the data or sources that support them.

Avoid:

- literature dumping
- unsupported claims
- methods/results mismatch
- overclaiming causality
- generic "future research is needed" endings
- AI-flavored filler or exaggerated novelty language

After completing an initial draft, freeze the draft version, evidence anchors, figures/tables, and claim-source map before style rewriting. This gives later reviewers something stable to compare against.

## Stage 10: AI-Flavor And Humanization Loop

Run this after the initial draft and before manuscript review for any polished deliverable. For quick chat-only advice or rough internal notes, ask whether the user wants this loop or record that it was intentionally skipped.

Select the smallest relevant specialist skill set from `references/skill-routing.md` and read each selected `SKILL.md` before applying it. Typical routing:

- `anti-ai-flavor`: default diagnostic pass for AI-tell density, markdown over-formatting, template phrases, and mixed-purpose documents
- `humanizer-zh`: Chinese prose or Chinese academic drafts that sound machine-generated
- `humanize-academic-writing`: English social-science drafts, especially for non-native English academic prose
- `nature-polishing`: publication-style scientific prose, Nature/Nature Communications-leaning polish, Chinese-to-English academic reconstruction
- `nature-writing`: section-level argument repair when the draft's structure or claim logic needs rebuilding before polishing

Use a controlled loop:

1. Diagnose first. Identify AI-flavored patterns by section or paragraph before rewriting.
2. Decide the rewrite scope: full draft, high-risk sections, abstract/introduction/discussion only, or sentence-level polish.
3. Rewrite for rhythm, specificity, argument flow, field voice, and reader trust.
4. Preserve scientific meaning: do not change data, statistics, citations, sample sizes, methods, results, limitations, claim strength, terminology, or required declarations unless the change is separately verified.
5. Compare original vs revised for claim drift and citation drift.
6. Record the pass in `review_log.md` or `style_revision_log.md`: specialist skills used, sections revised, major changes, and unresolved risks.
7. Rerun only the needed humanization or structure pass until the text passes the Humanization Integrity Gate in `references/pass-fail-gates.md`.

This loop is for authentic communication and readability, not for bypassing institutional AI-disclosure rules or hiding substantive AI assistance.

## Stage 11: Manuscript Review Loop

Run objective review passes after a complete draft or after any high-risk section:

- scientific logic and novelty
- literature/citation integrity
- methods/statistics or analysis validity
- evidence-to-claim alignment
- data, figure, table, and numeric consistency
- results interpretation
- writing clarity and field terminology
- target venue/rubric fit
- formatting and reference style
- academic integrity and AI disclosure

Use specialist skills proportionally for review, not only for writing. Examples: citation/reference review with `nature-citation` or literature-review skills; manuscript logic and Nature-style critique with `nature-writing` or `nature-polishing`; code, figure, and reproducibility checks with code-review/data/bioinformatics skills; AI-disclosure and AI-flavor checks with `anti-ai-flavor` or language-specific humanization skills.

Record findings, apply revisions, and rerun only the necessary reviewers. Keep major unresolved issues visible instead of smoothing them over.

Use the humanization-integrity, draft-readiness, and manuscript-review gates in `references/pass-fail-gates.md`.

If reviewer or editor comments are present, branch into a response package before finalization. Preserve every comment with stable IDs, classify severity and action, map each response to manuscript changes or `AUTHOR_INPUT_NEEDED`, and never invent line numbers, experiments, citations, or changes. Use `nature-response` when available.

## Stage 12: Finalization

Before final delivery:

- verify all required sections exist in the required order
- check word count and section balance
- verify citations and references, including DOI/PMID/URL when required
- ensure figures/tables are numbered, captioned, cited in text, and visually readable
- ensure data/code/materials availability statements, dataset citations, accession numbers, and source-data links are complete when applicable
- include funding, conflict, ethics, data availability, code availability, acknowledgments, and AI-use statements when applicable
- render and visually inspect DOCX/PDF/PPTX outputs when producing those formats
- produce a final package with manuscript, references, figures/tables, analysis outputs/code when requested, and a concise revision/check summary

Read `references/final-package.md` for the package manifest, naming conventions, deliverable-specific checks, and submission-readiness rubric.

## Project State Artifacts

For multi-turn or file-backed projects, maintain concise artifacts in the workspace unless the user asks for chat-only work:

- `project_brief.md`
- `project_contract.md`
- `requirements_matrix.md`
- `topic_candidates.md`
- `decision_log.md`
- `review_log.md`
- `style_revision_log.md` when the AI-flavor/humanization loop needs a separate trail
- `literature_matrix.md` or `.xlsx`
- `claim_evidence_map.md`
- `source_trace_map.md` for source-grounded readers, long citation work, or reviewer-response work
- `analysis_plan.md` for data/code projects
- `results_index.md` for generated outputs
- `final_checklist.md`

These files are operational records, not necessarily final deliverables.

Use the templates in `references/artifact-templates.md`. Keep them concise; do not let process files crowd out the manuscript or analysis. If the user appears to want chat-only planning, ask before creating operational files.

## References

- `references/capability-map.md`: tool and skill routing map for literature, documents, subagents, bioinformatics, figures, and exports.
- `references/review-loop.md`: objective reviewer roles, prompts, and review ledger format.
- `references/bioinformatics-branch.md`: data/code-backed paper workflow, QC gates, and analysis-loop criteria.
- `references/pass-fail-gates.md`: stage-specific rubrics and minimum thresholds.
- `references/literature-workflow.md`: search, screening, appraisal, extraction, and citation verification.
- `references/artifact-templates.md`: concise project-state templates.
- `references/final-package.md`: final package manifest and submission-readiness checks.
- `references/worked-example.md`: small example of the whole workflow.
- `references/skill-routing.md`: existing specialist skills to invoke by paper-project stage.
