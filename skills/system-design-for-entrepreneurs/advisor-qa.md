# Advisor Q&A: Quick Answers to Common Questions

Use this section to get straight answers to practical questions. Each answer includes:
- **The simple answer** (one sentence)
- **Why?** (the reasoning)
- **When to deviate** (exceptions)

---

## Architecture Questions

### "Should we use microservices?"

**Simple answer**: No. Unless you have 100K+ users *and* a team that can own individual services independently, use a monolith.

**Why?** Microservices introduce distributed system complexity (consistency, deployment, debugging) that's only worth it if you have a team big enough to own each one. Most startups shipping a monolith will beat a startup managing 10 microservices because the monolith team ships faster.

**When to deviate**: You have an isolated, high-traffic service (e.g., real-time notifications) that needs different scaling than your main app.

---

### "Should we go serverless?"

**Simple answer**: Use serverless for non-latency-critical APIs and scheduled jobs; avoid it for real-time features or if anyone on the team is uncomfortable with it.

**Why?** Serverless (Lambda, Cloud Functions) auto-scales and you pay per request, which is great for spiky load. But cold starts add 100–500ms, which breaks real-time features. And it's harder to debug.

**When to deviate**: You're building a mobile API where +500ms doesn't matter, or you're AWS-native and Lambda is your hammer.

---

### "Monolith or separate frontend/backend?"

**Simple answer**: For MVP, Next.js (full-stack in one) is fastest. Once you need independent frontend deploys or multiple clients (web + mobile), split them.

**Why?** Deploying a full-stack monolith is one pipeline. Splitting means two pipelines, two secrets, two monitoring setups. Not worth it until you need it.

**When to deviate**: You have a dedicated mobile app team that needs independent release cycles.

---

## Database Questions

### "SQL or NoSQL?"

**Simple answer**: SQL (PostgreSQL) unless your data isn't relational or you're write-heavy at massive scale.

**Why?** SQL is simpler to reason about, has better tooling, and scales further than most people think. Sharding a SQL database is hard, but you'll know when you need to do it.

**When to deviate**: You're building a real-time events system (millions of writes/sec) or have unstructured JSON data.

---

### "Should we shard the database?"

**Simple answer**: No. Not until your primary database is genuinely maxed out and reads replicas don't help.

**Why?** Sharding is painful. It couples your application layer to your database layer. You'll know when you need it because your database will be screaming, your bills will be astronomical, and you'll have the team to manage it.

**When to deviate**: You hit 100M+ rows and read replicas aren't enough, or writes are bottlenecking the primary.

---

### "Should we move to a specialized database?"

**Simple answer**: Only if PostgreSQL actively fails you for a specific use case.

**Why?** Adding a new database means another backup, another monitoring alert, another thing to learn. Use PostgreSQL until it genuinely can't do the job.

Examples of "PostgreSQL can't do this":
- ✅ Time-series data at 1M+ metrics/sec → ClickHouse or TimescaleDB
- ✅ Full-text search across millions of documents → Elasticsearch
- ✅ Vector similarity search for AI → Pinecone or Weaviate
- ❌ "We want NoSQL" (it's not a problem) → Stay on PostgreSQL

---

## Scaling Questions

### "How do I know when to scale?"

**Simple answer**: When you're consistently at 80% of your resource limit (CPU, memory, connections, or requests/sec) for 2+ weeks.

**Why?** Scaling early wastes money. Scaling late loses revenue. 80% is the sweet spot: you have buffer for spikes, but you're not paying for idle capacity.

**How to measure**:
```
CPU: top / htop / CloudWatch
Memory: htop / CloudWatch
Database connections: SELECT count(*) FROM pg_stat_activity;
Response time: APM tool or logs
```

**When to deviate**: Your business has seasonal spikes (e.g., Black Friday). Scale 2–4 weeks before the spike.

---

### "Caching strategy?"

**Simple answer**: Indices first, caching second, everything else third.

**Why?** Indices are cheap (usually free in managed databases). Caching is complex (invalidation, staleness). Other stuff (sharding, redesign) costs months.

**Order**:
1. Add missing database indices (most bang for buck)
2. Optimize slow queries (N+1 queries, full table scans?)
3. Add Redis caching if queries still slow and repeated often
4. Only then redesign

---

### "When do we need CDN?"

**Simple answer**: When static assets are > 50% of your traffic or users are geographically distributed.

**Why?** CDN caches static files (JS, CSS, images) on servers near users, cutting latency and egress costs. But if static assets aren't your bottleneck, it's premature.

**When to deviate**: You're serving large videos or have users worldwide.

---

## Team & Process Questions

### "We can't ship features fast enough. What do we change?"

**Simple answer**: Hire before architecture (unless the architecture is genuinely in the way).

**Why?** Slow feature shipping is usually a team capacity problem, not a tech problem. Adding complexity (microservices, advanced patterns) often makes it worse because now you need to manage the complexity.

**What to check**:
- Does deployment take 30+ minutes? → Optimize CI/CD
- Are code reviews slow? → Clearer review process
- Is someone a bottleneck? → Hire or cross-train
- Is the architecture genuinely bad? → Refactor that part

---

### "Should we add tests?"

**Simple answer**: After you have users, tests become good ROI. Before that, ship.

**Why?** Until you have product-market fit, requirements change. Tests lock you in. Once you have users, preventing regressions is worth the investment.

**When to add them**:
- Critical paths (payment, authentication, core feature)
- Code you've had to fix twice
- Anything you're afraid to touch

---

### "How do we do code reviews?"

**Simple answer**: One approval, check for obvious bugs and style consistency. Ship it.

**Why?** Trying to catch everything in review slows shipping. Let the metrics (error rate, performance) tell you if something's wrong.

**What to actually check**:
- ✅ Correctness (does it solve the problem?)
- ✅ Security (are you storing passwords? checking permissions?)
- ✅ Tests (for critical code)
- ❌ Style (use a linter, not humans)
- ❌ Cleverness (boring code is fine)

---

## Tooling Questions

### "Which CSS library should we use?"

**Simple answer**: Tailwind. Use it unless you have a reason not to.

**Why?** Tailwind is fast to ship with, widely adopted, and you can build beautiful UIs with it. The mental model is simple. Almost every other choice takes longer.

**When to deviate**:
- You have a designer who hates Tailwind → Maybe Material UI
- You're shipping internal tools and want components instantly → Shadcn/ui
- You have extreme design constraints → Custom CSS + Tailwind

---

### "REST, GraphQL, or gRPC?"

**Simple answer**: REST. Use it unless multiple clients need different data shapes or you're optimizing for performance.

**Why?** REST is simple, cacheable, everyone understands it. GraphQL is powerful but adds complexity (resolver chains, caching, N+1 queries).

**When to deviate**:
- Multiple clients (web + mobile + third-party API) → GraphQL
- Internal service-to-service, extreme latency critical → gRPC
- Simple CRUD, one client → REST

---

### "Which backend framework?"

**Simple answer**: If you know Python, use FastAPI. If you know JavaScript, use Express or Next.js.

**Why?** Speed matters. The framework matters less than team fluency. One developer who knows Express well beats a team learning Rails.

**When to deviate**:
- Large team (20+) → NestJS (structure)
- You love elegance → Maybe Elixir/Phoenix (but learn it first)

---

## Deployment Questions

### "Where should we deploy?"

**Simple answer**: Vercel (frontend) + Fly.io or Railway (backend) for simplicity. AWS if you need specific services.

**Why?** Vercel and Fly/Railway handle DevOps for you (CI/CD, zero-downtime deploys, secret management). AWS gives you everything but you own it.

**When to deviate**:
- You're already AWS-native → Use AWS
- You need features AWS has → AWS
- You like managed simplicity → Fly/Railway

---

### "Do we need Docker?"

**Simple answer**: Yes, even for local dev. It guarantees "it works on my machine" translates to production.

**Why?** Docker eliminates the "but it works locally" problem. And most deploy platforms (Fly, AWS, Heroku) use Docker anyway.

**How**:
- Docker Compose for local dev (one `docker-compose up`)
- Push image to deployment platform

---

### "Kubernetes?"

**Simple answer**: Not until you have the team and scale to justify it.

**Why?** Kubernetes is operational overhead. It lets you orchestrate hundreds of containers, but most startups don't have hundreds of containers. Learn it by reading; implement it when pain is real.

**When to use**:
- Team > 10 with a dedicated DevOps engineer
- Running 50+ services
- Need multi-region failover

---

## Cost Questions

### "Our AWS bill is too high. Where do we cut?"

**Simple answer**: Check egress, idle databases, and log volume. 80% of bills are usually these three.

**Why?** Data transfer costs surprise everyone. A single forgotten RDS instance can cost $50/month. Log retention in Datadog can explode.

**Audit checklist**:
- [ ] AWS Cost Explorer: Is egress 20%+ of bill? → Cache more aggressively
- [ ] RDS console: Any instances with 0% CPU for a week? → Delete
- [ ] Datadog/Sentry: Monthly events × cost per event = too much? → Raise thresholds
- [ ] S3: Any old backups? → Lifecycle to Glacier

---

### "Should we use AWS Reserved Instances?"

**Simple answer**: Yes, if you have stable baseline load. 30% discount for 1-year commitment is easy money.

**Why?** Reserved Instances commit you to a certain usage level, but if you know you'll use it anyway, the discount is free.

**Example**:
```
Baseline: 3 EC2 instances always running
On-demand: $100/month
Reserved (1-year): $70/month
Savings: $30/month = $360/year (no risk if you're scaling)
```

---

### "We're profitable at our current scale. Should we optimize costs?"

**Simple answer**: Only if costs are > 20% of revenue and you've already grown as much as you can.

**Why?** Optimization takes engineering time. If you can invest that time in features that grow revenue faster, do that instead.

**When to optimize**:
- Costs are 30%+ of revenue
- Growth has plateaued
- You want to improve margins

---

## Data & Privacy Questions

### "Do we need to worry about GDPR?"

**Simple answer**: If you have any EU users, yes.

**Why?** GDPR fines are real (up to 4% of revenue). But most of it is just "don't be sketchy" (delete data on request, don't sell data, be transparent).

**Minimum checklist**:
- [ ] Privacy policy (states what data you collect, why, and how long you keep it)
- [ ] Data deletion (user can request and you delete it)
- [ ] No selling data
- [ ] Encrypt data in transit (HTTPS) and at rest (managed services do this)

**When to get a lawyer**: Raising money or hitting significant EU revenue.

---

### "Should we encrypt customer data?"

**Simple answer**: Data at rest is encrypted automatically by managed services (RDS, S3, etc.). Data in transit (HTTPS) is required.

**Why?** Managed databases encrypt by default. DIY encryption is hard and slow; just use managed services.

**When to add extra encryption**: Healthcare, financial, or other regulated industries. Get legal advice.

---

## Learning & Growth Questions

### "I don't know X (Kubernetes, GraphQL, gRPC, etc.). When do I learn it?"

**Simple answer**: When you hit a specific problem it solves. Not before.

**Why?** Learning without context wastes time. Learning in context (forced to solve a real problem) sticks and feels purposeful.

**Example**:
- Learn Kubernetes when: You have 20+ services and DevOps is a bottleneck
- Learn GraphQL when: Multiple clients need different data shapes
- Learn gRPC when: Service-to-service latency is the bottleneck

---

### "Should we invest in technical debt paydown?"

**Simple answer**: Yes, but only after shipping the feature that created it.

**Why?** Technical debt (messy code, missing tests, poor docs) slows you down only when you touch that code again. If that code is stable, leave it alone.

**When to pay it down**:
- You've touched this code 3+ times in a month
- New feature needs changes to this code
- Team keeps making the same mistakes in this area

---

### "How do I become better at system design?"

**Simple answer**: Ship systems, measure them, and evolve when they break.

**Why?** Theory is cheap. Practice (shipping, monitoring, refactoring) teaches judgment. Judgment is what separates senior engineers.

**What to practice**:
1. Build something (MVP with boring tech)
2. Measure it (add basic metrics)
3. Break it (scale to the edge)
4. Fix it (refactor based on what broke)
5. Repeat

---

## Decision-Making Meta

### "I'm unsure about this choice. How do I decide?"

**Framework**:
1. **What's the cost if I'm wrong?** (time to revert, damage to product, cost to fix)
2. **Can I measure it?** (will I know if I'm right or wrong?)
3. **Is there a boring option that works?** (prefer it)
4. **When do I revisit?** (don't let bad choices sit for 6 months)

**Example**: "Should we use DynamoDB?"
- Cost if wrong: $500+ to migrate off, major refactor
- Can we measure: Yes (query performance, cost)
- Boring option: PostgreSQL (proven, everyone knows it)
- Revisit: After 100K rows; if Postgres is slow, then DynamoDB

→ **Decision**: Start with PostgreSQL, measure, migrate if proven necessary.

---

### "My team disagrees. How do I decide?"

1. **Understand both sides** (what's the actual concern?)
2. **Measure if possible** (benchmark, proof of concept)
3. **If you can't measure, pick the boring option** (reversible choice)
4. **Set a timeline to reassess** (if wrong, you'll know)

**Example**: "Use microservices vs. monolith?"
- Understand: Microservices fan wants independent deploys; monolith advocate wants speed
- Measure: Can you deploy independently in a monolith? (modular code + feature flags yes)
- Boring option: Monolith with modular design
- Revisit: After 50K users, if deployment is the bottleneck, split services

→ **Decision**: Start with monolith, proven independent deployment works, revisit at scale.

---

## "I'm shipping fast but worried I'll regret this."

**When to worry**: ✅
- You're writing insecure code (storing passwords plaintext, no rate limiting)
- You're building something that can't be undone (delete data permanently without backup)
- You're making hardcoded assumptions that'll break at 10x scale (user IDs as sequential integers)

**When not to worry**: ❌
- Code isn't beautiful (fine, boring is good)
- You don't have tests (add them after launch)
- Infrastructure isn't "cloud native" (who cares)
- You're using a framework you'll maybe outgrow (learn it when you do)

**The rule**: Ship if it's correct and secure. Refactor if it's slow or broken. Never refactor something that works for aesthetics.
