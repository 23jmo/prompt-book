# Prompt Book

A Claude Code skill for building your personal library of effective prompts. Save prompts that work, find them later, track what's useful.

## Install

**One-liner:**

```bash
curl -fsSL https://raw.githubusercontent.com/23jmo/prompt-book/main/install.sh | bash
```

**Or with git:**

```bash
git clone https://github.com/23jmo/prompt-book.git ~/.claude/skills/prompt-book
```

The `/prompt-book` command is now available in Claude Code.

## Commands

| Command | Description |
|---------|-------------|
| `/prompt-book save` | Save a new prompt |
| `/prompt-book find <query>` | Search by keyword |
| `/prompt-book list` | Browse all prompts |
| `/prompt-book use <id>` | Retrieve a prompt |
| `/prompt-book feedback <id>` | Rate a prompt |
| `/prompt-book delete <id>` | Remove a prompt |
| `/prompt-book watch <start\|stop\|status>` | Auto-capture mode |
| `/prompt-book export [file]` | Export library to JSON |
| `/prompt-book import <file>` | Import from JSON |

## Quick Example

```
> /prompt-book save
What prompt would you like to save?
> Review this code for security vulnerabilities, focusing on injection attacks and auth issues.
Title?
> Security Code Review
Category?
> coding

Saved prompt 'Security Code Review' with ID: 20260203-k7xm
```

Find it later:

```
> /prompt-book find security

ID            | Title                 | Category | Rating
--------------|-----------------------|----------|-------
20260203-k7xm | Security Code Review  | coding   | 0
```

## Auto-Capture Mode

Enable reminders to save effective prompts at session end:

```
/prompt-book watch start    # Enable
/prompt-book watch stop     # Disable
/prompt-book watch status   # Check current state
```

## Export & Import

Share prompts or back them up:

```
/prompt-book export                     # Export to default file
/prompt-book export ~/my-prompts.json   # Export to specific file
/prompt-book import ~/shared-prompts.json
```

## Storage

Prompts are markdown files in `data/prompts/`:

```
~/.claude/skills/prompt-book/
├── SKILL.md
├── README.md
└── data/
    └── prompts/
        ├── 20260203-k7xm.md
        └── ...
```

## Sync Across Machines

Your prompts are just files. Sync however you like:

```bash
# Push updates
cd ~/.claude/skills/prompt-book
git add data/prompts && git commit -m "Update prompts" && git push

# Pull on another machine
git pull
```

Or symlink to Dropbox/iCloud:

```bash
ln -s ~/Dropbox/prompts ~/.claude/skills/prompt-book/data/prompts
```

## Uninstall

```bash
rm -rf ~/.claude/skills/prompt-book
```

## License

MIT
