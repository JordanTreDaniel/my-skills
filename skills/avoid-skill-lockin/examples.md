# Practical Examples: Avoiding Skill Lock-in

## Scenario 1: Fresh Machine Setup (You Just Got a New Mac)

You have skills published at `https://github.com/yourname/your-skills`.

```bash
# 1. Clone your skills repo
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills

# 2. Run the setup script
SKILLS_REPO=~/dev/your-skills REPO_NAME=your-skills \
  bash ~/dev/your-skills/setup-skills.sh

# 3. Restart Claude Desktop and Cursor
# Your skills are immediately available in all agents
```

Done. All three platforms (Claude Desktop, Cursor, Claude Code) now read from your repo.

---

## Scenario 2: You're Using Cursor + Claude Desktop + Claude Code

All three pointing to the same skills repo.

### Adding a new skill

```bash
cd ~/dev/your-skills
mkdir -p avoid-skill-lockin
cat > avoid-skill-lockin/SKILL.md << 'EOF'
---
name: avoid-skill-lockin
description: Configure skills for portability across agents
---

# Your skill content here
EOF

git add avoid-skill-lockin/
git commit -m "Add avoid-skill-lockin skill"
git push
```

**Immediately available in**:
- ✅ Claude Desktop (reads from `~/.claude/skills/your-skills/avoid-skill-lockin/`)
- ✅ Cursor (reads from `~/.cursor/skills/your-skills/avoid-skill-lockin/`)
- ✅ Claude Code (reads from `~/.cursor/skills/your-skills/avoid-skill-lockin/`)

No restart needed. Just reload your agent or start a new session.

### Editing a skill

```bash
cd ~/dev/your-skills/your-skills/skill-name
# Edit SKILL.md in your editor
nano SKILL.md

# Commit
git add SKILL.md
git commit -m "Improve skill-name clarity"
git push
```

Pull on other machines:
```bash
cd ~/dev/your-skills
git pull
```

All agents see the update on next session.

---

## Scenario 3: Team Sharing

Your team wants to share a code-review skill across different agents.

### Owner publishes

```bash
# Owner's machine
cd ~/dev/team-skills/skills/code-review
# Create or edit SKILL.md with universal format

git add code-review/
git commit -m "Add code-review skill"
git push origin main
```

### Team members install

```bash
# Each team member
git clone https://github.com/teamname/team-skills.git ~/dev/team-skills

# Set up symlinks
SKILLS_REPO=~/dev/team-skills REPO_NAME=team-skills \
  bash ~/dev/team-skills/setup-skills.sh
```

Now all team members across Cursor, Claude Desktop, and Claude Code have access.

### Team member suggests improvement

```bash
# On team member's machine
cd ~/dev/team-skills

# Make changes
nano skills/code-review/SKILL.md

# Push to a branch
git checkout -b improve-code-review
git commit -m "Improve code-review checklist"
git push -u origin improve-code-review

# Create pull request on GitHub
```

Owner reviews and merges. Everyone pulls to get the update.

---

## Scenario 4: Personal Skills + Team Skills

Some skills are personal (Python patterns), some are team-shared (code review standards).

### Setup two repos

```bash
# Personal skills
git clone https://github.com/yourname/personal-skills.git ~/dev/personal-skills
SKILLS_REPO=~/dev/personal-skills REPO_NAME=personal \
  bash ~/dev/personal-skills/setup-skills.sh

# Team skills
git clone https://github.com/acme/team-skills.git ~/dev/team-skills
SKILLS_REPO=~/dev/team-skills REPO_NAME=team \
  bash ~/dev/team-skills/setup-skills.sh
```

**Result**:
```
~/.claude/skills/
  ├── personal/
  │   ├── python-patterns/
  │   └── database-design/
  └── team/
      ├── code-review/
      └── deployment/
```

All skills discoverable in all agents. No conflicts because they're in separate directories.

---

## Scenario 5: Switching Agents (No Lock-in Test)

You've been using Cursor. Now you want to try Claude Desktop.

**Before lock-in prevention** (old way):
- Skills only in `~/.cursor/skills/`
- Need to manually copy or recreate everything for Claude Desktop
- Wasted time, duplicated effort

**After lock-in prevention** (new way):
```bash
# Already done from initial setup
ln -sf ~/dev/your-skills/skills ~/.claude/skills/your-skills
```

**Open Claude Desktop**:
- ✅ All skills available immediately
- ✅ Same SKILL.md files, no conversion
- ✅ No rebuild needed

Switch back to Cursor:
- ✅ Skills still there in `~/.cursor/skills/your-skills`
- ✅ No manual migration

Try OpenCode:
```bash
ln -sf ~/dev/your-skills/skills ~/.opencode/skills/your-skills
```

- ✅ Same skills, instantly available

**Zero lock-in achieved.**

---

## Scenario 6: Publishing to npm (Optional)

Want others to install via `npx skills add`?

### 1. Update package.json

```json
{
  "name": "@yourname/skills",
  "version": "1.0.0",
  "description": "My agent skills collection",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourname/your-skills.git"
  },
  "license": "MIT"
}
```

### 2. Publish

```bash
cd ~/dev/your-skills
npm publish
```

### 3. Others install

```bash
npx skills add @yourname/skills
```

**But they can also just symlink**:
```bash
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills
ln -sf ~/dev/your-skills/skills ~/.claude/skills/your-skills
```

Both methods work. No lock-in to npm.

---

## Scenario 7: Multi-Machine Sync

You develop on Mac at work, use Linux at home.

### Mac (work machine)

```bash
# Clone repo
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills

# Set up symlinks
SKILLS_REPO=~/dev/your-skills REPO_NAME=your-skills \
  bash ~/dev/your-skills/setup-skills.sh

# Edit a skill, commit and push
cd ~/dev/your-skills
nano skills/python-patterns/SKILL.md
git add .
git commit -m "Add async patterns"
git push
```

### Linux (home machine)

```bash
# Clone repo
git clone https://github.com/yourname/your-skills.git ~/dev/your-skills

# Set up symlinks (same command)
SKILLS_REPO=~/dev/your-skills REPO_NAME=your-skills \
  bash ~/dev/your-skills/setup-skills.sh

# Pull updates
cd ~/dev/your-skills
git pull

# Edit a different skill
nano skills/deployment/SKILL.md
git add .
git commit -m "Add Kubernetes tips"
git push
```

### Back on Mac

```bash
cd ~/dev/your-skills
git pull

# See the deployment skill update instantly in Claude Desktop and Cursor
```

Both machines stay in sync through git. All agents on both machines see all updates.

---

## Quick Troubleshooting

**Skills not showing up?**
```bash
# Check symlink
ls -la ~/.claude/skills/your-skills

# Should show: your-skills -> /Users/yourname/dev/your-skills/skills
```

**Want to rebuild symlinks?**
```bash
# Remove old symlinks
rm ~/.claude/skills/your-skills
rm ~/.cursor/skills/your-skills

# Run setup again
bash ~/dev/your-skills/setup-skills.sh
```

**Switching repos?**
```bash
# Use environment variables
SKILLS_REPO=~/dev/new-skills REPO_NAME=new-skills \
  bash ~/dev/new-skills/setup-skills.sh
```

**Check all symlinks**
```bash
echo "=== Claude Desktop ===" && ls -la ~/.claude/skills/
echo "=== Cursor ===" && ls -la ~/.cursor/skills/
echo "=== OpenCode ===" && ls -la ~/.opencode/skills/
```
