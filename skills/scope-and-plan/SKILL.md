---
name: scope-and-plan
description: >-
  Explore and plan multi-file features, refactors, migrations, and ambiguous
  work before coding. Produces an approval-gated, resumable plan (plan.md +
  scratch.md) before implementation. Use when starting large changes,
  refactors, migrations, API redesigns, or when requirements or approach are
  unclear.
---

# Scope and Plan

Follow `@agents/coding-philosphy.mdc` for design decisions. This skill adds workflow and gates—it does not override the philosophy.

**Hard rule:** No code until **Plan** and **Gate D** are both approved (D assumes Plan is settled).

## When to use

- Multi-file features, refactors, migrations, API or boundary changes
- Ambiguous requirements or multiple valid approaches
- User says "plan", "design", "how should we", or work too large for one-line intent

Obvious single-file fixes: state one-line intent and proceed (philosophy tenet 7).

## Workflow

One subject, top-down. Each gate settles before the next descends.

```
- [ ] A. Framing — opt-in      (goal, scope, success)
- [ ] B. Architecture — required   (components, boundaries, transport)
- [ ] C. Design — required         (abstractions, seams, contracts)
- [ ] P. Plan — required           (commit: decisions, boundaries, contracts, diagram)
- [ ] D. Increments — required     (PR stack only — how to ship)
```

| Gate | Wait when | Otherwise |
|------|-----------|-----------|
| A | Scope or success unclear | Skip if all clear (see A) |
| B, C | Unresolved **Hard fork** | Objection window; see [Confirm (B and C)](#confirm-b-and-c) |
| P | Always | — |
| D | Always | — |

Disagreement → redo that gate only; don't reopen earlier unless upstream changed.

### Decision tiers

Classify load-bearing decisions at B and C. **Multiple options ≠ fork**—only unresolved choices that matter.

| Tier | Label | When | Gate behavior |
|------|-------|------|---------------|
| **Assumed** | _(none)_ | Framing, constraints, or repo convention bind the choice; cheap to reverse | Recommend + one-line why. Move on. |
| **Soft fork** | **Soft fork** | Real alternatives; one clearly better; reversible if wrong | Recommend strongly; user can object. Does not block. |
| **Hard fork** | **Hard fork** | Missing product intent; hard to undo; or near-parity tradeoff | **Block** until answered. |

**Hard fork signals:** user-visible semantics, irreversibility, genuine tradeoff, missing constraint, request vs codebase conflict.

**Assumed signals:** framing decided it, boring stack answer (tenet 5), dominant convention (tenet 6), implied preference ("minimal diff"), easy-to-move internal boundary.

Collect several hard forks in a **Hard forks** subsection; if none, say once (e.g. _"No hard forks—all follow from framing or conventions."_).

In the persisted plan file, record only **settled** choices—no tier labels.

### Gate A — Framing (opt-in)

Skip only when scope, constraints, and success are all clear. "Implement X" usually isn't—prefer running A.

Present: goal (one sentence), constraints, non-goals, success criteria, open questions. Confirm: _"Is this the right framing?"_

### Gate B — Architecture (required)

Explore the repo first (tenets 5, 6): helpers, conventions, ownership (`CODEOWNERS` or equivalent). Findings feed **Investigation** at Plan.

Numbered **decision list**—one load-bearing choice per item (transport, data source, boundary, trigger, …), dependency order. Per item: **Options**, **Recommend** + why, **Tier**. Open questions that could change a decision. No increments yet.

For each concern, name its canonical owner and entry point. Treat multiple execution paths for equivalent behavior as an architectural fork: justify them with a stable rule that tells teammates where to look, or prefer one path. Local convenience alone does not justify splitting behavior across client, server, database functions, or vendor services.

### Gate C — Design (required)

B: what and where. C: what shape—abstractions, seams, contracts (interface shape, error model, sync vs async, hard-coded vs pluggable). Same list shape as B. Per item, note **existing code touched** when a decision reshapes or extracts; reshapes feed D's ordering.

### Confirm (B and C)

- **Hard forks:** _"Need your call on [list] before the plan."_ Wait.
- **None:** objection window—B: _"Proceeding with these architectural decisions unless you object—any changes?"_ C: _"Proceeding with this design shape unless you object—ready to approve the plan?"_ Continue on silence or assent; user can correct Assumed or Soft items.

**Batch:** No hard forks in either gate → present B then C in one message, single objection window at the end, then **Plan**.

### Plan approval (required)

Commit to **what** you're building—not **how** it ships in PRs. Assemble from settled A–C ([plan-template.md](plan-template.md) through **Open questions**; omit **Status**, **Increments**, **Plan drift**).

| Section | Content |
|---------|---------|
| Goal | From framing |
| Architectural / design decisions | Settled B and C |
| Approach | One obvious path |
| Boundaries | Modules/layers; seams |
| **Contracts** | New/changed boundaries: caller → callee, input/output, invariants (pseudocode OK) |
| **Investigation** | Anchor files, patterns to follow, gotchas from exploration |
| Diagram | See below |
| Tradeoffs & risks | Design/architecture—not PR sequencing |
| Open questions | Tag **blocking** or **defer** |

**Diagram** (required unless trivial single-boundary work): one [mermaid](https://mermaid.js.org/) `flowchart` in a fenced block (no images). Module **boundaries** and main **flow** (label contracts when helpful). ~3–6 boxes per layer. **No PR labels.**

Confirm: _"Approve this plan? Ready to sequence increments?"_

### Gate D — Increments (required)

Turn the approved plan into an ordered PR stack—build bottom-up. Present **Increments** and increment-level tradeoffs only (append when persisting). Unsettled forks belong at B/C/P.

**One increment = one PR** in merge order—never group or split across increments. Sequence like [split-commit](../split-commit/SKILL.md): each PR is one review story; bottom introduces what later ones need; mechanical churn separate from behavior.

**Two axes** (both must hold):

1. **Build order** — types, modules, contracts before callers. Write-order, not a feature checklist or directory split.
2. **Diff hygiene** — one change kind per PR. Peel rename/move before behavior; extract before wire; introduce shim before remove. Never refactor + new behavior together.

**Each increment:** Title, **Story**, **Edits**, **Depends on** (none or PR + reason), **Acceptance** (2–4 observable checkboxes), **Bridge** when needed. **Touch set** required when touching existing code (`path` → role); optional for greenfield-only. Interleaved rename + behavior → whole file to dominant PR.

**Before approval:** _Authorship_ — next PR writable after merge? _Coverage_ — every C reshape has a home; no vague tail. _Granularity_ — split when review is muddy. _Existing stack_ — branch for open PR vs new bottom (see split-commit).

### Implementability (before persisting)

Fix before writing files:

- No `TBD` / `figure out` in plan content
- Every increment has **Acceptance**; every C "touches" item appears in a touch set
- **Contracts** cover every new/changed boundary
- Open questions tagged; nothing blocking left unnamed

Confirm: _"Approve this increment stack?"_

## After approval

### Persist (default for 2+ PRs)

**Default:** write `docs/plans/{slug}/plan.md` and `docs/plans/{slug}/scratch.md` after D unless the user opts out (chat-only, same-session single-PR).

1. Confirm path or accept default `{slug}` from goal (kebab-case)
2. Copy [plan-template.md](plan-template.md) → `plan.md`; set **Approved**, **Status** from increments, full P + D content
3. Copy [scratch-template.md](scratch-template.md) → `scratch.md`; set **PR** to 1 of N, not started
4. Tell user both paths for `@`-mention

**Chat-only OK when:** single PR, same session, user declines persist.

### Hand off

Implementation may begin after D. Entry point: `@` `plan.md` (and `scratch.md` when persisted).

### Resuming implementation

1. Read `plan.md` — Goal, Contracts, Investigation, then **current** increment block
2. Read `scratch.md` — Current, Stack
3. `git status` / `gt ls` (or equivalent)
4. Implement **one PR** at a time; update **scratch** when starting/finishing; check **Status** in plan when a PR merges
5. **Plan drift** only when the approved plan itself changes—not for routine progress

## Examples

See [examples.md](examples.md).
