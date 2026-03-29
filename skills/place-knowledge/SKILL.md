---
name: place-knowledge
description: Given a classified knowledge tree (from route-knowledge), locate the exact file + section + action for each node and produce ready-to-execute placement instructions. Handles one meta-location group at a time. Recursive — children get placed too.
compatibility: cursor opencode
---

# Place Knowledge: Exact Location Finder

Takes one meta-location group from `route-knowledge` output and determines where, precisely, each node belongs. Produces a placement plan — specific files, sections, and content — that can be immediately executed.

---

## Input

One meta-location subtree from `route-knowledge`. Example:

```
### docs

- Form component validates input and shows error messages
  _parent:_ form component → user-facing inputs
  _children:_
    - Error message appears below the input (not modal)
      _parent:_ form validation error display
```

---

## Output Format

For each node, produce a placement block:

```
### [assertion short name]

Node: [full assertion text or markdown block]
File: [exact path relative to workspace root]
Section: [heading or location within file — e.g. "## Form Validation > Error Display"]
Action: [one of: create page | expand existing | add to list | write test spec | create skill | add rule | update existing]
Content:
  [the markdown or code to insert — can be multi-line]

Children:
  ### [child assertion short name]
  Node: ...
  File: ...
  Section: ...
  Action: ...
  Content: ...
```

---

## Process: Scan First, Zoom Later

Never read entire files upfront. Work in three zoom levels:

### Level 1 — High-level scan (always do this first)

For the meta-location group you're placing:

**`docs`**: List doc pages
```
Glob: docs/**/*.md  (or your project's doc structure)
```
Read only titles/headings. Don't read full page content yet.

**`skills`**: List skill directories
```
Glob: .cursor/skills/*/SKILL.md        (project skills)
Glob: ~/.cursor/skills-cursor/*/SKILL.md   (cursor global)
Glob: ~/.agents/skills/*/SKILL.md      (opencode global)
```
Read only the `name:` and `description:` frontmatter lines.

**`tests`**: List test files in the relevant repo
```
Glob: src/**/*.spec.ts  (backend)
Glob: src/**/*.test.{ts,tsx}  (frontend)
```

**`AGENTS.md`**: Already know the file. Read section headings only (lines starting with `###` or `##`).

**`ai-prompts`**: List prompt files in your project
```
Glob: src/prompts/*.ts  (or wherever your prompts live)
```
Always read the files before writing content. Prompt strings are composed from named exports — you need to see the current text to write clean additions.

**`entity-description`**: No file scan needed — destination is a DB column or entity field. Read `_entity-type:_` and `_entity-name:_` annotations from the route-knowledge node.

### Level 2 — Match node to best-fit target

For each node:
1. Does an existing file/section cover this? → `expand existing` or `add to list`
2. Is there a parent file but no section? → `expand existing` (add the section)
3. No match at all? → `create page` or `create skill`

Use `_parent:_` annotations from route-knowledge to navigate to the right area of the tree.

### Level 3 — Zoom in on the match

Read only the matched file (or just the relevant section heading area). Find the right insertion point. Write the `Content:` block.

If the node has children → recurse at Level 2 within the matched file's scope.

---

## Meta-Location Rules

### `docs` nodes

- Determine the doc section from the node's `_parent:_` chain:
  - Involves user interaction → `user/` or `guides/`
  - Involves system concepts / how it works → `concepts/` or `architecture/`
  - Involves builder/configuration tools → `builder/` or `admin/`
  - Involves permissions/roles → `concepts/permissions/` or `admin/`
  - Involves API contracts → `developer/api.md` or `api-reference/`
  - Involves DB schema → `developer/architecture/` or `database/`
  - Involves AI behavior (user-facing) → `user/ai/` or similar
  - Involves AI architecture (dev-facing) → `developer/ai/`
- Check if the target page is a stub (e.g., `*Content to be added.*`) — if so, `expand existing` and fill it in.
- If the content belongs in an existing page but adds a new heading, action is `expand existing`.

### `skills` nodes

- Is this pattern specific to the current project? → `.cursor/skills/` in workspace
- Does it apply to any project? → `~/.cursor/skills/` (Cursor) or `~/.agents/skills/` (opencode)
- Scan existing skill names/descriptions before creating new. If a skill already covers the pattern, `expand existing`. Only `create skill` when no match exists.
- New skills need a `SKILL.md` with frontmatter `name`, `description`, and optionally `compatibility`.

### `global-skills` nodes

- Same as `skills` but path is `~/.cursor/skills/` or `~/.agents/skills/`.
- These are outside the workspace; read with absolute paths.

### `tests` nodes

- Find the test file closest to the component/service being tested.
- If none exists: `create page` (new spec file in the same directory as the source file).
- Spec format matches the repo convention (Jest, pytest, etc.).
- Content should be a ready-to-paste `describe`/`it` block (or `describe`/`test` etc.), not just a description.

### `AGENTS.md` nodes

- Map to the correct section heading:
  - Workflow/infra notes → `### Dev Ops` or `### Infrastructure`
  - Agent behavior rules → `### Rules`
  - Verifiable app behavior → `### Assertions`
  - Deployment changes → `### Deployment Process`
- Action is almost always `add to list` or `update existing`.

### `ai-prompts` nodes

**Always read the target file before writing content.** Prompt strings are composed from named exports — you need to see the current text to write a clean addition or modification.

Adapt this to your project structure:
- New behavior rule for the AI → main prompt file → core prompt section or relevant subsection
- Sub-agent role change → sub-agent descriptions section
- Agent workflow or builder logic change → workflow section
- New tool → tool descriptions section

Content should be the string segment to add or modify — copy-paste ready, correctly embedded in the export it targets. Show surrounding context (a few lines before/after) so the insertion point is unambiguous.

### `entity-description` nodes

Output format differs from file-based placements — use this structure instead:

```
### [entity name] description

Node: [assertion text]
Entity-Type: [section | field | report | template | component | etc. — match your domain]
Entity-Name: [human-readable name as it appears in the DB/UI]
Action: update-description
Current-Description: [fetch via API or admin UI before writing — leave blank if unknown]
Proposed-Description: [the full updated description text, markdown OK]
```

**Process:**
1. Read `_entity-type:_` and `_entity-name:_` from the route-knowledge node.
2. Propose the updated description. Write it as the full description string (not a diff), so it can be copy-pasted directly into the admin UI or database.
3. If the node has children that belong on the same entity, fold them into the `Proposed-Description` as paragraphs or bullet points — don't produce separate placement blocks for each child.
4. If children belong on *different* entities, produce separate blocks per entity.

---

## Example Output

**Input (from route-knowledge):**
```
### docs
- Form component validates input and shows error messages
  _parent:_ form component → user-facing inputs
  _children:_
    - Error message appears below the input (not modal)
      _parent:_ form validation error display
    - Validation occurs on blur and keystroke
      _parent:_ form validation error display
```

**Output:**

```
### Form validation error display

Node: Form component validates input and shows error messages
File: docs/concepts/form-components.md
Section: ## Error Display
Action: expand existing
Content:
  ## Error Display

  Forms validate input and display error messages below the affected field.
  Validation occurs automatically on blur and after keystroke. Errors appear
  consistently across all form types.

Children:

  ### Error message placement
  Node: Error message appears below the input (not modal)
  File: docs/concepts/form-components.md
  Section: ## Error Display > Placement
  Action: add to list
  Content:
    - Errors appear directly below the input field, not in modals or notifications
    - Allows users to correct mistakes without losing context

  ### Validation timing
  Node: Validation occurs on blur and keystroke
  File: docs/concepts/form-components.md
  Section: ## Error Display > Real-time Validation
  Action: add to list
  Content:
    - Validation triggers on `blur` event and after each keystroke
    - Provides immediate feedback without waiting for form submission
```

---

## Notes

- If a node's exact placement is genuinely ambiguous after Level 2, pick the closest match and note the ambiguity in `Section:` as `[uncertain — nearest match: X]`.
- Do not create new files when an existing stub page covers the same topic.
- Markdown in `Content:` blocks should be copy-paste ready — correct heading levels for the target file, no surrounding fences unless it's a code block.
- `entity-description` nodes that co-occur with `docs` nodes for the same topic are not duplicates — the entity gets the instance-specific fact; docs gets the generalizable pattern. Both are valid and should both be placed.
- This skill produces instructions. Executing them (actually writing the files or updating entity descriptions) is the calling agent's job after reviewing the placement plan.
