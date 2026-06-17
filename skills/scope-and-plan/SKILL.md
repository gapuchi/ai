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

**Hard rule:** Do not write or edit code until the user approves the final plan (Gate C).

## When to use

- Multi-file features, refactors, migrations, API or boundary changes
- Ambiguous requirements or multiple valid approaches
- User says "plan", "design", "how should we", or describes work too large for a one-line intent

For obvious single-file fixes, state one-line intent and proceed—no full plan needed (philosophy tenet 7).

For external research or option comparison, read and follow [researcher](../researcher/SKILL.md) during Gate B.

## Workflow

Phased gates, coarse → fine. Each gate is cheap to redo; do not present the next level until the current one is confirmed.

```
- [ ] A. Framing — opt-in
- [ ] B. Architecture — required
- [ ] C. Increments — required
```

Stop after each gate and wait for confirmation. On disagreement, redo that gate only; don't reopen earlier ones unless the upstream answer changed.

### Gate A — Framing (opt-in)

Skip only when scope, constraints, and success criteria are all clear from the request. "Implement X" requests usually hide scope—prefer running A.

Present: goal (one sentence), constraints, non-goals, success criteria, open questions.

Confirm: *"Is this the right framing?"*

### Gate B — Architecture (required)

Explore the repo first (tenets 5, 6): existing helpers, dominant local conventions, ownership (`CODEOWNERS` or repo equivalent).

Present a **numbered decision list**, one item per load-bearing choice (e.g. transport, data source, system boundary, trigger model). Order by dependency: if decision X constrains decision Y's options, put X first.

For each decision:

- **Options** considered
- **Recommend** + one-line why
- **Fork?** yes/no — yes means the user should weigh in; no means you picked

Include open questions that could change a decision. Do **not** include file paths or increments yet.

Confirm: *"Are these the right architectural decisions? Any forks to discuss?"*

### Gate C — Increments (required)

Now resolve detail. Present the full [plan-template.md](plan-template.md) content in chat; omit **Status** and **Plan drift** (file only).

- One obvious path per implementation choice—pick, don't fork (forks belong at Gate B)
- Boundaries and files touched
- Shippable, verifiable increments in order; behavior-first over speculative scaffolding (tenet 2)
- Tradeoffs and risks

Confirm: *"Approve to write the plan file and hand off?"*

## After approval

### Write the plan file

**When:** plan has 2+ increments, may span sessions, or user asks for a file. Skip for single-increment work implemented in the same chat.

**Where:** `.cursor/plans/<slug>.md` (kebab-case from the goal, e.g. `billing-service-extract.md`).

**How:**

1. Copy [plan-template.md](plan-template.md); set **Approved** date; fill all sections including the decisions resolved at Gate B
2. Add one **Status** checkbox per increment
3. Create `.cursor/plans/` if needed; add to `.gitignore` unless the user wants plans committed

Tell the user the file path. They can `@`-mention it when running **execute-increment**.

### Hand off

Point to **execute-increment** and the plan file path.

## Examples

See [examples.md](examples.md).
