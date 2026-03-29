# jordantredaniel-skills

A personal collection of agent skills for Cursor, OpenCode, and Claude Code. Covers knowledge organization, system design, frontend development, and code patterns.

## Skills

| Skill | Purpose |
|-------|---------|
| **route-knowledge** | Extract assertions from raw text and classify them into a knowledge tree grouped by meta-location (docs, skills, tests, etc.). Use for Socratic knowledge organization. |
| **place-knowledge** | Given a classified knowledge tree, determine exact file locations and produce ready-to-execute placement instructions. |
| **task-wrap-up** | Finalize completed work by improving docs, skills, tests, and extracting lessons. Orchestrates route-knowledge and place-knowledge. |
| **information-design** | Apply before designing any visual output — widgets, dashboards, cheatsheets, doc pages, UI components. Governs layout and structure thinking. |
| **component-consolidation** | Consolidate multiple similar components into a single DRY master component with variant-specific implementations. |
| **resizable-multi-pane-layout** | React pattern for building resizable, responsive multi-pane layouts with draggable dividers. |
| **suff1c1ent-arch1tecture** | Guide pragmatic system design decisions for entrepreneurial developers. "Good enough for today" approach. |
| **system-design-for-entrepreneurs** | Help developers make pragmatic system design decisions balancing business impact, current scale, and future growth. |

## Installation

Install from GitHub using the Skills CLI:

```bash
npx skills add github:jordantredaniel/jordantredaniel-skills
```

Or install individual skills:

```bash
npx skills add github:jordantredaniel/jordantredaniel-skills/route-knowledge
npx skills add github:jordantredaniel/jordantredaniel-skills/frontend-design
```

## Usage

Skills are integrated into Cursor, OpenCode, and Claude Code. They're automatically available to agents based on their descriptions when they detect relevant trigger scenarios (e.g., "how do I design this UI?" → frontend-design skill).

## Structure

Each skill is a directory containing:
- `SKILL.md` — Main skill file with instructions and examples
- Optional supporting files: `reference.md`, `examples.md`, utility scripts

## License

MIT
