# Integration Boundaries

## AutoDL

Use `autodl-bundle` to create a local manifest and runbook. Review data sensitivity,
cloud-upload permission, environment, expected cost, command, and result-return
plan. Do not upload data or start an instance without explicit approval.

```powershell
python -m researchops.cli --root . autodl-bundle <project-id> --command "<command>"
```

## Email

Use `email-preview` to create an `.eml` preview. Do not send without explicit
approval. Store credentials only in environment variables or an OS credential
store, never in the repository.

```powershell
python -m researchops.cli --root . email-preview --to "<address>" --subject "<subject>" --body "<body>"
python -m researchops.cli --root . smtp-readiness
python -m researchops.cli --root . send-email --to "<address>" --subject "<subject>" --body "<body>" --confirm-send
```

The send command requires `RESEARCHOPS_SMTP_*` environment variables and supports
authenticated SMTP over SSL or STARTTLS. Review a preview before sending.

## Zotero

Read/search/export operations are allowed when relevant. Confirm exact records and
destination before imports or other writes.

## Multi-Agent Coordination

Delegate bounded, independent, read-only evidence lanes. Require each lane to
return what it checked, key findings, caveats, and source identifiers. Do not
delegate the final Go/No-Go decision, protocol approval, paid actions, or external
communications.
