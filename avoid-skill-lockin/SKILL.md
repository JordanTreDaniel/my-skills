---
name: avoid-skill-lockin
description: Configure agent skills for portability across Cursor, Claude Code, Claude Desktop, and OpenCode. Use when setting up a new development machine, publishing skills for sharing, or ensuring skills remain accessible regardless of which AI agent you use. Prevents vendor lock-in by using symlinks, git-based distribution, and platform-agnostic SKILL.md format.
---

# Avoiding Skill Lock-in

**Core principle**: Skills should be portable, shareable, and not trapped in one platform's ecosystem.

---

## Problem: Platform Lock-in

Most AI agents (Cursor, Claude Code, Claude Desktop) discover skills from fixed directories with proprietary configuration. This creates friction:

- Skills live in platform-specific paths (`~/.cursor/skills/`, `~/.claude/skills/`)
- Switching platforms means rebuilding or losing skill access
- Publishing to one registry doesn't guarantee compatibility with others
- Teams can't easily share skills across different agents

---

## Solution: Single Source of Truth with Symlinks

**Strategy**: Keep skills in a **git repository** as your single source of truth. Use **symlinks** to connect all platforms to that repo.

### Step 1: Initialize Your Skills Repository

```bash
# Create or clone your skills repo
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills
cd ~/dev/your-skills

# Ensure you have the skills directory structure
mkdir -p skills
```

**Structure**:
```
~/dev/your-skills/
├── skills/
│   ├── skill-name-1/
│   │   └── SKILL.md
│   ├── skill-name-2/
│   │   └── SKILL.md
│   └── ...
├── package.json
└── README.md
```

### Step 2: Symlink to All Platforms

**For Claude Desktop** (macOS):
```bash
mkdir -p ~/.claude/skills
ln -sf ~/dev/your-skills/skills ~/.claude/skills/your-skills
```

**For Claude Code in Cursor**:
```bash
mkdir -p ~/.cursor/skills
ln -sf ~/dev/your-skills/skills ~/.cursor/skills/your-skills
```

**For local OpenCode instances**:
```bash
mkdir -p ~/.opencode/skills
ln -sf ~/dev/your-skills/skills ~/.opencode/skills/your-skills
```

### Step 3: Create Setup Script (Optional but Recommended)

Save this to `~/dev/your-skills/setup-skills.sh`:

```bash
#!/bin/bash
set -e

SKILLS_REPO="$HOME/dev/your-skills"
REPO_NAME="your-skills"

# Create directories
mkdir -p ~/.claude/skills
mkdir -p ~/.cursor/skills
mkdir -p ~/.opencode/skills

# Create symlinks
ln -sf "$SKILLS_REPO/skills" ~/.claude/skills/$REPO_NAME
ln -sf "$SKILLS_REPO/skills" ~/.cursor/skills/$REPO_NAME
ln -sf "$SKILLS_REPO/skills" ~/.opencode/skills/$REPO_NAME

echo "✅ Skills synced:"
echo "  Claude Desktop: ~/.claude/skills/$REPO_NAME"
echo "  Cursor/Claude Code: ~/.cursor/skills/$REPO_NAME"
echo "  OpenCode: ~/.opencode/skills/$REPO_NAME"
echo ""
echo "All platforms now read from: $SKILLS_REPO/skills"
```

Make it executable and run:
```bash
chmod +x ~/dev/your-skills/setup-skills.sh
bash ~/dev/your-skills/setup-skills.sh
```

---

## SKILL.md Format: Universal Compatibility

Use this frontmatter format—it works everywhere:

```yaml
---
name: skill-name
description: What this skill does and when to use it. Use when X, Y, or Z.
---
```

**Supported by**:
- ✅ Cursor (native)
- ✅ Claude Code (native)
- ✅ Claude Desktop (via `~/.claude/skills/`)
- ✅ OpenCode (native)
- ✅ `npx skills` registry (GitHub distribution)

**Avoid platform-specific frontmatter fields** like Cursor-only extensions. Stick to the base format for maximum portability.

---

## Publishing for Sharing

### Option A: GitHub (Recommended)

1. Push your skills repo to GitHub:
```bash
cd ~/dev/your-skills
git remote add origin https://github.com/yourname/your-skills.git
git push -u origin main
```

2. Users install via:
```bash
npx skills add yourname/your-skills
```

### Option B: NPM Registry

Publish to npm for discoverability:
```bash
npm publish
```

### Option C: Direct Git Clone

Users can symlink directly:
```bash
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills
ln -sf ~/dev/your-skills/skills ~/.claude/skills/your-skills
```

---

## Updating Skills Across Platforms

Since all platforms symlink to the same repo, updates flow automatically:

```bash
# Edit a skill in your repo
cd ~/dev/your-skills
nano skills/skill-name/SKILL.md

# Commit and push
git add .
git commit -m "Update skill-name"
git push

# All platforms see the update immediately
```

No manual syncing needed.

---

## Switching Agents

When switching to a new AI agent:

1. Clone your skills repo (or pull latest)
2. Run the setup script (or create symlinks manually)
3. Your entire skill library is immediately available

No rebuilding, no duplication, no lock-in.

---

## Multi-Machine Setup

Keep your skills synced across multiple machines:

1. **Machine A** (primary development):
```bash
cd ~/dev/your-skills
# Make edits and push
git push
```

2. **Machine B** (secondary):
```bash
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills
bash ~/dev/your-skills/setup-skills.sh
```

New edits on Machine B:
```bash
cd ~/dev/your-skills
git pull  # Get any updates from Machine A
# Make changes
git push
```

All machines stay in sync through git, not through platform-specific config files.

---

## Troubleshooting

**Symlink not working**: Verify it points to the right path:
```bash
ls -la ~/.claude/skills/
# Should show: your-skills -> /Users/yourname/dev/your-skills/skills
```

**Skills not showing up**: Check that `SKILL.md` files have valid frontmatter:
```yaml
---
name: skill-name
description: Description here
---
```

**Mixing local and repo skills**: If you have skills in both `~/.cursor/skills/skill-a/` and the symlinked `~/.cursor/skills/your-skills/skill-b/`, they'll both load. This is fine but can be confusing. Keep personal ephemeral skills separate from published repo skills.

---

## Benefits

✅ **No lock-in** — Same skills work in all agents  
✅ **Version controlled** — Full history in git  
✅ **Shareable** — Publish once, install everywhere  
✅ **Automatic updates** — Changes visible immediately  
✅ **Multi-machine** — Clone to any computer  
✅ **Collaborative** — Team members fork and contribute  

---

## Real-World Example

Your team wants to use a shared code review skill across Cursor and Claude Desktop:

1. **One person** creates and publishes:
```bash
cd ~/dev/shared-skills/skills/code-review
# Write SKILL.md with universal frontmatter
git push
```

2. **Everyone else** installs once:
```bash
npx skills add teamname/shared-skills
# Or symlink directly
git clone https://github.com/teamname/shared-skills.git ~/dev/shared-skills
ln -sf ~/dev/shared-skills/skills ~/.claude/skills/shared-skills
ln -sf ~/dev/shared-skills/skills ~/.cursor/skills/shared-skills
```

3. **Owner updates the skill** in their repo
4. **Everyone pulls** to get the update
5. **All platforms** immediately see the latest version

No vendor, no sync tool, no complications.
