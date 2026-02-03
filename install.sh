#!/bin/bash
# Install prompt-book skill for Claude Code

set -e

INSTALL_DIR="$HOME/.claude/skills/prompt-book"

if [ -d "$INSTALL_DIR" ]; then
  echo "prompt-book already installed at $INSTALL_DIR"
  echo "To update: cd $INSTALL_DIR && git pull"
  exit 1
fi

mkdir -p "$HOME/.claude/skills"
git clone https://github.com/23jmo/prompt-book.git "$INSTALL_DIR"

echo ""
echo "Installed! Use /prompt-book in Claude Code."
