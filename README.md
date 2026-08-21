# AI Agents

Cross-repo agent instructions. Per-repo architecture and domain rules belong in that repo's `AGENTS.md` — not here.

## Set Up

Cursor only:

```zsh
./scripts/link-agent-docs.sh
```

Cursor and Claude Code:

```zsh
./scripts/link-agent-docs.sh --claude
```

The script is idempotent and refuses to replace an existing non-symlink, so an
earlier hand-rolled `~/.cursor/rules` directory must be moved aside first.

## Cloud agents

Cloud agents boot a fresh VM and never see the symlinks above. They load rules
and skills from the repos in their environment, from Cursor Settings, and from
team dashboard content — not from your laptop's home directory.

To share this repo instead of copying it into every project:

1. Open the project's environment in the [Cloud Agents dashboard](https://cursor.com/dashboard/cloud-agents#environments)
   and add this repo alongside the product repo. Cursor clones both onto the agent machine.
2. Set the environment's install command to run the linker against the clone:

   ```zsh
   bash <path-to-this-clone>/scripts/link-agent-docs.sh
   ```

   Check the clone path once from a cloud agent (`ls ..` from the product repo) —
   `install` runs from the primary repo's root.

Skills then load from `~/.cursor/skills` for every agent in that environment,
and updates land by merging here instead of editing each repo.

## What lives where

| Topic | Location |
|-------|----------|
| Coding philosophy and boundaries | `agents/coding-philosophy.mdc` |
| Development environment and Nix preferences | `agents/development-environment.mdc` |
| Planning workflow (gates, `plan.md`, PR stack) | `skills/scope-and-plan` |
| Splitting an oversized commit into a Graphite stack | `skills/split-commit` |
| **Bootstrapping repo agent docs** | `skills/setup-agent-docs` |
| Repo procedures | `.cursor/skills/` in each repo |
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

**Do not duplicate here or in User Rules** (already in `agents/coding-philosophy.mdc`):

- Minimize scope / small diffs
- Avoid over-engineering / YAGNI
- Match repo conventions
- One idea per unit / useful tests only
- Comment and abstraction guidance

If those appear in both User Rules and `coding-philosophy.mdc`, remove them from User Rules.

## New repo checklist

1. Run **`setup-agent-docs`** — explore, draft `AGENTS.md`, add `.cursor/rules/`
2. Run `scripts/link-agent-docs.sh` if this repo is not linked yet
3. Add this repo to the project's cloud agent environment (see [Cloud agents](#cloud-agents))
4. Keep `coding-philosophy.mdc` as the only cross-repo coding standard
