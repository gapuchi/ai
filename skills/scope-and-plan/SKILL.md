---
name: scope-and-plan
description: >-
  Explore and plan multi-file features, refactors, migrations, and ambiguous
  work before coding. Produces an approval-gated plan with boundaries and
  increments. Use when starting large changes, refactors, migrations, API
  redesigns, or when requirements or approach are unclear.
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

Output using this template:

```markdown
## Goal
[One sentence]

## Approach
[The one obvious path]

## Boundaries
[Modules/layers touched; stable contracts; seam translations]

## Increments
1. [Smallest shippable slice]
2. [...]

## Files / areas
- `path/` — [why]

## Tradeoffs & risks
- [...]

## Open questions
- [...]
```

Order increments so each slice is shippable and verifiable on its own (tenet 2). Prefer behavior-first slices over speculative scaffolding.

### 5. Gate

Stop after the plan. Wait for user approval or steering before any implementation.

If the user adjusts scope or approach, update the plan and re-gate.

## After approval

Hand off to **execute-increment** for implementation. Reference the approved plan in each checkpoint.

## Examples

See [examples.md](examples.md) for good and bad plans.
