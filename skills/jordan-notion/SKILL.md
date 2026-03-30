---
name: jordan-notion
description: Navigate Jordan's personal Notion workspace. Use this whenever working on Jordan's tasks, projects, shopping list, finances, or personal organization. Know which database is primary, what properties exist, view IDs, and hard boundaries (e.g., never touch Journal). Coordinate with Notion MCP for read/write operations. Learn and update understanding of structure as needed.
---

# Jordan's Notion Workspace

Your guide to working with Jordan's personal Notion setup — the source of truth for all his work.

## Quick Start

**Three core databases:**
1. **Tasks** (⭐⭐⭐ primary) — All tasks. Use "Execution" view for standup.
2. **Medallion Tech Tasks** (⭐⭐ client) — Client work context.
3. **Projects** (⭐⭐ linked) — Project definitions; tasks link here.

**Hard rules:**
- 🚫 **NEVER touch Journal** — personal/private
- ✅ **Always use Notion as source of truth** — sync from here
- 📍 **Coordinate with Notion MCP** — for actual read/write operations

---

## Database Quick Reference

See `reference/CHEATSHEET.md` for the complete database table with all IDs and purposes.

### When you need to...

| Task | Read | Write |
|------|------|-------|
| Check my tasks | `reference/tasks-db.md` | `reference/tasks-db.md` → "Adding Tasks" |
| Understand Medallion context | `reference/medallion-db.md` | `reference/medallion-db.md` → "Updating Medallion Tasks" |
| Handle Projects | `reference/tasks-db.md` | (projects rarely modified) |
| Shopping list | `reference/other-dbs.md` | `reference/other-dbs.md` → "Shopping" |
| Bills/Income | `reference/other-dbs.md` | `reference/other-dbs.md` → "Bills" |

---

## How to Work with Jordan's Notion

### 1. Reading Data

Use the Notion MCP to fetch:
```
/notion-db-views <database-id> "<view-name>"
```

Example: Get active tasks from the Tasks "Execution" view
```
/notion-db-views 3a573c09-3ba3-48a9-897f-cf5f77a0f613 "Execution"
```

### 2. Adding/Updating Data

Before you write anything, understand the structure:
1. **Identify the database** — Which database? (see `reference/CHEATSHEET.md`)
2. **Understand properties** — What fields exist? What are valid values? (see `reference/<db-name>.md`)
3. **Use the Notion MCP** — Create or update pages

Examples in each DB guide (e.g., `reference/tasks-db.md` → "Adding Tasks").

### 3. Respecting Boundaries

Check `rules/rules.json` before any write operation. Current rules:
- **Journal** — Forbidden. Never read, write, or reference.
- **Defaults** — Use "Tasks" DB unless explicitly told otherwise.
- **Learning** — Document new discoveries about structure in `rules/learnings.md`.

---

## Database Guides

Each database has a dedicated reference document with:
- Full schema (properties, types, valid values)
- How to add/update items
- Common patterns and gotchas

**Available:**
- `reference/CHEATSHEET.md` — Master table of all databases
- `reference/tasks-db.md` — Primary Tasks database (most important)
- `reference/medallion-db.md` — Client work (Medallion)
- `reference/other-dbs.md` — Shopping, Projects, Bills, Apps & Businesses

---

## Self-Improvement & Learning

As you work with Jordan's Notion, you'll discover:
- New database properties or views
- Relationships between databases
- Patterns in how Jordan organizes things

Document these in `rules/learnings.md` so future sessions know what you learned. Over time, this builds a richer understanding of the workspace.

---

## Quick Commands

```bash
# List tasks in Execution view
/notion-db-views 3a573c09-3ba3-48a9-897f-cf5f77a0f613 "Execution"

# Audit Tasks database health
/notion-db-audit 3a573c09-3ba3-48a9-897f-cf5f77a0f613

# Sync Tasks to local file
/notion-task-sync 3a573c09-3ba3-48a9-897f-cf5f77a0f613 "Execution" ./TASKS.md
```

---

## Notes

- **Notion is the source of truth.** All work starts here.
- **Medallion context matters.** When asking about work, understand it's primary Tasks + Medallion Tasks.
- **This skill is private to Jordan.** It encodes his personal workflow. Public skills (general Notion tips, API wraps) will be separate.
- **Design for learning.** As you discover structure, document it. This skill should get smarter over time.
