---
name: route-knowledge
description: Extract assertions from raw text and classify them into a Socratic knowledge tree, grouped by meta-location (docs, skills, tests, AGENTS.md, ai-prompts, global-skills, entity-description). Use as the first step in task-wrap-up, or standalone to classify any knowledge fragment.
compatibility: cursor opencode
---

# Route Knowledge: Socratic Classification

A specialized application of **think-in-trees** (the general tree-building skill). Takes raw input — conversation notes, WRAP-UP breadcrumbs, feature descriptions, corrections — and produces a structured knowledge tree grouped by **meta-location**. Does not write anything. Does not determine exact files. That's `place-knowledge`'s job.

For the general-purpose tree-building method, see **think-in-trees**. This skill applies that method + adds a meta-location filter on top.

---

## Input

Any of the following:
- Conversation excerpts or full transcripts
- `// WRAP-UP:` breadcrumb comments collected from code
- Feature descriptions or change summaries
- User corrections or agent mistakes

Markdown is valid inside node content.

---

## Output Format

A tree of assertions, split into **meta-location groups**. Each group is an indented list. Nodes can have children.

```
## Knowledge Tree

### [meta-location]

- [assertion]
  _parent:_ [what this doesn't exist without]
  _children:_
    - [sub-assertion]
      _parent:_ [assertion above]
```

**Meta-locations:**

| Label | Destination | Applies when |
|---|---|---|
| `docs` | `docs/` folder or equivalent | App behavior, features, user-facing concepts, built tools and utilities |
| `entity-description` | `description` column on a DB/config entity | Knowledge specific to one named configured instance (report, template, configuration, etc.) |
| `skills` | `.cursor/skills/` (project) | Reusable patterns for **developers and dev-tooling agents** working on this codebase |
| `global-skills` | `~/.cursor/skills/` or `~/.agents/skills/` | Reusable patterns for **developers and dev-tooling agents** applicable to any project |
| `tests` | Test spec files in the relevant repo | Verifiable behavior to automate |
| `AGENTS.md` | Project AI guidance file (e.g. `AGENTS.md`) | **Rules, principles, decisions that change agent behavior on every task** — not documentation of tools or infra; only when an agent's approach must change |
| `ai-prompts` | LLM prompt files (e.g. `src/prompts/`) | AI agent behavior, routing rules, sub-agent instructions, builder workflow |

---

## Socratic Process

For **each raw fragment**, run through these questions in order. The answers navigate the knowledge tree to the exact node.

### Q1 — What IS this?
Name the thing. Be specific. Not "a feature" — "form validation error message" or "deploy script --refresh-db flag".

### Q2 — What doesn't it exist without? (→ parent)
Walk UP the tree. Keep asking "what is this part of?" until you hit an independent concept.
> Form validation error → form component → user-facing input → frontend

### Q3 — What's at the same level? (→ siblings, optional)
What other things share the same parent? Naming siblings confirms you're on the right branch, not too high or low.
> Form validation error sits alongside: form submission state, form reset behavior

### Q4 — Who cares about this? (→ meta-location)
| Who cares | Meta-location |
|---|---|
| End users interacting with the app | `docs` (user/) |
| Developers building/extending the app | `docs` (developer/ or concepts/) |
| Anyone inspecting or querying a specific configured entity | `entity-description` |
| The AI agent doing tasks on this project | `AGENTS.md` or `skills` |
| Any AI agent on any project | `global-skills` |
| QA / preventing regressions | `tests` |
| The LLM-powered AI agent (routing, workflows, generation) | `ai-prompts` |

### Q4a — AGENTS.md vs docs: is this a rule or a tool?

Before routing infrastructure/tooling to `AGENTS.md`, ask:

> **Does this change how the agent approaches tasks on every run, or is it just documentation of what we built?**

| Content | Meta-location |
|---|---|
| "The scraper downloads live data and expands nested properties" | `docs` (developer/) — it's what we built |
| "Before running the scraper, always verify instance state with configuration mappings" | `AGENTS.md` — it's a rule for agent behavior |
| Deployment scripts, utilities, tools, features | `docs` (developer/) |
| Rules, principles, environment decisions, infrastructure *patterns* | `AGENTS.md` |

**The test**: If you removed this entry, would the agent's *approach* to future tasks change, or would developers just have less documentation?

> ❌ WRONG: "The scraper downloads live data and expands nested properties" → `AGENTS.md`
> ✅ CORRECT: "The scraper downloads live data and expands nested properties" → `docs` (developer/)

### Q4b — Skills vs AI-Prompts: who is the actor?

This is the most commonly misrouted boundary. Before routing anything to `skills` or `global-skills`, ask:

> **Who performs this action — a developer/cursor-agent, or the LLM AI agent (and its users)?**

| Actor | Meta-location |
|---|---|
| Developer building the app (you, cursor, opencode) | `skills` or `global-skills` |
| LLM agent helping users build, configure, or query the system | `ai-prompts` |
| End user directly using the application | `docs` (user/) or `entity-description` |

**The hard rule**: User-facing composition, configuration, and querying is **the job of the user and the LLM agent** — not the job of our dev tools. Cursor and opencode agents build the app; they do not compose user-facing configurations. Any pattern about "how to combine X and Y for the user" belongs in `ai-prompts` (so the builder agent knows it) and/or `docs` (so the human knows it) — NOT in `skills` or `global-skills`.

The test: if a cursor/opencode agent executing a dev task would never use this skill, it doesn't belong in `skills`.

### Q4c — Is this about a specific named instance or a general pattern?

**The instance test**: remove the entity name from the assertion. If it becomes meaningless or wrong, it belongs on the entity (`entity-description`). If it still holds as a general truth, it belongs in `docs`, `skills`, or `AGENTS.md`.

> "The evictions report joins API data with a manual supplement keyed on tenant ID"
> → remove "evictions report" → meaningless → `entity-description` on the report/entity

> "Manual supplements can merge with API data where the API has gaps"
> → remove entity name → still true → `docs` (concepts/integrations)

When the assertion IS instance-specific, annotate the node with:
- `_entity-type:_` one of: `section` | `field` | `report` | `template` | `configuration` | `component` | etc. (match your project's entities)
- `_entity-name:_` the human-readable name (e.g. "Evictions Report", "User Status Config")

### Q5 — What is it NOT? (→ eliminate wrong branches)
Ask what this assertion does NOT apply to. This zooms to the precise level.
> "Form validation error" — does NOT apply to modals, tables, or dropdowns → it's form-specific, not generic input.

### Q6 — Is it too complex for one node? (→ children)
Split into children when:
- The feature has multiple independently verifiable behaviors
- You're grouping two existing concepts that each need their own placement
- The node is a category header with specific instances underneath

Children confirm location. A complex feature that touches both docs and tests produces one node in each meta-location group — not forced into one.

---

## Abstraction Level Check

After placing a node, ask: **Is this too specific, or too general?**

- **Too specific**: "When I click the blue button on the settings page it opens a modal" → abstract to "Button component opens modal on click"
- **Too general**: "Frontend handles user input" → useless; zoom in to the actual behavior

The right level: one sentence, testable, describes one behavior that either works or doesn't.

---

## Entity Descriptions (Optional: If Your Project Uses Configurable Entities)

If your project has named configurable entities (reports, templates, configurations, data sources, etc.), you can annotate nodes with `_entity-type:_` and `_entity-name:_`:

When the assertion IS instance-specific:
- `_entity-type:_` the entity type (match your domain)
- `_entity-name:_` the human-readable name as it appears in the DB/UI

Example:

```
- Data is joined on tenant ID
  _entity-type:_ report
  _entity-name:_ Evictions & Collections
```

This tells the placement tool that this fact belongs in the `description` field of the named entity, not in generic docs.

**If your project doesn't have configurable entities, skip this.** It's optional and project-specific.

---

## AI Prompts Orientation (Optional: If Your Project Has AI Agents)

If your project has LLM agents with configurable prompts (e.g. `src/prompts/`), route agent behavior to `ai-prompts`:

**Route to `ai-prompts` when**:
- A new concept or pattern was introduced that the AI needs to know about
- An agent's role or workflow changed
- Sub-agent behavior or capabilities changed
- A new tool was added to the agent

**Do NOT route to `ai-prompts`** for:
- App behavior the user sees (→ `docs`)
- Instance-specific facts about a configured entity (→ `entity-description`)
- Dev workflow changes (→ `AGENTS.md`)

---

## Example Output

**Input fragments:**
- Form component validates input and shows error messages below the field
- Errors always appear regardless of form type
- The `--refresh-db` flag in deploy.sh backs up DB before downloading from S3
- We prefer real-time validation on all form inputs

```
## Knowledge Tree

### docs

- Form component validates input and shows error messages below the field
  _parent:_ form component → user-facing inputs
  _siblings:_ form submission state, form reset behavior
  _children:_
    - Error message appears below the input (not modal or toast)
      _parent:_ form validation error display
    - Validation occurs on blur and keystroke (not just submit)
      _parent:_ form validation error display
    - Errors appear on all form types (not type-specific)
      _parent:_ form validation error display

### skills

- Form inputs validate in real-time and display errors inline
  _parent:_ UI interaction patterns → frontend forms
  _note:_ Project-wide pattern; applies to all form components

### global-skills

- Real-time validation with inline error messages is preferred for all form inputs
  _parent:_ form component design patterns
  _note:_ Not project-specific; apply to any project

### AGENTS.md

- `deploy.sh --refresh-db` backs up the current DB before downloading the latest, then runs migrate-all
  _parent:_ deployment process → infra notes
  _note:_ Updates the deployment section
```

---

## Notes

- A single input fragment can produce nodes in **multiple** meta-location groups. Don't force one location.
- Node content can be multi-line markdown — use it for complex behaviors.
- Always mention siblings when they help disambiguate placement.
- Don't cloud the context window reading every file. Scan at high level first; zoom in only when a node's placement is ambiguous.
- `entity-description` and `docs` frequently co-occur: the entity gets the instance-specific fact; docs gets the generalizable pattern.
