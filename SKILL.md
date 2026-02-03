---
name: prompt-book
version: 3.0.0
description: |
  Personal prompt library. Save effective prompts, search them later, track what works.

  Commands:
  - /prompt-book save - Save a new prompt to your library
  - /prompt-book find <query> - Search prompts by keyword
  - /prompt-book list - Browse all saved prompts
  - /prompt-book use <id> - Retrieve and display a prompt
  - /prompt-book feedback <id> - Rate a prompt and add notes
  - /prompt-book delete <id> - Remove a prompt
  - /prompt-book watch <start|stop|status> - Auto-capture mode
  - /prompt-book export [file] - Export library to JSON
  - /prompt-book import <file> - Import prompts from JSON
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - AskUserQuestion
  - Bash
---

# Prompt Book Skill

You are managing a personal prompt library stored in `~/.claude/skills/prompt-book/data/prompts/`.

## Storage Location

All prompts are stored as markdown files in: `~/.claude/skills/prompt-book/data/prompts/`

## Prompt File Format

Each prompt is a markdown file with YAML frontmatter:

```markdown
---
id: 20260202-x7km
title: "Descriptive Title Here"
category: coding
tags: [tag1, tag2]
rating: 0
usage_count: 0
created: 2026-02-02
last_used: 2026-02-02
---

## Prompt

[The actual prompt text]

## Context

[When to use this prompt, prerequisites, constraints]

## Feedback

[Empty initially - feedback entries added later]
```

## ID Generation

Generate IDs using format: `YYYYMMDD-XXXX` where XXXX is 4 random lowercase alphanumeric characters.

Example: `20260202-k7xm`

Before saving, glob existing files to check for collision. If collision, regenerate the random suffix.

## Commands

### /prompt-book save

Save a new prompt to the library.

**Flow:**

1. Ask the user: "What prompt would you like to save? Please paste or describe it."

2. After receiving the prompt text, ask:
   - "What title should this prompt have?" (required)
   - "What category? (e.g., coding, writing, research, general)" (optional, default: "general")
   - "Any tags? (comma-separated, or skip)" (optional)

3. Generate a unique ID:
   - Format: `YYYYMMDD-XXXX` (4 random lowercase alphanumeric)
   - Check `~/.claude/skills/prompt-book/data/prompts/` for existing files
   - If `{id}.md` exists, regenerate random suffix

4. Create the markdown file at `~/.claude/skills/prompt-book/data/prompts/{id}.md`

5. Confirm to user: "Saved prompt '{title}' with ID: {id}"

**Example file content:**

```markdown
---
id: 20260202-k7xm
title: "Code Review Request"
category: coding
tags: [review, quality, debugging]
rating: 0
usage_count: 0
created: 2026-02-02
last_used: 2026-02-02
---

## Prompt

Review this code for bugs, security issues, and improvements. Focus on:
1. Logic errors
2. Edge cases
3. Performance concerns
4. Code style

## Context

Use when you want a thorough code review. Works best with complete functions or modules rather than snippets.

## Feedback

```

### /prompt-book find <query>

Search prompts by keyword in title, category, or tags.

**Flow:**

1. If no query provided, show usage: "Usage: /prompt-book find <query>"

2. Search all `.md` files in `~/.claude/skills/prompt-book/data/prompts/`:
   - Use Grep to search for the query string (case-insensitive)
   - Match against title, category, and tags in frontmatter

3. For each matching file, read and parse the frontmatter to extract: id, title, category, rating

4. Display results as a table (max 20 results):

```
Found 3 prompts matching "review":

ID            | Title                  | Category | Rating
--------------|------------------------|----------|-------
20260202-k7xm | Code Review Request    | coding   | 4.2
20260115-m3np | PR Review Checklist    | coding   | 3.8
20260108-q9zt | Writing Review Guide   | writing  | 4.5
```

5. If no results: "No prompts found matching '{query}'. Try a different keyword or use /prompt-book list to see all prompts."

### /prompt-book list

List all saved prompts with optional filtering.

**Flags:**
- `--category <cat>` or `-c <cat>` — filter by category
- `--tag <tag>` or `-t <tag>` — filter by tag

**Flow:**

1. Glob all `.md` files in `~/.claude/skills/prompt-book/data/prompts/`

2. For each file:
   - Read the file
   - Parse YAML frontmatter (handle malformed YAML gracefully - skip file and warn)
   - Extract: id, title, category, tags, rating, last_used

3. Apply filters if specified

4. Sort by last_used (most recent first)

5. Display as table:

```
Your Prompt Library (12 prompts):

ID            | Title                  | Category | Rating | Last Used
--------------|------------------------|----------|--------|----------
20260202-k7xm | Code Review Request    | coding   | 4.2    | 2026-02-02
20260201-p4qr | Debug Helper           | coding   | 4.0    | 2026-02-01
20260128-n8st | Blog Post Outline      | writing  | 3.5    | 2026-01-28
...
```

6. If no prompts exist: "Your prompt library is empty. Use /prompt-book save to add your first prompt."

### /prompt-book use <id>

Retrieve and display a saved prompt, updating usage stats.

**Flow:**

1. If no ID provided, show usage: "Usage: /prompt-book use <id>"

2. Look for file `~/.claude/skills/prompt-book/data/prompts/{id}.md`

3. If file not found: "Prompt '{id}' not found. Use /prompt-book list to see available prompts."

4. Read and parse the file

5. Update the file:
   - Increment `usage_count` by 1
   - Set `last_used` to today's date (YYYY-MM-DD)

6. Display the prompt:

```
## {title}

**Category:** {category} | **Tags:** {tags} | **Rating:** {rating} | **Used:** {usage_count} times

---

{prompt text from ## Prompt section}

---

**Context:** {context text}
```

### /prompt-book feedback <id>

Add a rating and optional notes to a prompt.

**Flow:**

1. If no ID provided, show usage: "Usage: /prompt-book feedback <id>"

2. Look for file `~/.claude/skills/prompt-book/data/prompts/{id}.md`

3. If file not found: "Prompt '{id}' not found. Use /prompt-book list to see available prompts."

4. Ask the user:
   - "How would you rate this prompt? (1-5)" (required)
   - "Any notes? (optional, or skip)"

5. Read the file and update:
   - Append to `## Feedback` section: `- {date}: "{notes}" ({rating}/5)` or `- {date}: ({rating}/5)` if no notes
   - Recalculate `rating` in frontmatter as average of all feedback scores

6. Confirm: "Feedback recorded. New average rating: {rating}"

**Rating calculation:**

Parse all entries in the Feedback section that match pattern `({N}/5)` and compute simple average rounded to 1 decimal place.

**Example feedback section after multiple entries:**

```markdown
## Feedback

- 2026-02-02: "Worked great for React components" (5/5)
- 2026-02-01: "A bit verbose for small files" (3/5)
- 2026-01-28: (4/5)
```

Average: (5 + 3 + 4) / 3 = 4.0

### /prompt-book delete <id>

Remove a prompt from the library.

**Flow:**

1. If no ID provided, show usage: "Usage: /prompt-book delete <id>"

2. Look for file `~/.claude/skills/prompt-book/data/prompts/{id}.md`

3. If file not found: "Prompt '{id}' not found. Use /prompt-book list to see available prompts."

4. Read the file and show the title: "Delete prompt '{title}'?"

5. Ask for confirmation: "Are you sure? This cannot be undone. (yes/no)"

6. If confirmed:
   - Delete the file using Bash: `rm {filepath}`
   - Confirm: "Deleted prompt '{title}' ({id})"

7. If not confirmed: "Cancelled. Prompt was not deleted."

## Error Handling

- **Malformed YAML:** If a prompt file has invalid frontmatter, skip it and warn: "Warning: Skipping {filename} - invalid frontmatter"
- **Missing directory:** If `data/prompts/` doesn't exist, create it
- **Empty search:** If query is empty, show usage hint
- **No results:** Provide helpful suggestion to try different keywords

### /prompt-book watch <start|stop|status>

Enable or disable auto-capture mode, which reminds you to save prompts at session end.

**State file:** `~/.claude/skills/prompt-book/data/.watch-enabled`

**Flow:**

**`/prompt-book watch start`**
1. Create the state file `~/.claude/skills/prompt-book/data/.watch-enabled`
2. Confirm: "Auto-capture enabled. I'll remind you to save effective prompts at the end of long sessions."

**`/prompt-book watch stop`**
1. Remove the state file if it exists
2. Confirm: "Auto-capture disabled."

**`/prompt-book watch status`**
1. Check if state file exists
2. Report: "Auto-capture is currently enabled/disabled."

**Auto-capture behavior:**

When auto-capture is enabled AND the conversation has been substantial (10+ exchanges), at the end of a task or when the user seems finished:

1. Review the conversation for effective prompts the user gave
2. Ask: "I noticed some prompts in this session that worked well. Would you like to save any of these?"
3. List candidate prompts with brief descriptions
4. If user confirms, use the standard save flow for each selected prompt

**Important:** Never auto-save without explicit user confirmation. Always ask first.

### /prompt-book export [file]

Export all prompts to a JSON file.

**Flow:**

1. If no file specified, default to `~/.claude/skills/prompt-book/data/export-{YYYYMMDD}.json`

2. Glob all `.md` files in `~/.claude/skills/prompt-book/data/prompts/`

3. For each file:
   - Read and parse frontmatter and content
   - Extract: id, title, category, tags, rating, usage_count, created, last_used, prompt text, context, feedback

4. Build JSON structure:
```json
{
  "exported": "2026-02-03",
  "version": "3.0.0",
  "prompts": [
    {
      "id": "20260202-k7xm",
      "title": "Code Review Request",
      "category": "coding",
      "tags": ["review", "quality"],
      "rating": 4.2,
      "usage_count": 12,
      "created": "2026-02-02",
      "last_used": "2026-02-02",
      "prompt": "The actual prompt text...",
      "context": "When to use this prompt...",
      "feedback": [
        {"date": "2026-02-02", "notes": "Worked great", "rating": 5}
      ]
    }
  ]
}
```

5. Write to the specified file

6. Confirm: "Exported {N} prompts to {filepath}"

### /prompt-book import <file>

Import prompts from a JSON file.

**Flow:**

1. If no file provided, show usage: "Usage: /prompt-book import <file>"

2. Read and parse the JSON file

3. Validate the structure:
   - Must have `prompts` array
   - Each prompt must have at minimum: title, prompt text

4. For each prompt in the array:
   - Check if ID already exists in library
   - If exists, ask: "Prompt '{title}' ({id}) already exists. Skip or overwrite?"
   - If new, generate a new ID (don't reuse imported IDs to avoid conflicts)
   - Create the markdown file

5. Summary: "Imported {N} prompts. {M} skipped (already existed)."

**Error handling:**
- Invalid JSON → "Error: Could not parse JSON file"
- Missing required fields → "Error: Prompt missing required field 'title' or 'prompt'"
- File not found → "Error: File not found: {filepath}"

## Git Sync Workflow

The `data/` directory can be version-controlled with git for backup and sync across machines.

**Initial setup:**
```bash
cd ~/.claude/skills/prompt-book/data
git init
git add .
git commit -m "Initial prompt library"
git remote add origin <your-repo-url>
git push -u origin main
```

**Sync workflow:**
```bash
# Pull latest from another machine
cd ~/.claude/skills/prompt-book/data
git pull

# After saving new prompts
git add prompts/
git commit -m "Add new prompts"
git push
```

**Conflict resolution:**
- Prompt files are independent, so conflicts are rare
- If conflict occurs, prefer the version with higher usage_count or more recent last_used

## Notes

- All searches are case-insensitive substring matches
- Ratings start at 0 and are updated via feedback
- usage_count starts at 0 and is incremented when prompt is used
- The data/ directory can be version-controlled with git for backup and sync
- Auto-capture requires explicit opt-in and always asks before saving
