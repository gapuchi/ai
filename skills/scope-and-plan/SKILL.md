---
name: scope-and-plan
description: >-
  Explore and plan multi-file features, refactors, migrations, and ambiguous
  work before coding. Produces an approval-gated plan for execute-increment.
  Use when starting large changes, refactors, migrations, API redesigns, or
  when requirements or approach are unclear.
---

# Scope and Plan

Follow `@agents/coding-philosphy.mdc` for all design decisions. This skill adds workflow and gates—it does not override the philosophy.

**Hard rule:** Do not write or edit code until the user approves the final plan (Gate D).

## When to use

- Multi-file features, refactors, migrations, API or boundary changes
- Ambiguous requirements or multiple valid approaches
- User says "plan", "design", "how should we", or describes work too large for a one-line intent

For obvious single-file fixes, state one-line intent and proceed—no full plan needed (philosophy tenet 7).

For external research or option comparison, read and follow [researcher](../researcher/SKILL.md) during Gate B or C.

## Workflow

One subject, examined top-down. Each gate drops exactly one layer below the last and is settled before you descend, because each layer constrains the one beneath it. Don't skip a layer or jump ahead to detail.

```
- [ ] A. Framing — opt-in      (top: goal, scope, success — what problem)
- [ ] B. Architecture — required   (one below: components, boundaries, transport — what & where)
- [ ] C. Design — required         (one below: abstractions, seams, contracts — what shape)
- [ ] D. Increments — required     (bottom: ordered, refactor-first PR breakdown — how to build)
```

Stop after each gate and wait for confirmation. On disagreement, redo that gate only; don't reopen earlier ones unless the upstream answer changed.

### Gate A — Framing (opt-in)

Skip only when scope, constraints, and success criteria are all clear from the request. "Implement X" requests usually hide scope—prefer running A.

Present: goal (one sentence), constraints, non-goals, success criteria, open questions.

Confirm: _"Is this the right framing?"_

### Gate B — Architecture (required)

Explore the repo first (tenets 5, 6): existing helpers, dominant local conventions, ownership (`CODEOWNERS` or repo equivalent).

Present a **numbered decision list**, one item per load-bearing choice (e.g. transport, data source, system boundary, trigger model). Order by dependency: if decision X constrains decision Y's options, put X first.

For each decision:

- **Options** considered
- **Recommend** + one-line why

**Forks** — only surface decisions that still need the user's call. Mark those items with **Fork** (or collect them in a short **Forks** subsection at the end). Do **not** append "Fork? yes/no" to every line; settled choices from framing or an earlier gate get a recommendation only, with no fork label. If nothing is open, say so once (e.g. "No forks—all recommendations follow from framing").

Include open questions that could change a decision. Do **not** include file paths or increments yet.

Confirm: _"Are these the right architectural decisions? Any forks to discuss?"_

### Gate C — Design (required)

B decided _what the moving parts are and where the boundaries go_. C decides _what shape the code takes_: which abstractions exist, what's generalized vs. left concrete, where the seams sit, and the contracts callers depend on. Too detailed for B, but they determine what the increments are—so they come before D. Making a flow provider-agnostic so multiple backends plug in is one example; so is any choice about interface shape, error/data model, sync vs. async, or what stays hard-coded.

Present a **numbered design-decision list**, same shape as Gate B (options + recommend; **Fork** only where the user must choose):

- **Existing code touched** — what a decision reshapes or extracts, if any (feeds D's ordering)

Skip a decision only when the shape is obvious from B. When a decision reshapes existing code, flag that refactor here so D can sequence it first.

Confirm: _"Is this the right design shape? Any forks to discuss?"_

### Gate D — Increments (required)

Now resolve detail. Present the full [plan-template.md](plan-template.md) content in chat; omit **Status** and **Plan drift** (file only).

- One obvious path per implementation choice—pick, don't fork (forks belong at Gate B/C)
- **Diagram** — mermaid visualization of boundaries, flow, and which PR touches what (see below)
- Boundaries (modules/layers and contracts—not a file list)
- Tradeoffs and risks

This is the bottom layer: turn the settled design into an ordered build sequence. Planning descended top-down; the build runs bottom-up.

**One increment = one PR.** The increments list is the PR stack: item _N_ is PR _N_, in merge order. Do not group multiple PRs into one increment or split one PR across increments. Name each item so it reads as a PR title/summary.

Sequence rules:

1. **One logical unit per PR** — each increment is independently shippable and reviewable; don't bundle unrelated work.
2. **Bottom-up** — dependencies first, then their callers. The list should read as build order, not a feature checklist.
3. **Refactor before feature** — split pure, behavior-preserving refactors into their own PR (and increment) before PRs that add behavior. Never mix refactor + new behavior in one PR.

Do **not** include a separate file list—the increments and boundaries sections carry enough scope; file paths belong in implementation, not the plan.

### Diagram (required at Gate D)

Include a **## Diagram** section in the plan (after **Boundaries**, before **Increments**). Use a single [mermaid](https://mermaid.js.org/) diagram in a fenced `mermaid` code block—no image files.

The diagram should make three things obvious at a glance:

1. **Boundaries** — subgraphs or boxes per layer/module (not per file); stable seams between caller and callee.
2. **Flow** — main read/write or request path for the feature (arrows labeled with the contract when it helps, e.g. `headCommitSha`, cereal route).
3. **PR scope** — which PR changes which box. Prefer `PR 1` / `PR 2` labels on subgraphs, nodes, or edges; use dashed vs solid or a short legend only if needed.

Keep it small enough to read in one screen (~3–6 boxes per layer). Skip only for trivial single-PR, single-boundary work.

**Shapes that work well:**

- `flowchart TB` with `subgraph` per boundary
- Label new work vs unchanged with node text (`(existing)`, `(new in PR 2)`) or edge notes—not a separate inventory

Do **not** duplicate the increments list in prose inside the diagram; the diagram complements **Boundaries** and **Increments**, not replaces them.

Confirm: _"Approve this plan? Where should I persist it (if anywhere)?"_

## After approval

The approved Gate D content in chat is valid on its own. **Do not** write a plan file unless the user asks to persist it and says where.

### Persisting the plan (optional)

**When to offer:** plan has 2+ PRs, may span sessions, or the user wants a durable artifact. Skip for single-PR work done in the same chat unless they ask.

**Ask** where to save it—for example:

- Chat only (no file; fine for same-session, single-PR work)
- A path in the repo (e.g. `docs/plans/`, `internal-docs/`, next to the feature)
- Somewhere else the user names (Notion, ticket, wiki)

**If they want a file:**

1. Use the path they give; suggest a kebab-case filename from the goal (e.g. `origin-pr-mark-as-viewed.md`) only as a suggestion
2. Copy [plan-template.md](plan-template.md); set **Approved** date; include **Status** and **Plan drift** sections
3. Fill all sections from the approved Gate D (decisions, diagram, increments, etc.)
4. Write only after they confirm the path

Tell them the final path so they can `@`-mention it for **execute-increment**.

### Hand off

Point to **execute-increment**. Remind them how to load the plan: `@` the saved file, paste the path, or continue in chat if no file was written.

## Examples

See [examples.md](examples.md).
