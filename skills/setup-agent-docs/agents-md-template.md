# AGENTS.md template

Copy and replace placeholders. Delete sections that don't apply. Link `coding-philosophy`—do not restate it.

Before writing: each section must pass "What would an agent do wrong without this?" Link skills and glob rules for everything else.

```markdown
# Agent guide

## Related docs

- **Cross-repo** — `coding-philosophy` rule; `scope-and-plan` skill (`workspace/ai`)
- [`<deep-dive path>`](<path>) — <what it covers, e.g. schema>
- [`.cursor/rules/`](.cursor/rules/) — scoped reminders (`architecture`, `<layer-rules>`, `readme-sync`)

## Project overview

<One paragraph: what it is, stack, data sources, what's live vs planned.>

## Layer boundaries

Strict layers — edit-time detail in `.cursor/rules/`:

| Layer | Role |
|-------|------|
| `<path>/` | <role> |
| ... | ... |

**<Adapter> vs use cases** — <adapters do X; use cases do Y>.

| Concern | Adapter | Use case |
|---------|---------|----------|
| ... | ... | ... |

New behavior: use case first → adapter → registry (router, command list, etc.).

```<language>
// Minimal pattern: adapter calls use case
<one canonical call line>
```

**<Background job / worker>** — <how it differs from request path; what scope it processes>.

## <Domain concept> (<e.g. multi-tenant, workspace scope>)

<Prose: what the scope key is, how commands vs workers resolve it.>

- Commands: `<CanonicalResolver>(...)`
- Workers: `<ListAll>(...)`
- Setup: <bootstrap rules>
- Stable key: `<id>` for <what entities>
- Do not hardcode <ids>
- <Other rules agents violate without docs>

## <Domain area with shared vs variant behavior> (optional)

<One paragraph: when behavior is shared vs variant. Decision question agents must ask.>

Procedure: `<skill>` or `<glob rule>`. Do not list modules here.

## Key patterns

- `<helper>()` — <when to use; what not to pass instead>
- Types from `<module>`; domain helpers from `<module>`

## Repo conventions

Generic coding standards → user-level **`coding-philosophy`**.

- **Tests** — `<paths>`
- **Errors** — `<types per layer>`
- **Releases** — `<how to version/release>`

## Common tasks

| Task | Where |
|------|-------|
| ... | ... |

## What not to do

- <Anti-pattern tied to layer boundary>
- ...

## Running checks

```bash
<test/lint commands>
```
```

## Section priority

If trimming, keep in this order:

1. Layer boundaries + adapter split
2. Domain scope rules
3. Key patterns + what not to do
4. Common tasks
5. Repo conventions + running checks

Drop first: file trees, API catalogs, long code samples.
