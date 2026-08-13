---
name: wdym
description: Ruthlessly simplifies the agent's previous answer without changing its meaning. Use when the user says "wdym", "what do you mean", or asks for a simpler explanation.
disable-model-invocation: true
---

# What Do You Mean?

Rewrite the previous answer so the user can understand it immediately.

## Instructions

1. Identify the one point the previous answer was trying to convey.
2. State that point first in plain, concrete language.
3. Keep only details necessary to understand or act on it.
4. Replace jargon with everyday words. If a technical term is essential, define it in the same sentence.
5. Break apart dense sentences and implicit reasoning.
6. Preserve important qualifications, uncertainty, warnings, and constraints.
7. Do not add new claims, research, recommendations, or tangents.
8. Do not defend, summarize, or comment on the previous wording. Just provide the clearer answer.

## Default output

- Use 1–3 short sentences.
- Add bullets only when there are multiple distinct points or steps.
- Prefer a concrete example when abstraction is the source of confusion.
- Ask one focused question only if the unclear part cannot be inferred from context.

## Quality check

Before responding, verify:

- The meaning is unchanged.
- The main point appears in the first sentence.
- Every remaining detail earns its place.
- A reader unfamiliar with the topic can follow it.