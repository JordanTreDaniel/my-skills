#!/bin/bash
set -e

# Configuration - customize these for your setup
SKILLS_REPO="${SKILLS_REPO:-$HOME/dev/your-skills}"
REPO_NAME="${REPO_NAME:-your-skills}"

# Check if skills repo exists
if [ ! -d "$SKILLS_REPO" ]; then
    echo "❌ Skills repo not found at: $SKILLS_REPO"
    echo "Usage: SKILLS_REPO=/path/to/repo bash setup-skills.sh"
    exit 1
fi

if [ ! -d "$SKILLS_REPO/skills" ]; then
    echo "⚠️  Warning: No 'skills' subdirectory found in $SKILLS_REPO"
    echo "Proceeding with direct symlink..."
fi

# Create platform directories
mkdir -p ~/.claude/skills
mkdir -p ~/.cursor/skills
mkdir -p ~/.opencode/skills

# Create symlinks with force flag (replace existing if needed)
echo "🔗 Creating symlinks..."
ln -sf "$SKILLS_REPO/skills" ~/.claude/skills/$REPO_NAME && echo "✅ Claude Desktop"
ln -sf "$SKILLS_REPO/skills" ~/.cursor/skills/$REPO_NAME && echo "✅ Cursor/Claude Code"
ln -sf "$SKILLS_REPO/skills" ~/.opencode/skills/$REPO_NAME && echo "✅ OpenCode"

echo ""
echo "✅ Skills synced:"
echo "   Claude Desktop:      ~/.claude/skills/$REPO_NAME"
echo "   Cursor/Claude Code:  ~/.cursor/skills/$REPO_NAME"
echo "   OpenCode:            ~/.opencode/skills/$REPO_NAME"
echo ""
echo "📍 Source: $SKILLS_REPO/skills"
echo ""
echo "Restart your agent apps for changes to take effect."
