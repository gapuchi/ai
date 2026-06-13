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
| Coding philosophy, boundaries, planning workflow | `agents/coding-philosophy.mdc` + `skills/scope-and-plan`, `execute-increment` |
| **Bootstrapping repo agent docs** | `skills/setup-agent-docs` |
| Repo architecture, domain model, where to edit | Each repo's `AGENTS.md` + `.cursor/rules/` |
| User-facing behavior | Each repo's `README.md` |

## Skills

| Skill | Use when |
|-------|----------|
| `scope-and-plan` | Large or ambiguous work — plan before code |
| `execute-increment` | Implement an approved plan one slice at a time |
| `setup-agent-docs` | Create or audit `AGENTS.md` and `.cursor/rules/` for a repo |
| `researcher` | External research during planning |

## Cursor User Rules (UI)

**Keep in Cursor Settings → Rules:** git commit protocol, PR workflow (`gh`), communication style, "run commands yourself", conversation-history context.

**Do not duplicate here or in User Rules** (already in `coding-philosophy.mdc`):

- Minimize scope / small diffs
- Avoid over-engineering / YAGNI
- Match repo conventions
- One idea per unit / useful tests only
- Comment and abstraction guidance

If those appear in both User Rules and `coding-philosophy.mdc`, remove them from User Rules.

## New repo checklist

1. Run **`setup-agent-docs`** — explore, draft `AGENTS.md`, add `.cursor/rules/`
2. Symlink this repo to `~/.cursor/rules` and `~/.cursor/skills` if not already done
3. Keep `coding-philosophy` as the only cross-repo coding standard
