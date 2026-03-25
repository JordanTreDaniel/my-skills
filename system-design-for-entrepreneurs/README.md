# System Design for Entrepreneurs

A comprehensive skill for building better systems with pragmatism, business sense, and technical judgment.

## What This Skill Does

This skill helps you:
- **Design greenfield systems** (MVP to enterprise)
- **Choose libraries and frameworks** (CSS, tables, charts, backend, DB)
- **Make infrastructure decisions** (deployment, scaling, optimization)
- **Answer "what do we do now?" questions** with confidence

It's built on insights from Bassem Dghaidi (Senior Software Engineer at GitHub) and focuses on:
- Business impact over technical elegance
- "Good enough for today" over premature optimization
- Measured decisions over intuition
- Scaling to the next order of magnitude (not 100x)

## How to Use This Skill

### Quick Start
Read `SKILL.md` → It's short and answers 90% of questions.

### Detailed Guidance
- **Making architecture decisions?** → `decisions.md` (monolith vs. services, caching, databases, etc.)
- **Choosing libraries?** → `tools-reference.md` (frontend, backend, databases, deployment)
- **Specific Q&A?** → `advisor-qa.md` (answers to common questions with reasoning)
- **Estimating costs?** → `cost-examples.md` (real numbers for MVP to enterprise)

### Visual Reference
See `system-design-decision-tree.png` for the scaling progression at a glance.

## Core Principles

1. **Ask three questions first**:
   - What's the business problem?
   - What scale do we need today?
   - What will break first at 10x?

2. **Design for the next order of magnitude only** (10x, not 100x)

3. **Measure before optimizing** (no guessing)

4. **Prefer boring, proven tools** (Postgres, REST, containers)

5. **Don't pre-optimize** (add features at scale, not indices)

## When to Use This Skill

✅ **Use it when**:
- Designing a new feature or system
- Choosing a framework, library, or tool
- Deciding on deployment strategy
- Planning how to scale
- Debating architecture with your team

❌ **Don't use it for**:
- Specific implementation details (code syntax, API design)
- Live debugging of broken systems
- Deep dives into advanced topics (still read them, but check docs)

## Contents

```
system-design-for-entrepreneurs/
├── SKILL.md                    # Main guidance (start here)
├── decisions.md                # Deep dives (monolith, databases, caching, etc.)
├── tools-reference.md          # Library/framework recommendations
├── cost-examples.md            # Real cost numbers at each stage
├── advisor-qa.md               # Q&A (straight answers to common questions)
└── system-design-decision-tree.png  # Visual (scaling progression)
```

## Key Takeaways

### For MVP (< 1K users)
- One VM, monolith, managed database
- Use boring tools (Next.js, Tailwind, Postgres)
- No caching, no sharding, no microservices
- Cost: < $50/month

### For Growth (1K–100K users)
- Scale up (bigger VM), then out (3–5 containers)
- Add caching only if measured bottleneck
- Read replicas if needed
- Add feature flags
- Cost: $100–500/month

### For Enterprise (100K+ users)
- Kubernetes or ECS
- Specialized databases only if Postgres fails
- Real monitoring (APM, error tracking)
- Team dedicated to scale
- Cost: $1K–15K/month

## Philosophy

**Ship fast, measure ruthlessly, refactor only what breaks.**

Your system will evolve. The question isn't "will we refactor?" but "when?" Make decisions that let you refactor easily later (modular code, clear contracts, testable systems).

The biggest mistake startups make isn't choosing the wrong technology—it's optimizing too early.

---

*Created from lessons of high-scale engineering at GitHub, adapted for entrepreneurial developers who need systems that work today, not some hypothetical tomorrow.*
