---
name: think-in-trees
description: Organize any input (conversations, code, decisions, raw context) into a navigable hierarchical knowledge tree using iterative socratic self-questioning. Trees are always subjective — built by intention. Use this to clarify what you (or an LLM) actually care about.
compatibility: cursor opencode claude-desktop
---

# think-in-trees: Socratic Tree Building

Takes any input and produces a hierarchical knowledge tree by running the LLM through 5 phases of socratic self-questioning. Each phase is its own isolated prompt so the LLM doesn't drown in complexity.

**Core principle**: Trees are completely subjective. The hierarchy depends entirely on WHY you're building the tree. Your intention reveals your interest. Your interest reveals what you care about. Therefore: **the tree IS the intention made visible**.

---

## Foundation: Intention = Interest

Everyone acts in self-interest 99.9% of the time. What you pay attention to tells me what you care about. Intention and interest are nearly synonyms — they share Latin roots and mean the same thing: **where is your focus?**

A single set of facts produces infinite trees, depending on who is asking "why" and what they care about.

**Examples of the same facts, different trees:**

Input: "The app has a login system, a database, an API, and a UI."

**Tree 1: Architect's view** (cares about scalability)
```
- System Architecture
  - Stateless services
    - API (no session storage)
  - Data layer
    - Database (bottleneck risk)
  - Frontend (stateful)
```

**Tree 2: Security engineer's view** (cares about attack surface)
```
- Security Boundaries
  - User-facing (UI)
    - XSS risk
  - Auth boundary (Login)
    - Credential handling
  - Data access (API → Database)
    - Injection risk
```

**Tree 3: New developer's view** (cares about onboarding)
```
- How do I run this?
  - Start the API
    - Needs database running
  - Start the UI
    - Talks to API
  - Login to test
```

Same system. Three trees. Three different intentions.

---

## How It Works

### Input

Any of the following:
- Raw conversation transcript or notes
- Agent decision logs
- Code structure or requirements
- Mixed sources (code + design + decisions)
- A single complex statement

Optionally: user provides explicit intention. More often: we infer it by asking "what are you paying attention to?"

### Output

A navigable hierarchical tree (nested markdown list) with:
- Root node (the least common ancestor of everything)
- Link types on each edge (shows parent-child direction)
- Conflict nodes where hierarchy is ambiguous
- GPS annotation (path from root to focus area)

Configurable depth (full tree or truncated summary).

---

## The 5 Phases

Each phase is a discrete socratic pass. Run sequentially. Skip to later phases if input is already partially structured.

---

## Phase 1 — CLASSIFY: What Kind of Tree Is This?

**Purpose**: Detect the archetype. Different archetypes trigger different question sets downstream.

**Socratic question**: Looking at this input, is it describing a plan, a taxonomy, a causal chain, a conversation, code architecture, a decision, or a mixture?

| Archetype | Signals | Primary Link Types |
|---|---|---|
| **Plan** | steps, goals, tasks, todos, milestones, deadlines | depends-on, enables, follows, part-of |
| **Taxonomy** | categories, types, classes, "kinds of", hierarchy | is-a, instance-of, subclass-of |
| **Causal** | because, causes, prevents, leads to, results from | causes, enables, depends-on, prevents |
| **Conversation** | dialogue, questions, decisions, agreements, disagreements | resolves, answered-by, informs, opposes |
| **Code arch** | modules, services, layers, files, imports | uses, depends-on, part-of, implements |
| **Decision** | choices, tradeoffs, criteria, constraints, alternatives | alternative-to, better-for, worse-for, trade-off-of |
| **Knowledge base** | facts, definitions, relationships, mixed sources | any link type; usually mixed |

Most inputs are hybrids (e.g., a plan with embedded decisions, or a conversation about architecture).

**Output of this phase**: Archetype label + which question set to emphasize in Phase 3.

---

## Phase 2 — ROOT-FIND: Why Does This Exist? What Do You Actually Care About?

**Purpose**: Surface the user's true intention. Find the root node — the least common ancestor, not the highest possible abstraction.

This is where you surface **what the person is paying attention to**. This is the most important phase.

### The Intention Excavation Questions

Ask these in order. Each answer climbs or descends the tree slightly:

1. **What are you paying attention to?** (the most direct question)
   - Not "what is this about" but "what matters to you in this?"

2. **Why does this matter to you?** (not why it exists in the abstract — why did you bring it to me?)

3. **What are you trying to do, decide, or understand?** (surface the real goal)

4. **What would make this problem disappear?** (what outcome would satisfy you?)

5. **What stops you from doing that?** (what's in the way?)

6. **At what level would solving this make sense?** (cell? row? report? system? org?)
   - The spreadsheet example: "edit cell" makes no sense alone. "Prepare report for 9am meeting" makes sense. That's the right level.

7. **What would you discard if you had to?** (what details don't matter for your goal?)
   - This prevents you from climbing too high and losing critical context.

### The LCA (Least Common Ancestor) Rule

The root is NOT the highest possible abstraction. It's the minimum level of zoom that:
- Encompasses ALL the input
- Doesn't require discarding any critical detail
- Lets you see the whole problem without drowning in minutiae

**How to find it**: Ask "if I zoom out one more level, does this become meaningless or would I lose something important?" If yes, you've found the root.

### Output of this phase

A single root node with:
- A 2-4 word label
- A one-sentence "why statement" (what the person cares about)
- Archetype signal (which question set to emphasize)

**Example root statements:**
- "Prepare report for 9am meeting" ← why the spreadsheet matters
- "Reduce API response latency" ← why the architecture matters
- "Decide which auth library to use" ← why the comparison matters
- "Understand why the user is angry" ← why the conversation matters

---

## Phase 3 — TREE-BUILD: Expand From Root Downward and Upward

**Purpose**: Iteratively build the tree using canonical socratic questions. Ask every question at every node.

### The Universal Socratic Questions

These work regardless of archetype. Ask at every node, in this rough order:

#### Going DOWN (finding children — "what are the parts?"):
- What are the parts, components, or pieces of this?
- What are examples or instances of this?
- How does this work? What are the mechanisms or steps?
- What does this create, cause, or enable?
- What are the subtypes, variants, or specializations?
- What are the constraints, prerequisites, or assumptions?

#### Going UP (confirming placement — "what is this part of?"):
- What would this be meaningless without?
- What is this a component of?
- What is this an instance or example of?
- What causes, enables, or requires this?
- Why does this exist?

#### Going SIDEWAYS (confirming level and eliminating wrong branches):
- What else exists at this same level?
- What shares the same parent?
- What is this NOT? (the most powerful compression tool — excludes entire branches)
- If I remove this node, what breaks?

### Link Type Taxonomy

Every edge has a link type. Link type determines direction — it tells you which node is the parent.

| Link Type | Symbol | Direction | When to use |
|---|---|---|---|
| **is-a / subclass-of** | → IS-A | child IS-A parent | "dog IS-A mammal" |
| **instance-of** | → INST | child example of parent type | "Fido INST dog" |
| **part-of / has-part** | → PART | child is structural part of parent | "wheel PART car" |
| **causes / has-cause** | → CAUSE | cause is parent (enabler comes first) | "rain CAUSE flood" |
| **enables / depends-on** | → ENABLE | enabler is parent | "auth ENABLE login" |
| **follows / followed-by** | → SEQ | prior is parent in sequence | "step 2 SEQ step 1" |
| **facet-of** | → FACET | facet is child of whole concept | "courage FACET virtue" |
| **uses / used-by** | → USE | dependency parent is implicit parent | "app USE api" |
| **based-on / derives-from** | → BASE | origin is parent | "React BASE component model" |
| **influenced-by** | → INF | influencer is parent | "theory INF policy" |
| **contradicts / conflicts** | → CONFLICT | nodes are siblings under conflict parent | "auth-as-service CONFLICT auth-as-middleware" |

**When unsure which direction**: Ask "which would make no sense without the other?" or "what had to happen first?" That's the parent.

### The Conflict Rule

If a node could legitimately have two parents with different link types, it stays as one node with a conflict flag. Create a sibling node called `[Conflict: X or Y?]` and list both interpretations as children.

This is a feature. Surfacing ambiguity is often more valuable than forcing a tree.

```
- [Conflict: Is auth a service or middleware?]
  - Auth as a service (PART authentication services)
  - Auth as middleware (PART request pipeline)
```

### During Tree-Building: Iterative Refinement

After each expansion:
- Ask: "Is this node one thing or two?"
- Ask: "Is this the right abstraction level?" (one sentence, one behavior, testable)
- Ask: "Did I miss anything?"
- If you find new information, revisit the structure — the tree can change.

---

## Phase 4 — LINK + CONFLICT REVIEW

**Purpose**: Walk the entire tree and confirm consistency. Surface all conflicts explicitly.

### Review Checklist

For every edge:
- [ ] Is the link type correct given the direction?
- [ ] Does the parent actually have this child?
- [ ] Is there an alternative valid parent?

For every node:
- [ ] Does it have exactly one parent? (conflicts are OK, but explicit)
- [ ] Is the content one logical unit or two?
- [ ] Can it be described in one sentence?
- [ ] Does it map back to the original input?

### Conflict Resolution Options

1. **Resolved**: One parent is correct, remove the other interpretation.
2. **Ambiguous but valid**: Keep as a conflict node. Both interpretations serve different intentions.
3. **Missing context**: Add a question/assumption node as a sibling.

---

## Phase 5 — REVIEW LOOP: Completeness Check

**Purpose**: Iterate until the tree accounts for all input and contradictions are resolved.

### Completeness Questions

After a full tree-build pass, ask:
1. Is every piece of the original input represented somewhere in the tree?
2. Does every non-root node have exactly one parent (or is it explicitly flagged as a conflict)?
3. Are all link types directionally consistent?
4. Is every node at the right abstraction level? (one sentence, testable, one behavior)
5. Are there any nodes doing double duty (should be split)?
6. Are there any implied nodes that were never made explicit?
7. Does the tree reflect the user's actual intention, or what I think they should care about?

### Stop Conditions

Stop when:
- All input is accounted for in the tree
- No new contradictions surface
- All nodes pass the abstraction level check
- The tree answers the "why" that motivated the root node

### Iterate If Not Done

If input is not fully represented:
- Go back to Phase 3
- Ask the canonical questions again at the nodes where input is missing
- Rebuild that section
- Re-run Phase 5

---

## Output Format

### Basic Tree Format (Markdown list)

```
# Root: [Root label]

_Why this tree: [one-sentence why statement]_

- [Node A]  _(LINK-TYPE)_
  - [Node A.1]  _(LINK-TYPE)_
  - [Node A.2]  _(LINK-TYPE)_
    - [Node A.2.1]  _(LINK-TYPE)_
- [Node B]  _(LINK-TYPE)_
- [Conflict: X or Y?]  _(CONFLICT)_
  - [X interpretation]  _(LINK-TYPE)_
  - [Y interpretation]  _(LINK-TYPE)_
```

### With GPS (Current Focus Path)

```
GPS: Root > Node A > Node A.2 > Node A.2.1
```

### Configurable Depth

User can specify `depth: N` to truncate output:
- `depth: 1` — root only
- `depth: 2` — root + first level
- `depth: 3` — root + 2 levels
- `depth: all` or unspecified — full tree

The LLM still thinks at full depth internally during Phases 3-5. It only truncates the final output.

---

## Example: Full Tree Build

### Input
```
User: "I'm trying to figure out why the API is slow. The database queries are fast, 
the CPU isn't maxed, but response time is 3-4 seconds. We cache some things but not 
others. I need to present this to my team tomorrow, and I'm worried the answer is 
'it's complicated' but I need a clear story."
```

### Phase 1 — CLASSIFY
**Archetype**: Causal (performance problem) + Conversation (team communication goal) + Decision (which caching strategy)

### Phase 2 — ROOT-FIND
Intention excavation:
- "What are you paying attention to?" → Performance + credibility with team
- "Why does this matter?" → Need clear story for tomorrow
- "What would make this disappear?" → Identifying and fixing the bottleneck
- "At what level?" → System-wide latency, not cell-by-cell query

**Root**: "Reduce API response latency — find bottleneck, present findings"
**Why**: "Tomorrow team meeting requires clear diagnosis and recommendations"

### Phase 3 — TREE-BUILD
```
# Reduce API response latency

_Why this tree: Tomorrow team meeting requires clear diagnosis and clear recommendations_

- API Response Pipeline  _(PART-OF)_
  - Request intake  _(SEQ)_
  - Auth/middleware  _(SEQ)_
    - Known fast (CPU idle, no auth is the bottleneck)  _(USE)_
  - Database query  _(SEQ)_
    - Known fast (queries < 100ms)  _(USE)_
  - Data transformation  _(SEQ)_
    - [Potential bottleneck]  _(CAUSE)_
    - [Missing caching?]  _(CAUSE)_
  - Response serialization  _(SEQ)_
    - [Potential bottleneck]  _(CAUSE)_
- Caching Strategy  _(PART-OF)_
  - Current state: partial  _(FACET-OF)_
  - Candidates  _(PART-OF)_
    - Cache more endpoints  _(ALTERNATIVE-TO)_
    - Cache at layer X  _(ALTERNATIVE-TO)_
    - Cache at layer Y  _(ALTERNATIVE-TO)_
  - Measurement: what's worth caching?  _(PREREQUISITE)_
```

### Phase 4 — LINK REVIEW
- ✅ All SEQ links point forward in the pipeline correctly
- ✅ "Potential bottleneck" nodes are children of their pipeline stages
- ⚠️ Caching Strategy is a sibling of API Response Pipeline, but they're actually related (caching solves the latency goal)
  - **Reposition**: Caching Strategy becomes a solution branch under Response Pipeline

### Phase 5 — REVIEW LOOP
- ✅ Original input accounted for: latency, caching, team presentation
- ✅ Structure shows: what's known fast, what's unknown, what solutions exist
- ✅ Gives team a clear diagnostic structure

**Output depth**: `depth: 2` for the team presentation (clean overview)

---

## Using This Skill

### When to Use

- **Planning**: Take a complex goal and break it into steps
- **Understanding**: Take a conversation or code and surface the structure
- **Decision-making**: Compare alternatives, surface tradeoffs
- **Communication**: Create a clear hierarchy to explain to others
- **Learning**: Build a mental model by externalizing the tree
- **Debugging**: Find missing nodes or conflicting assumptions

### When NOT to Use

- Simple, flat lists (don't need a tree)
- Real-time decisions with no time to think (but this can be fast)
- When you need to *avoid* seeing structure (rare, but sometimes you just need to brainstorm)

---

## Relationship to Other Skills

- **route-knowledge**: A specialized application of think-in-trees. After building a tree, route-knowledge filters it by meta-location (docs, skills, tests, etc.) for storage.
- **place-knowledge**: Downstream of route-knowledge; uses the routed tree to place assertions in files.
- **task-wrap-up**: Can call think-in-trees to build a tree of lessons, then route that tree.

---

## Notes

- Trees are **always subjective**. The same input produces different trees for different intentions. This is correct.
- If you build a tree and it doesn't match reality, it's not the tree that's wrong — it means your intention was different than you thought. **Revise your root node**, then rebuild.
- The best trees are conflict-surfacing trees. A tree with explicit conflicts is often more useful than a clean tree.
- Phases can run in isolation. You can skip phases if the input is already partially structured.
- When in doubt, ask "what is the person paying attention to?" That's always the right direction.
