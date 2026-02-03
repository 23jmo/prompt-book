# Prompt Book

A Claude Code skill for managing a personal library of effective prompts.

## Installation

This skill is installed at `~/.claude/skills/prompt-book/`. It should be automatically available in Claude Code.

## Commands

| Command | Description |
|---------|-------------|
| `/prompt-book save` | Save a new prompt to your library |
| `/prompt-book find <query>` | Search prompts by keyword |
| `/prompt-book list` | List all saved prompts |
| `/prompt-book use <id>` | Retrieve and display a prompt |
| `/prompt-book feedback <id>` | Rate a prompt and add notes |
| `/prompt-book delete <id>` | Remove a prompt |

### Examples

```
/prompt-book save
/prompt-book find "code review"
/prompt-book list
/prompt-book list --category coding
/prompt-book list --tag debugging
/prompt-book use 20260202-k7xm
/prompt-book feedback 20260202-k7xm
/prompt-book delete 20260202-k7xm
```

## Storage

Prompts are stored as markdown files in `~/.claude/skills/prompt-book/data/prompts/`.

Each file uses YAML frontmatter for metadata:

```markdown
---
id: 20260202-k7xm
title: "Code Review Request"
category: coding
tags: [review, quality]
rating: 0
usage_count: 0
created: 2026-02-02
last_used: 2026-02-02
---

## Prompt

[Your prompt text here]

## Context

[When to use this prompt]

## Feedback

[Rating history added here]
```

## Backup & Sync

The `data/` directory is initialized as a git repository. To sync across machines:

```bash
cd ~/.claude/skills/prompt-book/data
git remote add origin <your-repo-url>
git push -u origin main
```

## File Structure

```
~/.claude/skills/prompt-book/
├── SKILL.md          # Skill definition
├── README.md         # This file
└── data/
    └── prompts/      # Your saved prompts
        ├── 20260202-k7xm.md
        └── ...
```

## Roadmap

- **Phase 2:** Usage tracking, feedback command, ratings
- **Phase 3:** Optional auto-capture with hooks
- **Phase 4:** Export/import, sharing
