---
name: setup-agent-docs
description: >-
  Create or audit per-repo agent documentation (AGENTS.md, .cursor/rules/,
  deep-dive READMEs). Use when bootstrapping a new repo, reviewing agent docs
  for drift or duplication, or the user asks how to document architecture for
  agents.
---

# Setup Agent Docs

Follow `@agents/coding-philosophy.mdc`. This skill defines **where** docs live and **how** to write them—it does not override coding standards.

**Goal:** Agents get durable, low-drift guidance. Humans get a reproducible process for any repo.

**Docs describe canonical structure** — the boundaries and patterns agents should follow (`coding-philosophy` tenets 1, 8). Do **not** canonize messy or inconsistent layout as repo convention just because the code does it today.

## When to use

- New repo needs `AGENTS.md` and `.cursor/rules/`
- Existing agent docs are stale, duplicated, or bloated
- User asks to "document this for agents" or audit `AGENTS.md`
- A structural refactor merged and skills/rules still reference old layout
- `AGENTS.md` exceeds ~120 lines or contains module/file inventory tables

For large refactors of the codebase itself, run **scope-and-plan** first; use this skill for the documentation deliverable (as a plan increment or standalone).

## Doc tiers (what lives where)

| Tier | Location | Put here | Do not put here |
|------|----------|----------|-----------------|
| **User** | `workspace/ai` — `coding-philosophy.mdc`, workflow skills | Cross-repo style, planning workflow, git/PR protocol | Repo architecture, domain model |
| **Repo canonical** | `AGENTS.md` | Layer concepts, domain rules, opinionated patterns, task routing, anti-patterns | File trees, function catalogs, generic coding advice, user setup |
| **Repo scoped** | `.cursor/rules/*.mdc` | Edit-time detail for matching globs; thin `architecture.mdc` pointer | Full architecture essay (that's `AGENTS.md`) |
| **Repo procedures** | `.cursor/skills/` in the repo | Multi-step workflows (add-league, migrations) | Architecture, invariants |
| **Deep dive** | e.g. `src/db/README.md` | Schema, ER diagrams, entity relationships | Command behavior, layer boundaries |
| **User-facing** | `README.md` + command docstrings | Setup, env vars, behavior users and operators see | Architecture, agent conventions |

**One source of truth per fact.** If `api-layer.mdc` lists what belongs in `client.rs`, `AGENTS.md` states the layer split—not the same function list.

## AGENTS.md best practices

### What belongs

- Purpose, layer concepts, domain scope
- Canonical entry points and concern-based task routing
- Anti-patterns and copy-paste verify commands

### What does not belong

- Generic style → `coding-philosophy`
- User setup → `README.md`
- Module trees / inventory → code + grep
- Procedures → repo skills
- Edit-time detail → glob rules
- Schema ER → deep dive

### Three-layer split

| Layer | Owns | Does not own |
|-------|------|--------------|
| `AGENTS.md` | Facts and invariants | Procedures, edit-time detail, inventories |
| `.cursor/rules/*.mdc` | Scoped how for matching paths | Full architecture essay, multi-step workflows |
| `.cursor/skills/**` | Multi-step procedures | Architecture, domain invariants |

Link outward; do not copy the same fact across layers.

### Size and drift

Target **~80–120 lines** (~150 max). Every section must answer: *What would an agent do wrong without this?* If grep answers it, delete or move.

After a structural refactor: update skills + glob rules first; trim `AGENTS.md` to decision rules only — do not paste module maps.

## Workflow

```
- [ ] 1. Explore — map layers, domain, and adapter seams
- [ ] 2. Check philosophy alignment — flag structural deviations; stop if unresolved
- [ ] 3. Draft AGENTS.md — template below
- [ ] 4. Add .cursor/rules/ — architecture + glob rules
- [ ] 5. Add deep dives — only where agents need them (schema, etc.)
- [ ] 6. Add readme-sync.mdc — if README exists
- [ ] 7. Audit — checklist below
```

**Audit/trim after refactor:**

```
- [ ] Update repo skills + glob rules first (inventory, procedure)
- [ ] Trim AGENTS.md to decision rules + links
- [ ] Run audit checklist
```

### 1. Explore

Before writing, read the codebase (tenets 5, 6):

- **Layers** — transport, domain, persistence, use cases, adapters (CLI, HTTP handlers, commands)
- **Domain scope** — what context key agents must always pass (tenant, org, workspace, user)
- **Adapter vs use case** — where framework types stop and plain logic begins
- **Opinionated entry points** — helpers agents bypass at their peril (`default_for_scope()`, `api_client()`, etc.)
- **Common change paths** — "new endpoint", "new table", "new background job"

Ask: *What would an agent get wrong without docs?* Document that—not the file tree.

### 2. Check philosophy alignment

Compare the codebase to `coding-philosophy` — especially **clear boundaries (8)** and **effects at the edges**. Look for:

- Framework or transport types in domain/core modules (Discord, HTTP, DB rows in business logic)
- Business logic in adapters (commands, handlers) that should live in use cases or domain
- I/O or mutable shared state where a stable inner boundary is feasible
- The repo disagreeing with itself (two patterns for the same concern; one path updates state, another does not)

**Small or flat repos are fine** — not every project needs a layer cake. Flag only real violations or inconsistency, not “no `db/` folder.”

If you find structural deviations, **stop and call them out to the user before drafting docs.** Do not write `AGENTS.md` or `.cursor/rules/` that instruct agents to copy the deviation (e.g. “put orchestration in `commands.rs`” when philosophy says use cases).

Present:

1. **What diverges** — concrete modules/patterns, with brief examples
2. **Why it matters** — what agents would learn wrong if docs matched today’s code
3. **Forks** (user picks one):
   - **Refactor first** — run **scope-and-plan** (then **scope-and-plan Gate D**); bootstrap docs after structure aligns or per plan increment
   - **Document canonical target** — `AGENTS.md` describes the intended boundaries; code may lag (note gaps only if the user asks)
   - **Bootstrap without structural sections** — overview, scope, conventions, running checks only; defer layer/task routing until structure is fixed
   - **Explicit override** — user approves documenting current layout as-is (rare; say why)

Default: **refactor first** or **document canonical target** — not “honest map of today’s mess.”

### 3. Draft AGENTS.md

Use [agents-md-template.md](agents-md-template.md). Target **~80–120 lines**; shorter if the repo is small.

Write only after step 2 is resolved. Layer and task-routing sections describe **canonical** boundaries (per user’s fork), not debt agents should extend.

**Include:**

- Related docs (links to cross-repo rules, deep dives, `.cursor/rules/`)
- Short project overview (stack + purpose)
- Layer table + adapter/use-case split — when structure is aligned or user chose **document canonical target**
- Domain section (scope keys, stable identifiers, setup/bootstrap rules)
- Key patterns (canonical helpers, imports)
- Repo-specific conventions (error types, test paths, release command)
- Common tasks table — routes to canonical locations, not “where messy code lives today”
- What not to do (consolidated anti-patterns — include philosophy violations to avoid)
- Running checks

**Exclude:**

- Module layout trees (drift immediately; the source tree is truth)
- API catalogs (method tables discoverable in code)
- Generic coding style (link `coding-philosophy`)
- README content (link `readme-sync.mdc`)
- Duplicating scoped `.mdc` detail
- **Known-bad patterns** presented as normal repo convention (unless user chose **explicit override**)

### 4. Add `.cursor/rules/`

Use [rule-templates.md](rule-templates.md).

| Rule | `alwaysApply` | Purpose |
|------|---------------|---------|
| `architecture.mdc` | `true` | Points to `AGENTS.md` + 2–3 guardrails only |
| `<layer>.mdc` | `false` + globs | Edit-time detail for that layer |
| `readme-sync.mdc` | `false` + globs | When to update `README.md` |

Do not restate full `AGENTS.md` in always-on rules.

### 5. Deep dives

Add only when agents need reference material that would bloat `AGENTS.md`:

- DB schema → e.g. `docs/schema.md` or `src/db/README.md` with ER diagram
- Link from `AGENTS.md` Related docs—do not inline the diagram

### 6. readme-sync.mdc

If the repo has a `README.md`, add a rule that:

- Lists user-visible changes requiring README updates
- Says command details live in docstrings / help—not README tables
- Points agent architecture to `AGENTS.md`, not README

### 7. Audit

Run [audit-checklist.md](audit-checklist.md). Fix duplication before declaring done.

## Gate

**Structural deviations (step 2):** always stop and present the callout + forks. Do not write repo docs until the user picks a fork (or asks to proceed with a specific one).

For a **new** doc set on an existing repo: after alignment is resolved, present the proposed `AGENTS.md` outline and which `.mdc` rules you'll add; wait for approval before writing files.

For **audit/trim**: show what you'll remove and why; if existing docs canonize philosophy violations, flag them like step 2 and propose trim or refactor — apply after user confirms.

## Reference pattern

A solid doc set for a layered app often looks like:

- **Layers** — handlers → services → persistence → use cases → CLI (names vary; document the **canonical** split aligned with `coding-philosophy`)
- **Scope** — tenant/workspace rules and canonical resolvers documented in `AGENTS.md`
- **Entry points** — one named helper per seam (`api_client()`, `default_for_scope()`, etc.)
- **Rules** — thin `architecture.mdc` plus glob rules (`api-layer`, `db-layer`, `readme-sync`)
- **Deep dive** — schema README (or equivalent) when detail would bloat `AGENTS.md`

Example: [gapuchi/league-bot](https://github.com/gapuchi/league-bot) — League dispatch, `soccer_poll`, thin `architecture.mdc`, glob rules, `add-league` skill.

If the repo does not yet match this pattern, use step 2 forks — do not shrink the philosophy to fit the code in `AGENTS.md`.

## Hand off

After docs land: point the user to symlink `workspace/ai` per root `README.md` if not already linked.
