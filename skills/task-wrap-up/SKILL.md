---
name: task-wrap-up
description: Finalize completed work by improving docs, skills, tests, AI prompts, and extracting lessons. Use when a feature, bug fix, or task is complete and the user confirms success. Orchestrates route-knowledge and place-knowledge to produce a concrete improvement plan.
compatibility: cursor opencode
---

# Task Wrap-Up: Auto-Improvement Protocol

Execute after the user confirms a task is complete. Produces a **wrap-up prompt** — a concrete, actionable plan for improving the codebase, documentation, AI capabilities, and agent workflows.

---

## Trigger Conditions

Call this skill when the user says: "done", "complete", "finished", "looks good", "ship it", or confirms a bug is resolved / feature is working.

---

## During-Task Note-Taking

While working on any task, leave breadcrumbs in code for the wrap-up phase:

```
// WRAP-UP: Document this edge case in builder docs
// WRAP-UP: Extract this pattern to a skill
// WRAP-UP: Add regression test for null input
// WRAP-UP: Update AI prompt with new context field
// WRAP-UP: Add rule to AGENTS.md about X
```

These are the raw input to the wrap-up process.

---

## The Three-Step Chain

### Step 1 — Collect raw fragments

Gather all of the following:
- All `// WRAP-UP:` breadcrumb comments from code touched in this task
- User corrections made during the task (what was wrong, what the fix was)
- New patterns or behaviors introduced
- Bugs fixed and why they happened
- Any design decisions made and the reasoning

Assemble into a raw fragment list. Markdown is fine.

### Step 2 — Route (read and follow `route-knowledge` skill)

Read: `route-knowledge` skill (in this repo or installed globally)

Run the Socratic classification on the raw fragments. Output the knowledge tree grouped by meta-location:
- `docs`
- `skills`
- `global-skills`
- `tests`
- `AGENTS.md`
- `ai-prompts`
- `entity-description` (if your project has configurable entities)

### Step 3 — Place (read and follow `place-knowledge` skill)

Read: `place-knowledge` skill (in this repo or installed globally)

For each meta-location group in the tree, run `place-knowledge` to determine:
- Exact file path
- Exact section within file
- Action: create | expand | add to list | write test spec
- Ready-to-paste content

Process meta-location groups in this order (most impactful first):
1. `AGENTS.md` — rules and infra notes (affects all future agent tasks)
2. `entity-description` — instance-specific facts on configured entities (improves AI context and human discoverability)
3. `docs` — user-facing and conceptual knowledge
4. `tests` — regression protection
5. `skills` — reusable patterns
6. `global-skills` — cross-project patterns
7. `ai-prompts` — LLM agent behavior changes

---

## Wrap-Up Output Format

Generate a single wrap-up prompt with this structure:

```
## Wrap-Up: [Task Summary — one line]

### Changes Made
[2-4 bullet summary of what was built/fixed]

### Knowledge Tree
[Full route-knowledge output — all meta-location groups with their nodes]

### Placement Plan
[Full place-knowledge output — all placements, file by file]

### Execution Checklist
- [ ] [File path]: [action] — [one-line description]
- [ ] [File path]: [action] — [one-line description]
...

### Simplicity Check
For each change in the execution checklist, ask:
> "Does this accomplish the same goal more simply?"
Flag any that can be simplified.

### Seed Data (if applicable)
- [ ] Entity/component changes? Update seed data or migration scripts if your project uses them.
```

---

## Simplicity Test

For every proposed change:
> "Does this accomplish the same goal more simply?"

If yes — prefer the simpler version, even at the cost of minor functionality. Document the trade-off in the wrap-up if the simpler version loses something meaningful.

---

## Notes

- The wrap-up prompt is the output. It does not execute changes itself — the agent reviewing the prompt does.
- If route-knowledge produces an empty group (no nodes in that meta-location), skip that group entirely.
- "Global skills" are rare. Only create one when the pattern genuinely applies to any project, not just your current project.
- Code quality (DRY violations, dead code, naming) belongs in the "Changes Made" section, not a separate knowledge node — unless it reveals a generalizable principle, in which case it routes to `AGENTS.md` or `global-skills`.
