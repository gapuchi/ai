---
name: execute-increment
description: >-
  Implement one approved increment at a time for large changes—verify after
  each slice before continuing. Use when a plan is approved, the user says
  go ahead or implement, or when continuing work from scope-and-plan.
---

# Execute Increment

Follow `@agents/coding-philosphy.mdc` for all coding decisions. This skill adds incremental execution—it does not override the philosophy.

**Prerequisite:** An approved plan (from **scope-and-plan** or provided by the user). If there is no plan and the work is multi-file or ambiguous, stop and run **scope-and-plan** first.

## Workflow

Copy this checklist per increment:

```
- [ ] Pick one increment
- [ ] Preflight (patterns in touched files)
- [ ] Implement (smallest complete slice)
- [ ] Verify (tests, linter, app)
- [ ] Checkpoint (summary + next)
```

### 1. Pick one increment

Take the next item from the approved plan. Do not batch multiple increments unless the plan defines a single combined slice.

If the plan is stale (requirements changed, blocker discovered), stop and update the plan via **scope-and-plan** before continuing.

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

Report briefly:

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

Repeat until all increments are done. Before declaring done, run the **Before you ship** checklist in `@agents/coding-philosphy.mdc`.

## Per-slice checklist

See [increment-checklist.md](increment-checklist.md) for philosophy-aligned checks before marking an increment done.
