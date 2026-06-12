---
name: scope-and-plan
description: >-
  Explore and plan multi-file features, refactors, migrations, and ambiguous
  work before coding. Produces an approval-gated plan file for execute-increment.
  Use when starting large changes, refactors, migrations, API redesigns, or
  when requirements or approach are unclear.
---

# Scope and Plan

Follow `@agents/coding-philosphy.mdc` for all design decisions. This skill adds workflow and gates—it does not override the philosophy.

**Hard rule:** Do not write or edit code until the user approves the plan.

## When to use

- Multi-file features, refactors, migrations, API or boundary changes
- Ambiguous requirements or multiple valid approaches
- User says "plan", "design", "how should we", or describes work too large for a one-line intent

For obvious single-file fixes, state one-line intent and proceed—no full plan needed (philosophy tenet 7).

For external research or option comparison, read and follow [researcher](../researcher/SKILL.md) during the Explore step.

## Workflow

Copy this checklist and track progress:

```
- [ ] 1. Clarify
- [ ] 2. Explore
- [ ] 3. Design
- [ ] 4. Plan (template below)
- [ ] 5. Gate — wait for approval
```

### 1. Clarify

Confirm goal, constraints, and definition of done. If scope is ambiguous, ask—do not guess (tenet 2).

### 2. Explore

Search the repo first (tenets 5, 6):

- Existing helpers, patterns, and test utilities in the touched area
- Dominant local conventions when the codebase disagrees with itself
- Ownership or reviewer boundaries (`CODEOWNERS`, nested ownership files, or repo equivalents)

Note what can be reused vs. what must be new.

### 3. Design

Apply philosophy tenets 1, 3, and 8:

- Propose **one obvious path**—not a menu of options at every call site
- Sketch module/layer boundaries; dependencies point inward
- Offer 2–3 forks **only** when tradeoffs are real and the choice matters
- Wait for the third use before abstracting (tenet 3)

### 4. Plan

Present the plan in chat using [plan-template.md](plan-template.md). Omit the **Status** and **Plan drift** sections in chat—they belong in the file only.

Order increments so each slice is shippable and verifiable on its own (tenet 2). Prefer behavior-first slices over speculative scaffolding.

### 5. Gate

Stop after the plan. Wait for user approval or steering before any implementation or plan file write.

If the user adjusts scope or approach, update the plan in chat and re-gate.

## After approval

### Write the plan file

**When to write** (after approval):

- **Always** when the plan has 2+ increments, may span sessions, or the user asks for a file
- **Skip** when there is a single increment and you will implement in the same chat—chat is enough

**Where:** `.cursor/plans/<slug>.md` in the project workspace (`<slug>` = short kebab-case from the goal, e.g. `billing-service-extract.md`).

**How:**

1. Copy [plan-template.md](plan-template.md); set **Approved** date; fill all sections
2. Add one **Status** checkbox per increment (labels match the increment list)
3. Create `.cursor/plans/` if needed
4. If `.cursor/plans/` is not gitignored, add it to `.gitignore` unless the user wants plans committed

Tell the user the file path. They can `@`-mention it when running **execute-increment** in a new chat.

### Hand off

Point to **execute-increment** and the plan file path.

## Examples

See [examples.md](examples.md) for good and bad plans.
