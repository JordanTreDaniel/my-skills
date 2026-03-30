# Tasks Database

**ID:** `3a573c09-3ba3-48a9-897f-cf5f77a0f613`
**Data Source:** `collection://e3e69fa7-a73a-412f-97a3-2049c95baebc`
**Priority:** ⭐⭐⭐ (primary)

## Schema

| Property | Type | Valid Values | Required |
|----------|------|--------------|----------|
| **Task name** | text | [task title] | Yes |
| **Status** | select | `Waiting` \| `Ready to Start` \| `In Progress` \| `Paused` \| `Done` | Yes |
| **Priority** | select | `Emergency` \| `Urgent` \| `Let's Go` | No |
| **Size** | select | `30 min` \| `1 hour` \| `3 hours` \| `6 hours` \| `12 hours+` | No |
| **Due** | date | YYYY-MM-DD format | No |
| **Desirability** | select | [custom values] | No |
| **Tags** | multi_select | `dev`, `crypto`, `preparation`, `chessMoves`, `aws`, `backups`, `preservesValue`, `levelUp`, `tech`, `savesStress`, `resiliency`, `onComputer`, `OK.`, `YES!!!`, `FUCK NO.` | No |
| **Assign** | person | [person name] | No |
| **Project** | relation | Links to Projects DB | No |
| **Blocked by** | relation | [other task ID] | No |
| **Blocking** | relation | [other task ID] | No |
| **Cost** | number (dollar) | USD amount | No |
| **Created time** | created_time | auto-generated | No |

## Views

| View | ID | Purpose | Filter |
|------|----|---------|----|
| **Execution** | `view://9e4372a019fa4738988a5bc40ff3173b` | Active/priority work | Active tasks |
| [Others] | TBD | Backlog, By Due, By Status, etc. | Various |

## Adding Tasks

**When to use:** Jordan asks you to add a task, or you've identified something that should be tracked.

**Steps:**

1. **Identify core info:**
   - Task name (required)
   - Status: Usually `Ready to Start` (unless he specifies)
   - Priority: `Emergency`, `Urgent`, or `Let's Go` (or leave blank if low priority)
   - Size: Estimate time needed

2. **Use Notion MCP:**
   ```
   /notion-db-views 3a573c09-3ba3-48a9-897f-cf5f77a0f613 "Execution"
   ```
   Then create via `/create-pages` or equivalent MCP tool with:
   ```json
   {
     "database_id": "3a573c09-3ba3-48a9-897f-cf5f77a0f613",
     "properties": {
       "Task name": "Fix broken link",
       "Status": "Ready to Start",
       "Priority": "Emergency",
       "Size": "30 min",
       "Due": "2026-03-30"
     }
   }
   ```

3. **Optional fields:**
   - Link to a **Project** if it's related
   - Add **Tags** if relevant (e.g., `dev`, `crypto`, `aws`)
   - Assign to someone if needed
   - Note dependencies (Blocked by / Blocking)

## Updating Tasks

**Status progression:**
- `Ready to Start` → `In Progress` (when Jordan starts)
- `In Progress` → `Done` (when complete)
- `Done` → (stays Done, or revive if needed)
- Any status → `Paused` (if blocked)
- Any status → `Waiting` (external dependency)

**Common updates:**
- Moving task to `Done` after completion
- Changing Status to `In Progress` when starting
- Updating Due date if deadline shifts
- Adding Blocked by/Blocking relationships when dependencies emerge

## Examples

**Adding emergency task:**
```
Task name: "Fix Xfinity Internet"
Status: Ready to Start
Priority: Emergency
Size: 30 min
Due: [Today or tomorrow]
```

**Adding complex project task:**
```
Task name: "Implement auth system"
Status: Ready to Start
Priority: Urgent
Size: 6 hours
Project: [Link to relevant project]
Tags: dev, aws
Due: 2026-04-05
```

**Task with dependencies:**
```
Task name: "Deploy to production"
Status: Waiting
Blocked by: [Link to testing task]
Due: 2026-04-10
```
