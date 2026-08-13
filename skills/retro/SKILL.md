---
name: retro
description: Review the current conversation to evaluate how each invoked skill and agent instruction performed, distinguish execution mistakes from instruction gaps, and propose durable improvements for user approval. Use when the user asks for a retro, retrospective, self-evaluation, or improvements to skills or agents based on the session.
disable-model-invocation: true
---

# Conversation Retrospective

Evaluate the current session and identify durable improvements to the skills and agent instructions that materially shaped it.

## Hard rules

- Review only skills and agent instructions that were actually invoked or materially applied.
- Evaluate each artifact against its stated purpose and scope, not against every outcome in the conversation.
- Treat explicit user feedback and corrections as the strongest evidence, but do not generalize a one-off preference without a reusable lesson.
- Separate instruction defects from execution mistakes, missing context, tool failures, and reasonable tradeoffs.
- Do not optimize an artifact for this conversation at the expense of its broader use cases.
- Evaluate whether the session exposed a missing skill or agent instruction, without creating artifacts for one-off needs.
- Propose changes before editing anything. Apply only the changes the user approves.
- Preserve exact user-authored wording when the user requests it.

## Workflow

### 1. Reconstruct the evidence

Review the conversation, tool activity, user corrections, final outcomes, and any relevant files.

Inventory:

- Skills read or invoked
- Agent rules or instruction files that materially governed the work
- Subagents used, including their type, assignment, and returned result
- Important user feedback, corrections, rejected approaches, and repeated friction
- Outcomes that were notably effective

Do not count an artifact merely because it was available in context. If invocation or influence is uncertain, say so.

### 2. Grade each artifact

Use this scale:

- **A — Strong:** Fulfilled its purpose cleanly; no meaningful change indicated
- **B — Useful:** Helped, with a small or localized weakness
- **C — Mixed:** Materially helped and hindered; instructions need revision
- **D — Weak:** Mostly failed its purpose or caused avoidable rework
- **N/A — Insufficient evidence:** Invoked, but the session did not test it enough to grade

For each artifact, report:

1. **Intended scope** — one sentence based on its own description
2. **Evidence** — concrete session behavior or user feedback
3. **Grade** — with a brief justification
4. **Diagnosis** — one of:
   - Instruction gap
   - Execution mistake
   - Missing context
   - Tool or environment limitation
   - Reasonable tradeoff
5. **Recommendation** — keep as-is or describe the smallest durable improvement

Grade subagents on whether their assignment was appropriate and whether their result was accurate, useful, scoped, and integrated well. Do not blame a subagent for work outside its prompt.

### 3. Decide whether a change is warranted

Recommend an instruction change only when:

- The issue is likely to recur across conversations
- The target artifact is the canonical place for the behavior
- Better agent execution alone would not solve it
- The proposed wording is specific enough to change future behavior
- The change does not conflict with the artifact's existing scope

Prefer no change when evidence is weak. Do not add broad rules for isolated mistakes, duplicate guidance already owned elsewhere, or encode conversation-specific names, files, or examples unless they represent a stable pattern.

### 4. Evaluate missing artifacts

Decide whether the session would be better served by a new skill or agent instruction rather than a change to an existing artifact.

Recommend a **new skill** only when:

- A distinct, repeatable workflow emerged
- It requires procedural or domain guidance beyond normal agent competence
- Existing skills do not have a natural scope for it
- Its trigger, inputs, workflow, and expected output can be stated clearly

Recommend a **new agent instruction** only when:

- The lesson should govern behavior across many tasks rather than one workflow
- It expresses a stable engineering principle, environment constraint, or repository convention
- No existing agent instruction canonically owns the concern

Prefer extending an existing artifact when the behavior fits its stated scope. Prefer no artifact when the need is isolated, speculative, better solved through normal execution, or already covered elsewhere.

For each proposed new artifact, provide:

- **Type and name**
- **Trigger and scope**
- **Evidence from the session**
- **Why an existing artifact is insufficient**
- **Proposed location**
- **Outline of its instructions**

Creation remains approval-gated; do not create the artifact during the initial retrospective.

### 5. Present the retrospective

Use this structure:

```markdown
## Retro summary
[Two or three sentences on the overall outcome and the most important lesson.]

## Evaluations
### [Artifact name] — [Grade]
- Intended scope:
- Evidence:
- Diagnosis:
- Recommendation:

## Proposed changes
### [Artifact path]
- Why:
- Proposed edit:

## Proposed new artifacts
### [Skill or agent instruction name]
- Type and location:
- Trigger and scope:
- Evidence:
- Why existing guidance is insufficient:
- Instruction outline:

## No-change decisions
- [Artifact]: [Why no edit is warranted]
```

Omit **Proposed changes** or **Proposed new artifacts** when none are justified. Be candid and evidence-based; do not inflate grades or manufacture criticism to make the retro appear useful.

### 6. Request approval

For every proposed edit or new artifact, identify the exact target file and summarize the wording or show a compact draft. Group independent items so the user can approve or reject them separately.

End with one focused approval question. Do not edit files in the same turn as the initial retrospective unless the user explicitly asked to bypass review.

### 7. Apply approved changes

After approval:

1. Re-read each target file.
2. Make only the approved edits.
3. Check for contradictions, duplicated ownership, malformed frontmatter, and broken references.
4. Summarize what changed and note any approved change that could not be applied.

Do not recursively run another retrospective unless the user asks.