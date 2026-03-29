---
name: component-consolidation
description: Consolidate multiple similar components into a single DRY master component with variant-specific implementations. Use when merging N similar components, creating polymorphic components, or refactoring duplicate component code.
---

# Component Consolidation

Guide for merging N similar components into one DRY master component.

## When to Use

- 2+ components share >60% structure but differ in data, behavior, or presentation
- Components diverge only in specific, isolated aspects (headers, data fetching, field mapping)
- The variance can be captured by a discriminated union or single prop

## When NOT to Use

- Components share <60% structure
- Different lifecycle concerns (data fetching patterns, state machines)
- Variance requires deep nesting (>1 level) in render path

## Consolidation Workflow

### 1. Diff Components

Produce a structured comparison:

| Aspect | Shared | VariantA | VariantB | VariantC |
|--------|--------|----------|----------|----------|
| Structure | shell, layout grid | — | — | — |
| Data source | — | API call A | API call B | static JSON |
| Header text | — | "Active" | "Pending" | "Archived" |
| Empty state | — | icon + link | icon only | button CTA |
| Row action | — | edit | view | restore |

### 2. Propose the Abstraction

Define before implementing:

**Variance Axis**: A single discriminant selects the variant
- Discriminated union: `type: 'active' | 'pending' | 'archived'`
- Or config object prop: `variant={source, header, actions}`

**Injection Points** (choose based on complexity):
- **Props**: 1-3 value differences (strings, booleans)
- **Render props**: Complex presentation differences (headers, empty states)
- **Sub-components**: Deep structural divergence (split instead of branch)

### 3. Interface First

Show the type signature for approval before implementation:

```typescript
type EntityListProps =
  | { variant: 'active'; onEdit: (id) => void }
  | { variant: 'pending'; onApprove: (id) => void }
  | { variant: 'archived'; onRestore: (id) => void };
```

**Guardrails**:
- Max 3-4 new props beyond original components
- If more needed → use composition (slots/render props) instead

### 4. Implementation Rules

**Branching**:
- Max 1 level of variant-based branching in JSX
- If deeper → extract sub-components

**Preservation**:
- Zero behavioral regressions
- Each original = master + specific prop combination

**Mapping**:
- Document the replacement: `OldComponentA(props)` → `MasterComponent({ variant: 'a', ...props })`

### 5. Migration Checklist

- [ ] List every call site
- [ ] Map old props → new props
- [ ] Verify each original is replaceable

## Example Template

```
I have N components to consolidate into a single master component.

**Components:**
- ComponentA: [paste/link]
- ComponentB: [paste/link]

**Instructions:**

1. Diff all components in a structured table
2. Propose the variance axis and injection points
3. Show the type signature first, wait for approval
4. Implement with max 1-level branching, no prop explosion
5. Provide migration mapping for each original component

**Do not merge if:**
- <60% shared structure
- Different data fetching patterns
- Would require >3-4 new props
```
