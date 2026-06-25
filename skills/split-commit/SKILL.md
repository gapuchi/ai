---
name: split-commit
description: Split a single oversized commit into two or more smaller commits on a Graphite stack locally. Boundaries are usually logical code chunks (e.g. introduce a type before its callers) or diff-shaping (e.g. isolate a rename from behavioral edits). Proposes how to split into commits and waits for confirmation unless the user already described the split. Stops before submit. Use when the current commit is too large or hard to review.
---

# Split a single commit

**Trigger:** The user notices **one commit** is too big, too hard to review, or combines unrelated changes. The outcome is **several smaller commits**, each on its **own stacked branch** (bottom merges first), using normal git staging plus `gt create` to keep Graphite metadata consistent.

**A commit may be split into more than 2** when the diff clearly has more than two coherent chunks—do not force a binary split.

**How a commit is usually split:**

- **Diff hygiene** — Separate changes that obscure each other in review. Classic case: **one commit for a pure rename** (or other mechanical churn), **another for behavior**. Same idea for "extract helper" vs "change logic that uses it."
- **Coherent logical chunks** - A commit may have multiple conceptual/behavior changes. We should split the commit so that each one covers a single change. The first (or bottom) commit should introduce concepts/classes/etc that the following commits would need to use. Follow how the code *could* have been written step by step.

**Success Criteria:** Commits are present locally, stacked, and are consistent with Graphite (via `gt ls`). **Do not run `gt submit`, push for review, or open/update PRs.** Hand off for user review.

---

## Plan

**Do not run destructive git commands or `gt create` until the split plan is agreed.**

### Reconnaissance

1. `git log -1` / `git show HEAD` — confirm **which commit** is being split (usually `HEAD`; if not, agree with the user which revision).
2. `gt ls` or `gt log` — note parent branch and any children; splitting reshapes this stack.
3. **Save the original SHA** before any destructive operation: `ORIG_SHA=$(git rev-parse HEAD)`. You will need it to reconstruct file states and to verify the final tree.

### Propose boundaries

1. **If the user suggested boundaries** — They describe **logical commits** ("add `Foo` first, then update `Bar` to use it") or **diff goals** ("rename only in the bottom commit, behavior on top"). Translate that into concrete hunks when executing; line numbers are optional shorthand for "this part of the change," not the default way to define boundaries. If ambiguous, ask once or propose a mapping and ask yes/no.

2. **If the user did not suggest boundaries** — Inspect `git show HEAD` (or the chosen commit). Propose a **numbered stack bottom → top** (1 lands first): each commit's **story** (what reviewers should see first), what kinds of edits belong there (including isolating renames / mechanical churn from behavior), and suggested branch names. **Wait for explicit confirmation** (or edits) before executing.

3. **After confirmation** — Execute; if the working tree shows the plan was wrong, stop and re-propose.

### Branch naming and existing PRs

GitHub ties review threads to branch names. If a PR already exists on `feature-x` and you peel out a refactor:

- Put the refactor on a **new** bottom branch name.
- Keep the **original** name on the branch that should stay attached to the existing PR (see [Graphite: squash, fold, split](https://graphite.dev/docs/squash-fold-split)).

Factor this into the plan before executing.

---

## Execute

### 1. Classify files

After reading the full diff but **before any `git reset`**, categorize every changed file into one of two operational categories. The question to ask for each file is: **can I move this file with a whole-file `git checkout`, or does it need a hand-crafted intermediate state?**

| Category | Description | Staging strategy | Example |
|----------|-------------|------------------|---------|
| **Commit-only** | The file's entire diff belongs to one commit. | `git checkout HEAD -- path` to exclude from the current commit, or `git checkout $ORIG_SHA -- path` to include. No manual editing. | A new file, a file with only rename changes, or a file with interleaved concerns where one concern dominates (see below). |
| **Bridge** | The file must exist in an intermediate state between commits — a state that doesn't appear in either the parent or the original commit. | Hand-edit to craft the intermediate content for the earlier commit; typically `git checkout $ORIG_SHA -- path` in a later commit to reach the final state. | A module that introduces a new name in the bottom commit but must keep the old name as a compatibility alias until the next commit removes it. |

#### Resolving files with interleaved concerns

When two concerns (e.g. rename + behavior) are interleaved in the same file, don't attempt hunk-level splits. Instead, assign the **whole file** to whichever commit owns the dominant concern — it becomes commit-only for that commit:

- If a file needs a new API/enum/import for behavioral reasons, it naturally imports the new name. Include the full file in the behavioral commit — the "rename" of the type annotation is a side effect of needing the import, not a separate concern.
- Only files whose **entire diff** is the mechanical change (e.g. every hunk is just `TFoo → Foo` in type positions) belong in the rename commit.

#### Bridge files and intermediate compatibility

When splitting a rename/removal from behavioral changes, the bottom commit often needs a **compatibility alias** so that consumers not yet renamed continue to compile:

```typescript
// Bottom commit: introduce new name, keep old as alias
export enum Stage { Stg = "stg", Prod = "prod" }
export type TStage = Stage; // removed in next commit
```

The top commit removes the alias and renames all remaining consumers. This pattern applies to types, re-exports, function names, etc.

### 2. Reset

```bash
ORIG_SHA=$(git rev-parse HEAD)
git reset --soft HEAD~1
git reset
```

The commit's changes are now unstaged in the working tree. HEAD points to the parent. *(If splitting a non-tip commit, agree on an approach first—e.g. interactive rebase to edit that commit—is outside the default happy path.)*

### 3. Build each commit (same recipe, repeat bottom → top)

For **every** new commit, drive the working tree to **only** this commit's intended diff against current `HEAD`, then checkpoint. The number of commits can be two, three, or more—the steps do not change.

**A. Paths that must not appear in this commit** (commit-only for a **later** commit): make them match parent so they vanish from the pending diff:

```bash
git checkout HEAD -- path/to/file1 path/to/file2 ...
```

**B. Bridge files** — set each bridge path to **this commit's** required end state (often hand-edit for an early commit, e.g. compatibility alias; often `git checkout $ORIG_SHA -- path` when this commit should match the blob from the pre-split commit).

**C. Paths owned by this commit** (commit-only here) — leave as-is if the tree already matches the intended state; otherwise bring paths in line the same way as (B), including `git checkout $ORIG_SHA -- path/to/file` when the correct content is exactly what's in the original commit.

`git checkout <sha> -- <path>` writes the file **and** stages it in one step when you use a concrete revision.

Then stage anything not yet staged and checkpoint:

```bash
git add -A
```

- **Bottom commit:** `git commit -m "..."`
- **Each commit above:** `gt create <branch-name> -m "..."`

This is far more efficient than `git add -p` across many files. Reserve `git add -p` for the rare case where a single file has hunks that truly must be split between commits and neither "own the whole file" nor "restore to parent" / `ORIG_SHA` checkout applies.

### 4. Verify

Confirm the **combined** result matches the original commit—no changes lost, no extra changes introduced:

```bash
git diff $ORIG_SHA HEAD  # must be empty
```

That single check is the guardrail for every commit in the split: bridge files eventually reach their final state, rename-only paths match `ORIG_SHA`, and nothing was dropped when restoring paths with `git checkout HEAD --` between steps.

Also check `gt ls` looks correct and working tree is clean (`git status`).

Repair Graphite metadata if needed: `gt track -p <parent-branch>` on a mis-parented branch, then `gt restack`.

---

## Checklist

- [ ] Target commit identified (usually `HEAD`); original SHA saved
- [ ] Split plan agreed (user input **or** proposal + confirmation)
- [ ] Branch naming accounts for existing PRs
- [ ] Commit count fits the diff (≥2; more when clearer); boundaries are logical / review-driven, not "split by directory" by default
- [ ] Files classified: commit-only (whole-file `git checkout`) or bridge (hand-crafted intermediate state); interleaved files resolved by assigning to dominant commit
- [ ] Each new commit built with the same recipe: exclude later work (`git checkout HEAD -- …`), set bridge + owned paths for this commit (edit and/or `git checkout $ORIG_SHA -- …`), `git add -A`, then `git commit` (bottom) or `gt create` (above)
- [ ] `git diff $ORIG_SHA HEAD` is empty (final tree matches original exactly; catches wrong bridge / rename / restore mistakes across the whole split)
- [ ] `gt ls` looks right; working tree clean; optional tests/lint; `gt restack` if Graphite says so
- [ ] No `gt submit`; user owns push/review/submit
