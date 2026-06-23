---
name: execute-increment
description: >-
  Implement one approved increment at a time for large changes—read the plan
  file from scope-and-plan, verify after each slice. Use when a plan is approved,
  the user says go ahead or implement, @-mentions a plan file, or continues
  work from scope-and-plan.
---

# Execute Increment

Follow `@agents/coding-philosphy.mdc` for all coding decisions. This skill adds incremental execution—it does not override the philosophy.

**Prerequisite:** An approved plan (from **scope-and-plan** or provided by the user). If there is no plan and the work is multi-file or ambiguous, stop and run **scope-and-plan** first.

## Load the plan

At the start of every session, load the approved plan before picking an increment:

1. **Plan file given** — User `@`-mentions a plan file or gives a path → read it
2. **No path given** — Use the approved plan from the current chat if this session completed **scope-and-plan**; otherwise ask which plan file to use (or whether to run **scope-and-plan** again)
3. **Ambiguous** — Ask; do not assume a default plans directory

The **plan file is source of truth** over chat summaries when both exist.

If no plan exists in chat or on disk and the work needs 2+ PRs or a new session, stop and run **scope-and-plan** (or ask where the approved plan lives).

## Workflow

Copy this checklist per increment:

```
- [ ] Load plan file
- [ ] Pick next unchecked increment
- [ ] Preflight (patterns in touched files)
- [ ] Implement (smallest complete slice)
- [ ] Verify (tests, linter, app)
- [ ] Checkpoint (chat summary + update plan file)
```

### 1. Pick next increment

Take the first unchecked item in the plan file **Status** section. Do not batch multiple increments unless the plan defines a single combined slice.

If the plan is stale (requirements changed, blocker discovered), stop and update via **scope-and-plan**. Re-gate if the approach or boundaries change materially.

### 2. Preflight

Re-read dominant patterns in files you will touch (tenet 6). Search for existing helpers before adding new ones (tenet 5).

### 3. Implement

- Smallest change that **completes** the increment
- Match repo naming, layout, errors, and types
- One idea per function; boring over clever (tenet 1)
- No speculative abstractions, unused parameters, or "we might need this" layers (tenets 3, 4)
- Push I/O and mutation to edges; keep core logic pure where practical

**Refactor after green:** Get behavior correct first; consolidate only once the increment works and tests pass (tenet 2).

### 4. Verify

Run applicable checks before moving on:

- Tests for changed behavior
- Linter on touched files
- App smoke if relevant

If verification fails twice on the same increment, stop—revisit the plan instead of stacking fixes.

### 5. Checkpoint

Report briefly in chat:

```markdown
## Done
[What this increment delivered]

## Verified
[Tests/linter/app checks run]

## Next
[Next increment from plan, or "plan complete"]

## Plan drift
[Anything that should update the plan—or "none"]
```

**Update the plan file** when one exists:

- Mark the completed increment `[x]` in **Status**
- Append notes to **Plan drift** when scope or approach shifted
- Update **Increments**, **Open questions**, or other sections if the plan changed—then re-gate with the user if boundaries or approach changed materially

Repeat until all **Status** items are checked. Before declaring done, run the **Before you ship** checklist in `@agents/coding-philosphy.mdc`.

## Per-slice checklist

See [increment-checklist.md](increment-checklist.md) for philosophy-aligned checks before marking an increment done.
