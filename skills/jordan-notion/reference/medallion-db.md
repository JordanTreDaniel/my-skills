# Medallion Tech Tasks

**ID:** `21a88889-48f4-809a-afd2-e965c52c244d`
**Data Source:** `collection://21a88889-48f4-81e7-b670-000bc0a2a0a1`
**Client:** Medallion (main paying client: $8k/mo)
**Priority:** ⭐⭐ (secondary, but critical)

## Overview

This is Jordan's client work database. Medallion is the primary income source. When discussing work status, standup, or roadmap, this database provides essential context alongside the primary Tasks DB.

## Views

| View | ID | Purpose |
|------|----|----|
| **Execution** | `view://[FIND IN NOTION]` | Current sprint tasks |

## Context & Relationships

- **Medallion contacts:** Jake, Nancy, Ginger (assistant)
- **Status:** Ongoing, high-priority client
- **Workflow:** Tasks in this DB are separate from primary Tasks DB; both need monitoring
- **Relationship to Tasks DB:** Parallel — not linked. Both should be reviewed in standup.

## When to Use This Database

**Read from Medallion when:**
- Jordan asks "how's Medallion looking?"
- Standup includes client context
- Deciding whether to take on new tasks (Medallion bandwidth?)
- Understanding overall workload (primary + Medallion)

**Write to Medallion when:**
- Jordan explicitly says it's Medallion work
- Client-specific task/bug/feature identified
- Status updates on client work

## Adding Tasks to Medallion

Similar to Tasks DB, but client-focused.

**Always include:**
- Clear description of what Medallion needs
- Relate to Medallion's tech stack/product
- Set Status (usually `Ready to Start` or `In Progress`)

**Example:**
```
Task name: "Fix API timeout on billing endpoint"
Status: In Progress
Database: Medallion Tech Tasks
Priority: Emergency
Size: 3 hours
```

## Important Notes

- **This is client work.** Quality and timeline matter for relationship.
- **Different from primary Tasks DB.** Don't confuse them — monitor both separately.
- **Separate but coordinated.** Jordan often juggles both — understand context.
