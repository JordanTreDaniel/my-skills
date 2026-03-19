---
name: information-design
description: >
  Apply this skill before designing ANY visual output — widgets, dashboards,
  cheatsheets, doc pages, modals, cards, reports, or UI components. Use when
  the user shares dense content that needs to be presented visually, or when
  building any interface where the goal is comprehension, not just display.
  This skill governs HOW to think about layout and structure. Pair it with
  frontend-design for aesthetic execution.
---

# Information Design Skill

The job is not to style content. The job is to make the content's structure
visible. Good information design is invisible — the user understands without
noticing the layout. Bad information design makes users work.

---

## Step 1 — Read the content before touching design

Before any layout decision, identify:

**What is the dominant structure?**

| If the content has... | Use... |
|---|---|
| Two or more parallel things (same shape, different values) | Side-by-side cards |
| A sequence with discrete steps | Stepper or numbered flow |
| One concept with layered depth | Progressive disclosure (summary → detail) |
| A small set of atomic facts | Grid of chips or badges |
| Comparative attributes across options | Table or feature matrix |
| A process with decisions | Flowchart |
| Dense reference (signatures, args, examples) | Structured card: label → badge → code |
| Narrative with supporting data | Editorial: prose + inline figures |

You must be able to describe the layout in one sentence before writing any code.
If you can't, you haven't read the content closely enough.

---

## Step 2 — Reduce before you render

Every piece of content has noise. Remove it before designing around it.

- **Prose descriptions of structured data** → replace with badges, chips, or labels
- **Bullet lists of parallel things** → replace with cards
- **Repeated qualifiers** ("Note that...", "Keep in mind...") → cut or make a tip
- **Long identifiers in body text** → pull into `<code>` inline, shorten the prose
- **Nested bullet lists** → almost always a sign the structure is wrong; redesign as cards or a table

The goal: every word earns its space. If removing it loses no information, remove it.

---

## Step 3 — Assign visual weight correctly

Visual weight = how much the eye is drawn to something. It must match information priority.

Rules:
- The most important thing on the screen should have the highest contrast
- Supporting information should recede (smaller, dimmer, less saturated)
- Repeated structural elements (card borders, section dividers) should be nearly invisible — they provide structure without competing for attention
- Color encodes meaning, not decoration. Use it only when it says something:
  - Green = success / output / positive
  - Blue = input / informational / neutral
  - Gold/amber = caution / key concept / highlight
  - Red = error / warning / destructive
  - Gray = secondary / structural / disabled

Never use more than 3–4 colors in a single component. More = noise.

---

## Step 4 — Design the scan path

Users scan before they read. Design the scan path first.

A good scan path:
1. **Header / label** — tells them what this thing is
2. **Key value or signature** — the one thing they came for
3. **Supporting detail** — confirms or qualifies the key value
4. **Example or proof** — shows it in action
5. **Tips / caveats** — only if truly needed

This order works for: API docs, pricing cards, feature comparisons, cheatsheets,
settings panels, onboarding steps, error messages.

Violations to avoid:
- Leading with caveats before the key value
- Burying the example at the bottom after three paragraphs of prose
- Equal visual weight on everything (nothing is scannable if everything shouts)

---

## Step 5 — Choose the right container

| Container | When to use |
|---|---|
| **Card** (bordered surface) | A bounded object — one complete thing (a contact, a plan, a function signature) |
| **Section** (no border, whitespace-separated) | Grouped content within a flow — not a distinct object |
| **Row** (horizontal strip) | Metadata, attributes, key-value pairs |
| **Grid** (equal columns) | Parallel things of equal importance |
| **Editorial** (no container, prose flows) | Explanatory content where text is primary |
| **Modal / panel** | Secondary content that shouldn't break the primary flow |

Do not put a card inside a card. If you feel the urge, the inner content is a row or section, not a card.

---

## Step 6 — Typography does the hierarchy

Font weight and size are the primary tools. Use them sparingly.

- **Two weights only**: 400 (body) and 500 (label/heading). Never 600 or 700 in UI — too heavy.
- **Two sizes per component**: one for labels/titles, one for body/descriptions. A third size only for de-emphasized metadata.
- **Uppercase + letter-spacing** only for section labels and category chips — never for body text.
- **Monospace** only for identifiers, code, and technical strings — never for prose.
- Line height 1.5–1.7 for body. Tighter (1.2–1.3) for labels and short UI strings.

If you need bold, italic, AND color to make something stand out, the structure is wrong.
Fix the structure; the emphasis will follow.

---

## Step 7 — Spacing is structure

Whitespace is not decoration. It groups, separates, and creates rhythm.

- Items in the same group: 8–12px gap
- Items in adjacent groups: 16–24px gap
- Sections: 32–40px gap
- Padding inside cards: 12–16px
- Never use equal spacing everywhere — it erases the grouping information

The rule: **things that belong together should be closer to each other than to things they don't belong with**. This is Gestalt proximity and it works.

---

## Output checklist

Before shipping any visual design, verify:

- [ ] Can I describe the layout in one sentence?
- [ ] Is the scan path correct — key value first, detail second?
- [ ] Are parallel things parallel in the layout (same container, same structure)?
- [ ] Is color used to encode meaning, not aesthetics?
- [ ] Are there more than 4 colors? (If yes, remove some)
- [ ] Is visual weight proportional to information importance?
- [ ] Does whitespace group related items?
- [ ] Is any bullet list actually a parallel structure in disguise?

---

## Pairing with other skills

- **frontend-design** — aesthetic execution (fonts, motion, atmosphere)
- **cheatsheet-viz** — specific patterns for reference/API content
- **docx / pdf** — when the output is a document, not a UI component

This skill governs structure. The others govern style.
