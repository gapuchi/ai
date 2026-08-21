# Agent docs audit checklist

Run after creating or trimming `AGENTS.md` and `.cursor/rules/`. If philosophy alignment fails, stop and use **step 2 forks** in [SKILL.md](SKILL.md) — do not patch docs to match bad structure.

## Philosophy alignment

Compare docs (and the codebase they describe) to `coding-philosophy` — especially **clear boundaries (8)** and **effects at the edges**.

- [ ] Layer and task-routing sections describe **canonical** boundaries — not debt agents should copy or extend
- [ ] Docs do not normalize philosophy violations (framework types in domain, business logic in adapters, inconsistent patterns for the same concern)
- [ ] "What not to do" includes violations to **avoid**, not only historical quirks
- [ ] Common tasks route to canonical locations — aligned with code or an explicit **document canonical target** fork
- [ ] If existing docs canonize structural deviations: **stop**, call out to the user, and pick a fork (refactor first, canonical target, minimal bootstrap, or explicit override) before declaring done

Small or flat repos are fine — flag real violations or inconsistency, not missing optional layers.

## Placement

- [ ] Generic coding style only in `coding-philosophy` — not `AGENTS.md` or Cursor User Rules
- [ ] User-facing setup only in `README.md` — not `AGENTS.md`
- [ ] Architecture only in `AGENTS.md` — not `README.md`
- [ ] Schema/ER detail in deep-dive README — not inlined in `AGENTS.md`
- [ ] Skills own procedures; `AGENTS.md` links, does not copy steps
- [ ] Procedures in skills; path-specific how in glob rules

## Duplication

- [ ] `architecture.mdc` points to `AGENTS.md` — does not restate full layers
- [ ] Glob rules own edit-time detail — `AGENTS.md` owns concepts, not function catalogs
- [ ] Same fact not in AGENTS + mdc + skill + User Rules
- [ ] `Related docs` links outward instead of copying content

## Drift resistance

- [ ] No module layout file tree
- [ ] No refactor inventory (module tables mirroring `src/`) in `AGENTS.md`
- [ ] No tables of every method on a type (link module or let agents grep)
- [ ] Common tasks table routes by **concern**, not by listing every file
- [ ] "What not to do" is one consolidated list

## Usefulness

- [ ] Domain scope rules documented (what agents get wrong without this)
- [ ] Adapter vs use case split clear if the repo has one
- [ ] Opinionated entry points named (`helper()`, `default_for_*`, etc.)
- [ ] Running checks section has copy-paste commands
- [ ] An agent new to the repo could find where to edit for a new command/table/endpoint

## Cursor User Rules (manual)

- [ ] Git commit + PR workflow in User Rules UI only
- [ ] Communication preferences in User Rules UI only
- [ ] Code principles **removed** from User Rules if duplicated in `coding-philosophy`

## Size

- [ ] `AGENTS.md` under ~120 lines unless domain is genuinely complex (~150 hard max)
- [ ] Every section answers: "what would an agent do wrong without this?" — not "what did we just build?"
