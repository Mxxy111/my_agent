# Workflow Contract

## Deep-Dive Completion Gate

A topic dossier may recommend `Go` only when it contains:

- a precise clinical or biological question;
- reproducible searches and stable identifiers for key evidence;
- the strongest direct competitors and a defensible incremental contribution;
- at least one verified feasible dataset or a clearly stated acquisition plan;
- a minimum feasibility test;
- major failure modes and a useful negative-result narrative.

The user, not the agent, approves formal project creation.

## Project Artifact Contract

Every registered project must retain:

- `project.json`: machine-readable identity and phase;
- `protocol/protocol.md`: question, outcomes, and analysis lock;
- `data/data-manifest.csv`: provenance, access, terms, and local location;
- `references/evidence.csv`: claims and stable source identifiers;
- `decisions/decision-log.md`: approvals and material changes;
- analysis commands, outputs, reports, and failure logs.

Do not silently overwrite user-authored artifacts. Keep planned and exploratory
analyses distinguishable.

## Report Gate

Before presenting a conclusion:

1. Run `python -m researchops.cli --root . validate <project-id>`.
2. Resolve or disclose every finding.
3. Link numeric claims to output files and literature claims to source identifiers.
4. State limitations, negative findings, and unresolved uncertainty.

