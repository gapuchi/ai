# AI Agents

Cross-repo agent instructions. Per-repo architecture and domain rules belong in that repo's `AGENTS.md` — not here.

## Set Up

### Cursor

```zsh
ln -sfn "$(pwd)/agents" "$HOME/.cursor/rules"
ln -sfn "$(pwd)/skills" "$HOME/.cursor/skills"
```

### Claude Code

```zsh
ln -sfn "$(pwd)/agents/coding-philosphy.mdc" "$HOME/.claude/CLAUDE.md"
ln -sfn "$(pwd)/skills" "$HOME/.claude/skills"
```

## What lives where

| Topic | Location |
|-------|----------|
| Coding philosophy and boundaries | `agents/coding-philosphy.mdc` |
| Planning workflow (gates, `plan.md`, PR stack) | `skills/scope-and-plan` |
| Splitting an oversized commit into a Graphite stack | `skills/split-commit` |
| **Bootstrapping repo agent docs** | `skills/setup-agent-docs` |
| Repo architecture, domain model, where to edit | Each repo's `AGENTS.md` + `.cursor/rules/` |
| User-facing behavior | Each repo's `README.md` |

## Skills

| Skill | Use when |
|-------|----------|
| `scope-and-plan` | Large or ambiguous work — plan and sequence PRs before code |
| `split-commit` | One commit is too big — split into a reviewable Graphite stack |
| `setup-agent-docs` | Create or audit `AGENTS.md` and `.cursor/rules/` for a repo |

## Cursor User Rules (UI)

**Keep in Cursor Settings → Rules:** git commit protocol, PR workflow (`gh`), communication style, "run commands yourself", conversation-history context.

**Do not duplicate here or in User Rules** (already in `agents/coding-philosphy.mdc`):

- Minimize scope / small diffs
- Avoid over-engineering / YAGNI
- Match repo conventions
- One idea per unit / useful tests only
- Comment and abstraction guidance

If those appear in both User Rules and `coding-philosphy.mdc`, remove them from User Rules.

## New repo checklist

1. Run **`setup-agent-docs`** — explore, draft `AGENTS.md`, add `.cursor/rules/`
2. Symlink this repo to `~/.cursor/rules` and `~/.cursor/skills` if not already done
3. Keep `coding-philosphy.mdc` as the only cross-repo coding standard
