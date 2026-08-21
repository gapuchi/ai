# .cursor/rules templates

## architecture.mdc (always on)

Thin pointer only. Replace guardrails with this repo's top 2–3 mistakes.

```markdown
---
description: Core project architecture — read AGENTS.md
alwaysApply: true
---

# Architecture

`AGENTS.md` is the source of truth for this repo — read it before substantive changes.

Quick guardrails (details in `AGENTS.md`):

- Layers: <a> → <b> → <c> → ...
- `<canonical helper>()` at call sites; `<scope resolver>()` in <context>
```

## Layer rule (glob-scoped)

One rule per layer agents frequently violate. Set `globs` to paths edited together.

```markdown
---
description: <Layer> conventions
globs: <paths>
alwaysApply: false
---

# <Layer name>

<One-line role.>

**Belongs here:**
- ...

**Belongs in <other layer> (not here):**
- ...

<Call-site pattern if not already in AGENTS.md>
```

## readme-sync.mdc

```markdown
---
description: Keep README.md in sync with user-facing behavior
globs: <paths that affect users — commands, main, config, README, .env.example>
alwaysApply: false
---

# README sync

`README.md` is user-facing. Update in the **same change** when operators or users see different behavior.

## Update README when you change

- <setup, env vars, permissions>
- <rules users care about — quotas, rate limits, feature flags>
- <config behavior not obvious from help>

Command names, options, permissions → docstrings and help — not README tables.

## Skip README for

- Internal refactors with no user-visible change
- Schema / client / test-only changes (unless they change commands or user-visible rules)

## What to update

| Change | README section |
|--------|----------------|
| ... | ... |

Keep `AGENTS.md` for architecture only — not user docs.
```

## When to add a new glob rule

Add a scoped rule when:

- Agents repeatedly put logic in the wrong layer for that path
- Edit-time reminders need function-level detail (api vs domain split)
- The detail would bloat `AGENTS.md` but is stable
- Stable edit-time decision rules (e.g. "use macro only when schema matches X") belong in glob rules, not `AGENTS.md` common tasks

Skip when:

- `AGENTS.md` + `architecture.mdc` are enough
- The rule would duplicate another rule or the codebase changes weekly
