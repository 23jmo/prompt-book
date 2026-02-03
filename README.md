# Prompt Book

A Claude Code skill for building your personal library of effective prompts. Save prompts that work, find them later, track what's useful.

## Install

Clone into your Claude Code skills directory:

```bash
git clone https://github.com/23jmo/prompt-book.git ~/.claude/skills/prompt-book
```

That's it. The `/prompt-book` command is now available in Claude Code.

## Usage

```
/prompt-book save              # Save a new prompt
/prompt-book find <query>      # Search by keyword
/prompt-book list              # Browse all prompts
/prompt-book use <id>          # Retrieve a prompt
/prompt-book feedback <id>     # Rate a prompt
/prompt-book delete <id>       # Remove a prompt
```

### Quick Example

```
> /prompt-book save
What prompt would you like to save?
> Review this code for security vulnerabilities, focusing on injection attacks and auth issues.
Title?
> Security Code Review
Category?
> coding
Tags?
> security, review

Saved prompt 'Security Code Review' with ID: 20260203-k7xm
```

Later:

```
> /prompt-book find security
Found 1 prompt matching "security":

ID            | Title                 | Category | Rating
--------------|-----------------------|----------|-------
20260203-k7xm | Security Code Review  | coding   | 0
```

## Storage

Prompts are stored as markdown files in `data/prompts/`. Each prompt has:

- **Title** and **category** for organization
- **Tags** for searchability
- **Rating** based on your feedback
- **Usage count** to see what you actually use

## Sync Across Machines

Your prompts are just files. Sync them however you like:

```bash
# Option 1: Use this repo's data folder
cd ~/.claude/skills/prompt-book
git add data/prompts && git commit -m "Update prompts" && git push

# Option 2: Symlink to your own backup location
ln -s ~/Dropbox/prompts ~/.claude/skills/prompt-book/data/prompts
```

## Uninstall

```bash
rm -rf ~/.claude/skills/prompt-book
```

## License

MIT
