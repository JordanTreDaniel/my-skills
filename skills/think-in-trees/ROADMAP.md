# think-in-trees Skill — Integration & Roadmap

## What Was Built

A foundational socratic tree-building skill that organizes any input into hierarchical knowledge trees using 5 phases:

1. **Classify** — detect the tree archetype (plan, taxonomy, causal, conversation, code arch, decision, knowledge base)
2. **Root-Find** — surface user intention via the LCA (Least Common Ancestor) principle
3. **Tree-Build** — iteratively expand using canonical socratic questions
4. **Link + Conflict Review** — confirm link types and surface conflicts as features
5. **Review Loop** — iterate until complete

## Core Principles Baked In

- **Trees are subjective** — different intentions produce different hierarchies from the same facts
- **Intention = Interest = What you pay attention to** — reveals what you care about
- **Self-interest drives attention** — everyone acts in self-interest 99.9% of the time
- **Conflicts are features** — unresolved hierarchies surfaced explicitly are more valuable than forced consistency

## How It Connects to Your Stack

### Downstream: route-knowledge
`route-knowledge` is now explicitly a specialized application of `think-in-trees`. It:
1. Runs think-in-trees to build a hierarchical tree of knowledge
2. Filters that tree by meta-location (docs, skills, tests, AGENTS.md, ai-prompts, global-skills, entity-description)
3. Outputs classified assertions ready for placement

Updated header in `route-knowledge/SKILL.md` to reference think-in-trees as the parent.

### Downstream: place-knowledge
Unaffected. Still consumes routed assertions and places them in files. The tree structure feeds into placement decisions.

### Upstream: trees app(s)
The skill captures the same link type taxonomy used in `wikidata-explore.service.ts`:
- is-a, instance-of, part-of, causes, enables, follows, facet-of, uses, based-on, influenced-by

This means:
- The skill can help **ingest data** into the trees app by organizing it into the right shape first
- The trees app's **link type patterns** can feed back into the skill's taxonomy if new patterns emerge
- Both are bidirectional — child→parent and parent→child questions are reversible

### Upstream: task-wrap-up
`task-wrap-up` could call `think-in-trees` to:
1. Build a tree of lessons learned
2. Pass that tree to `route-knowledge` for meta-location classification
3. Place them throughout the knowledge base

## What Gets Better Now

### For Code Thinking
- **Better planning** — break goals into hierarchies that reflect true dependencies, not just sequential steps
- **Better debugging** — organize error context into cause→effect→solution trees
- **Better architecture decisions** — tree of tradeoffs surfaces what's actually at stake

### For Knowledge Organization
- **Better summarization** — walk the tree until details don't matter for your goal
- **Better trimming** — understand which branches are irrelevant to intention
- **Better communication** — present only the tree depth needed for audience + intention

### For LLM Context Management
- **Structured context** — instead of dumping everything into the context window, build a tree, then recursively fetch subtrees
- **Tokenomics** — LLM only loads the branches it needs
- **Traceability** — every piece of context has a visible parent, not orphaned facts

### For Human-LLM Collaboration
- **Bridging the gap** — humans and LLMs can collaboratively build and edit the tree
- **Shared mental models** — the tree is the external representation of both brains' models
- **Intention-driven** — by surfacing intention in the root, humans and LLMs agree on what matters

## Next Steps (Not Part of This Skill, But Ideas)

### Immediate
- Test the skill on complex conversations/requirements to refine the canonical questions
- See if the conflict-surfacing behavior actually finds important ambiguities (it should)
- Compare tree depth/complexity across different intentions for the same input (for validation)

### Medium-term
- Create a coded **parser mode** that detects markdown header structure and pre-populates Phase 1 classifications
- Formalize a **benchmark** for the socratic-powered approach (comparing tree quality to other summarization methods)
- Build **tree visualization** (this is for the trees app, not the skill, but the skill output could feed it)

### Long-term
- LLM agents that recursively explore trees (fetch root, evaluate which branches matter, fetch those, recurse)
- Trees as a **data layer** — B2B products that sync all their organizational knowledge (meetings, decisions, problems) into a tree structure
- **Learning app** — teach people to think-in-trees from school onward (education startup idea)

## File Locations

- **Skill**: `/Users/jnakamoto/.cursor/skills/think-in-trees/SKILL.md` (symlink to `/Users/jnakamoto/dev/my-skills/skills/think-in-trees/SKILL.md`)
- **Cheatsheet**: `/Users/jnakamoto/dev/my-skills/skills/think-in-trees/CHEATSHEET.md`
- **Related**: 
  - `route-knowledge` updated with reference to think-in-trees
  - `wikidata-explore.service.ts` (link types reference)
  - `markdown-parser.service.ts` (nested task parsing)

## How to Use the Skill

In Cursor or any compatible agent:
1. Reference the skill with `@think-in-trees`
2. Provide input (conversation, requirements, code, raw notes)
3. Optionally specify intention or depth preference
4. The agent will run all 5 phases and output a navigable tree

Example invocation:
```
@think-in-trees

Input: [paste a conversation or problem description]
Intention: I want to understand what's blocking our deployment
Depth: 2 (just root + 1 level for overview)
```

The skill handles the rest — it will think aloud through all phases and produce a tree.
