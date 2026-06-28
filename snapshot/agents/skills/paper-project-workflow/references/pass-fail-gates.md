# Pass/Fail Gates

Use these gates to decide whether a stage can advance. A stage passes when all "must pass" checks are satisfied and residual risks are recorded.

## Topic Approval Gate

Score each candidate 1-5 on:

| Criterion | Weight |
|---|---:|
| Fits user requirements/rubric/venue | 25% |
| Clear answerable research question | 20% |
| Evidence/data availability | 20% |
| Novelty or useful angle | 15% |
| Feasible within time/word/data limits | 15% |
| Ethical/academic integrity safety | 5% |

Must pass:

- research question can be stated in one sentence
- scope names population/system, exposure/intervention/mechanism/theme, and outcome/claim when relevant
- at least one credible evidence path exists
- user explicitly approves the topic

Fail if:

- topic is mainly a textbook survey with no argument
- evidence rests on one unverified source
- topic requires unavailable data or forbidden methods
- user has not approved the final topic

## Project Contract Gate

Must pass before heavy literature search, drafting, analysis, figure building, or artifact export in full projects:

- paper type/archetype and target reader are explicit
- central question and one-sentence argument are recorded
- evidence route and source hierarchy match the paper type
- output contract names the expected deliverables and required formats
- boundary states what the paper will not claim
- traceability plan names how claims, sources, figures/tables, data outputs, and review comments will be tracked

Fail if:

- the project is producing prose before the question, claim, evidence route, or boundary is known
- source hierarchy is vague for high-stakes, publication-grade, or citation-heavy work
- output expectations are ambiguous enough that the final package cannot be checked

## Evidence Sufficiency Gate

Must pass:

- search strategy is recorded
- inclusion/exclusion logic is stated for any systematic or scoping work
- source mix matches paper type: primary studies, reviews, methods papers, guidelines, datasets as needed
- key claims have direct supporting sources
- counterevidence or controversy has been checked
- citation metadata is verified enough for the target format

Fail if:

- citations are invented, unverified, or copied from secondary lists without checking
- references do not support the claims they are attached to
- recent/high-stakes claims rely only on stale sources

## Analysis Plan Gate

Must pass for data/code-backed papers:

- data source, access path, and sample/group definitions are explicit
- primary analysis and primary outcome are defined
- preprocessing/QC/statistics are defensible
- multiple-testing and confounder plans are included when relevant
- expected outputs and failure modes are listed
- runtime, package, disk/RAM, network, credential, and data-sensitivity preflight is planned
- user approves the plan before substantial execution

Fail if:

- group labels, endpoints, or data availability are uncertain
- analysis would require cloud/private/paid resources without approval
- planned conclusions are stronger than the design can support
- package installs, large downloads, credentialed access, or external uploads are needed but not approval-gated

## Result Readiness Gate

Must pass:

- code has run for every result claim, or the project scope is explicitly changed to "planned methods only" with no result claims
- workflow-specific executable and package checks pass, or approved install/fallback limitations are documented
- results are traceable to scripts/notebooks and input data
- QC checks are recorded
- figures/tables are readable and reproducible
- interpretation distinguishes association, prediction, mechanism, and causation

Fail if:

- code did not run but the draft presents observed results
- result claims are written from expected outcomes rather than observed outputs
- labels, sample IDs, or covariates are unresolved
- major QC failure is ignored
- generic preflight passed but the actual runner's required packages/tools were not checked

## Manuscript Review Gate

Must pass:

- central question, claim, and contribution are clear
- evidence supports each major claim
- major claims are represented in a claim-evidence map or equivalent traceable structure
- citations and references accurately support the claims they are attached to
- data, statistics, figures, tables, sample labels, and methods are internally consistent
- methods/results/discussion are internally consistent
- limitations are specific and proportionate
- terminology matches the field and target audience
- reviewer-style objections have been addressed or recorded
- required declarations, citation style, and venue/rubric expectations are checked

Fail if:

- the manuscript overclaims beyond evidence or analysis design
- citations are attached to claims they do not support
- numbers, figures, tables, or labels conflict with analysis outputs or cited sources
- major claims cannot be traced to sources, data, figures, or explicit author-provided rationale
- a high-severity reviewer finding remains unresolved without user acceptance
- prose is polished but the scientific argument is still unclear

## Draft Readiness Gate

Must pass:

- outline follows required structure
- each section has a defined job
- major claims have evidence anchors
- methods/results/discussion are aligned
- figures/tables are planned or available

Fail if:

- paper tries to answer multiple unrelated questions
- discussion introduces unsupported new claims
- draft would exceed word/format constraints without a compression plan

## Humanization Integrity Gate

Must pass after post-draft AI-flavor/humanization work:

- an AI-flavor or style diagnosis was run, or the loop was explicitly waived for a rough/internal deliverable
- the selected specialist skills match the draft language, field, and target venue
- revised prose is more natural, specific, and readable without becoming casual or promotional
- claim strength, citations, data, statistics, sample sizes, methods, limitations, terminology, and declarations are unchanged or separately reverified
- required AI-use disclosure and academic-integrity boundaries remain visible
- original and revised versions are compared for meaning drift before manuscript review

Fail if:

- the rewrite hides or removes required AI-use disclosure
- wording changes introduce unsupported causality, novelty, certainty, or broader scope
- citations, numbers, methods, or limitations are changed without verification
- the text only receives superficial synonym swaps while retaining template structure
- prose polish makes the paper sound stronger than the evidence allows

## Final Package Gate

Must pass:

- all required deliverables exist
- references and in-text citations are consistent
- figures/tables are cited and captioned
- figure/table source provenance and source-data traceability are recorded when applicable
- data/code/materials availability statements and dataset citations are complete when required
- document format and naming match requirements
- AI-use, ethics, conflicts, data/code availability, and acknowledgments are included when required
- rendered visual QA is complete for DOCX/PDF/PPTX when possible

Fail if:

- required sections or declarations are missing
- a final artifact was not opened/rendered/checked when visual fidelity matters
- source data, dataset accessions, repository links, or code availability are missing for claims that depend on them
- unresolved review findings would likely violate the rubric or venue rules
