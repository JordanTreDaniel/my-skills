# Example: Using think-in-trees Skill

## Scenario

You have a messy situation: your team's API is slow, the codebase is hard to navigate, and you need to decide whether to refactor or add caching. You also have a meeting tomorrow. You're overwhelmed and don't know where to start.

You give the skill all your context — notes, concerns, tradeoffs — and ask it to help you think clearly.

---

## Input

```
We have a performance problem. The API responses are 2-3 seconds and we don't 
know why. I've looked at:
- Database queries: fast (avg 50ms)
- CPU: not maxed out
- Network: seems fine
- Code: we have some synchronous operations that might be the issue
- Caching: we cache some endpoints but not others

The team thinks it's architectural. I think it might be caching. The CTO wants 
to refactor the whole thing. Our PM wants a quick fix.

I need to present findings tomorrow at 9am. I need a clear story that either 
backs the CTO's refactor plan or proves my caching theory or something else 
entirely.

What should I do?
```

---

## Phase 1 — CLASSIFY (LLM's internal thinking)

> Looking at this input, I see:
> - A **causal problem** (performance symptom, looking for root cause)
> - A **decision problem** (refactor vs cache vs something else)
> - A **communication problem** (need to present findings)
> - Elements of a **plan** (what to do before tomorrow)
>
> This is a hybrid archetype: causal + decision + communication.
> Primary questions should focus on causation and tradeoffs.

---

## Phase 2 — ROOT-FIND (LLM's socratic excavation)

> **What are you paying attention to?**
> → Performance (slow API responses)
>
> **Why does this matter to you?**
> → Team meeting tomorrow; need credibility and a clear recommendation
>
> **What are you trying to do?**
> → Diagnose the bottleneck, present findings, suggest next steps
>
> **What would make this disappear?**
> → Finding the actual cause and having a plan to fix it
>
> **At what level does solving this make sense?**
> → System-wide latency issue (not individual query tuning). The API layer.
>
> **What would you discard if you had to?**
> → Implementation details about specific endpoints; focus on the pattern
>
> **Root identified:** "Diagnose API latency bottleneck for team credibility and decision"
> **Why:** Tomorrow's meeting requires clear diagnosis + recommendation; team is split on solution

---

## Phase 3 — TREE-BUILD (LLM builds and iterates)

After asking canonical questions at each node:

```
# Diagnose API latency bottleneck

_Why: Tomorrow meeting requires credible diagnosis and recommendation_

- Performance Issue (2-3s API response)  _(CAUSE)_
  - Known fast (ruled out)  _(SEQ)_
    - Database queries (avg 50ms)  _(MEASURED)_
    - CPU utilization (not maxed)  _(MEASURED)_
    - Network latency (acceptable)  _(MEASURED)_
  - Unknown/suspected bottlenecks  _(SEQ)_
    - Synchronous operations in middleware  _(SUSPECT-SOURCE)_
    - Missing caching on hot endpoints  _(SUSPECT-SOURCE)_
    - Serialization/transformation overhead  _(SUSPECT-SOURCE)_
    - Architectural inefficiency (broad category)  _(SUSPECT-SOURCE)_
  
- Decision: What to do?  _(SOLVE)_
  - Option A: Refactor architecture  _(ALTERNATIVE)_
    - Cost: weeks of work
    - Benefit: long-term scalability
    - Risk: might not fix the actual problem
  - Option B: Add targeted caching  _(ALTERNATIVE)_
    - Cost: days of work
    - Benefit: quick win, measurable improvement
    - Risk: doesn't fix architectural issues if that's the real problem
  - Option C: Profile first, then decide  _(ALTERNATIVE)_
    - Cost: 1-2 days
    - Benefit: actual data, informed decision
    - Risk: delays the meeting recommendation (maybe OK?)

- Communication: What story wins the room?  _(PRESENT)_
  - Evidence-first narrative  _(APPROACH)_
    - Here's what we ruled out
    - Here's what we suspect
    - Here's what we need to measure
  - Recommendation with caveats  _(APPROACH)_
    - If it's caching: do this
    - If it's architecture: do that
    - Here's how we'll know which
```

---

## Phase 4 — LINK + CONFLICT REVIEW

LLM reviews and finds:
- ✅ All "ruled out" items are correctly children of "known fast"
- ✅ All "suspect" items are siblings (same level of uncertainty)
- ⚠️ **Conflict detected:** Option C (profile first) conflicts with meeting deadline
  - Creates new node: `[Conflict: Recommend now vs get data first?]`
  - Could be siblings under a new parent: "Communication strategy"

Updated tree now shows:
```
- [Conflict: Recommend now vs get data first?]  _(TENSION)_
  - Recommend today (take calculated risk)
    - Pro: decisive, satisfies CTO + PM want clear direction
    - Con: might be wrong, looks unprofessional if we guess
  - Request 1-2 days to profile (be data-driven)
    - Pro: credible, evidence-based, team learns
    - Con: delays meeting decision, looks indecisive
```

---

## Phase 5 — REVIEW LOOP

LLM asks itself:

1. Is all input represented? ✅
   - Performance problem → yes
   - Database/CPU/network checked → yes
   - Suspects identified → yes
   - Team split (refactor vs cache vs?) → yes
   - Meeting tomorrow → yes

2. Does every node have one parent? ✅ (with explicit conflicts)

3. Are link types consistent? ✅

4. Are nodes at right abstraction level? ⚠️
   - "Option B: Add targeted caching" is good
   - But "might not fix the actual problem" is a reason, not a node
   - Could split into:
     - "Quick win: add caching (days)"
     - "Risk: might not be the real problem"

5. Are implied nodes missing? ✅ Yes:
   - **"Who cares about different outcomes?"**
     - PM cares about: fast user experience + quick fix
     - CTO cares about: long-term architecture + technical correctness
     - You care about: credibility + making the right call
   - This becomes a new node: "Stakeholder priorities"

Updated tree adds:

```
- Stakeholder priorities  _(CONTEXT)_
  - PM: quick user-facing fix  _(GOAL)_
  - CTO: architectural correctness  _(GOAL)_
  - You: credible diagnosis  _(GOAL)_
  - Team trust: unanimous decision  _(GOAL)_
```

---

## Final Output (Depth: 2)

```
# Diagnose API latency bottleneck

_Why: Tomorrow meeting requires credible diagnosis and recommendation to resolve team conflict on next steps_

- Performance Analysis  _(INVESTIGATE)_
  - Known fast (ruled out)  _(SEQ)_
  - Suspected bottlenecks  _(SEQ)_
  
- Decision & Recommendation  _(DECIDE)_
  - Quick fix vs deep refactor  _(TRADEOFF)_
  - Recommend now vs profile first  _(TENSION)_
  
- Stakeholder Context  _(FRAME)_
  - PM: speed over long-term
  - CTO: architecture over quick fix
  - You: credibility + right call

GPS: Root > Performance Analysis > Suspected bottlenecks
```

---

## What Just Happened

1. **LLM made your intention visible**: Tomorrow's meeting + credibility was the real root, not just "fix performance"
2. **Surfaced the real conflict**: Not CTO vs PM philosophically, but *you* torn between data-driven and decisive
3. **Organized chaos into branches**: The overwhelming mess became a navigable tree where you can reason about each piece
4. **Revealed missing context**: Stakeholder priorities weren't in your original input, but the tree found them
5. **Made tradeoffs explicit**: Now you can SEE that "quick fix" and "credible diagnosis" are not the same goal

## Next Step (After Meeting)

After tomorrow's meeting, you run think-in-trees again with outcomes:
- "We decided to X"
- "Here's what we learned"
- "Here's why it worked or didn't"

That tree feeds to `route-knowledge` → `place-knowledge` → your knowledge base learns from this decision.

The tree is now part of your institutional memory.
