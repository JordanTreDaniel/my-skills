# think-in-trees Cheatsheet

## One-Liner
Use socratic self-questioning to build a hierarchical tree of any knowledge. Trees are always subjective — built by intention.

## The Foundation
- **Trees are subjective**: Same facts → infinite trees depending on why you're building it
- **Intention = what you care about** = what you pay attention to
- **Trees make intention visible**: The hierarchy reveals what matters to the person asking

## 5-Phase Process

### Phase 1: CLASSIFY
What kind of tree is this? (plan, taxonomy, causal, conversation, code arch, decision, knowledge base?)

### Phase 2: ROOT-FIND
Why does this exist? Find the least common ancestor (LCA) — high enough to see everything, not so high you lose detail.

**Questions:**
- What are you paying attention to?
- Why does this matter to you?
- What are you trying to do/decide/understand?
- What would make this disappear?
- What stops you?
- At what level would solving this make sense?
- What would you discard if you had to?

### Phase 3: TREE-BUILD
Expand the tree using canonical socratic questions.

**Going DOWN (finding children):**
- What are the parts/components?
- What are examples/instances?
- How does it work?
- What does it create/cause/enable?
- What are subtypes/variants?

**Going UP (confirming placement):**
- What would this be meaningless without?
- What is this a component of?
- What is this an instance of?
- What causes/enables/requires this?

**Going SIDEWAYS (confirming level):**
- What else exists at this level?
- What shares the same parent?
- What is this NOT?
- If I remove this, what breaks?

### Phase 4: LINK + CONFLICT REVIEW
Confirm link types. Surface conflicts as explicit sibling branches.

**Link types:**
- IS-A / SUBCLASS-OF (type hierarchy)
- INSTANCE-OF (example of type)
- PART-OF / HAS-PART (structural composition)
- CAUSES / HAS-CAUSE (enablement)
- ENABLES / DEPENDS-ON (dependency)
- SEQ / FOLLOWS (sequence)
- FACET-OF (perspective on whole)
- USES / USED-BY (dependency)
- BASE / BASED-ON (origin/derivation)
- INF / INFLUENCED-BY (influence)

### Phase 5: REVIEW LOOP
Iterate until complete:
- Is all input represented?
- Does every non-root node have one parent (or conflict)?
- Are link types consistent?
- Are nodes at right abstraction level?
- Are any nodes doing double duty?
- Are implied nodes missing?

## Output Format

```
# Root: [label]

_Why: [one-sentence intention]_

- [Node A]  _(LINK-TYPE)_
  - [Node A.1]  _(LINK-TYPE)_
- [Conflict: X or Y?]  _(CONFLICT)_
  - X interpretation
  - Y interpretation

GPS: Root > Node A > Node A.1
```

## When to Use
- Planning (goals → steps)
- Understanding (conversation/code → structure)
- Decision-making (compare alternatives)
- Communication (explain hierarchy)
- Learning (build mental model)
- Debugging (find missing nodes)

## When NOT to Use
- Simple flat lists
- Real-time decisions with no time to think
- When you explicitly want to avoid seeing structure

## Key Insight
If your tree doesn't match reality, don't fix the tree — **revise your root node**. Your intention was different than you thought. Then rebuild.

Best trees are conflict-surfacing trees. Conflicts are features.
