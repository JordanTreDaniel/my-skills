---
name: suff1c1ent-arch1tecture
description: Infrastructure and deployment reference for pragmatic developers. Use as a rapid lookup for "what infrastructure/tools do I need at this scale?" Covers infrastructure stages (MVP→traction→PMF→scaling), tool choices by category (UI, database, auth, notifications, hosting), and anti-patterns to avoid. Pairs with system-design-for-entrepreneurs for business-first reasoning.
---

# Suff1c1ent Arch1tecture

**Core philosophy**: Good enough for today. Simple is complicated enough at scale.

Design for the next order of magnitude only. Business impact beats technical elegance every time.

---

## Quick Decision Framework

When facing any architecture choice, answer in this order:

1. **What business problem are we solving?** (revenue, retention, speed-to-market, cost)
2. **What scale do we need TODAY?** (100 users? 10K requests/day? Not hypothetical millions)
3. **What will break first at 10x?** (database? API latency? team capacity?)

Design to fix #3. Nothing more.

---

## Scale Stages & Infrastructure

### Stage 0: MVP (0–100 users)
**One VM. One database. No containers.**
- 4 CPU / 16GB RAM VM (Hetzner, DigitalOcean, AWS EC2 t3.large)
- Managed Postgres (Supabase, Railway, PlanetScale)
- No caching. No queues. No Kubernetes.
- Ship features, not infrastructure.

**Move on when**: Consistently at 70%+ resource utilization.

### Stage 1: Early Traction (100–10K users)
**Vertical scaling still works. Don't horizontal yet.**
- Same architecture, bigger VM (8 CPU / 32GB RAM)
- Database read replica if queries are slow (measure first)
- CDN for static assets (Cloudflare free tier)
- Maybe Redis for sessions, not caching yet

**Move on when**: Single VM can't handle load with 80%+ headroom.

### Stage 2: Product-Market Fit (10K–100K users)
**Now you split services. Still not microservices.**
- Backend containers: 2-3 instances behind load balancer
- Database: Primary + read replica (AWS RDS, managed)
- Redis: Now for caching query results that are actually slow
- Feature flags for gradual rollout (LaunchDarkly or PostHog)

**Move on when**: A specific subsystem (auth, search, exports) becomes the bottleneck.

### Stage 3: Scaling Out (100K+ users)
**Only now does "cloud native" make sense.**
- Kubernetes (EKS/GKE) OR ECS if team is small
- Database sharding OR specialized stores (DynamoDB for time-series)
- Message queues for async work (SQS, RabbitMQ)
- Monitoring: DataDog or New Relic (pay for visibility now)

---

## Library & Tool Selection

### UI / Styling

| Need | Choice | Why |
|------|--------|-----|
| Fast internal tool | Tailwind + vanilla HTML | Zero abstraction overhead |
| Product with designers | Tailwind + design tokens | Control + consistency |
| No designers, ship fast | shadcn/ui or Chakra UI | Pre-built, accessible |
| Custom everything | CSS Modules + PostCSS | Own the stack |

**Rule**: Pick boring tools. Your users don't care about your CSS architecture.

### Tables & Data

| Scale | Tool |
|-------|------|
| < 1K rows | Plain HTML table or `react-table` |
| 1K–10K rows | TanStack Table (client-side sort/filter) |
| 10K+ rows | Server-side pagination + TanStack Table |
| Real-time updates | Server-side cursor pagination + websockets |
| Complex analytics | Apache ECharts (performant canvas) |

### Charts

| Need | Tool |
|------|------|
| Simple metrics | Recharts (React-native, easy) |
| Real-time streaming | Chart.js (better canvas perf) |
| Complex custom viz | D3.js (but: 2-3 weeks of work) |
| Maps | Leaflet + OpenStreetMap |

### Auth

| Use case | Solution |
|----------|----------|
| Side project / MVP | NextAuth.js (social only) |
| SaaS product | Auth0, Clerk, or Supabase Auth |
| Enterprise (SAML/SSO) | Auth0 or Okta (non-negotiable for contracts) |
| Don't want to think about it | Firebase Auth |

### Notifications

| Type | Solution |
|------|----------|
| In-app toast | react-hot-toast (1KB, perfect) |
| Email | SendGrid or Postmark (don't build SMTP) |
| SMS | Twilio |
| Push | OneSignal or Firebase FCM |
| Real-time events | WebSockets (Socket.io) or Pusher (managed) |

---

## Database Decisions

### Use PostgreSQL unless...

Default to Postgres. It's sufficient for 95% of use cases.

**You need NoSQL when**:
- Write volume > 10K events/second (measure first)
- Data is unstructured (logs, events, JSON blobs)
- Eventual consistency is acceptable
- You have a specific partition/shard strategy in mind

**Options**: DynamoDB (AWS), MongoDB (if you must), ScyllaDB (Cassandra-compatible, fast)

### Use Redis for...

- Sessions (fast, ephemeral)
- Rate limiting (atomic operations)
- Caching query results (only after measuring slow queries)
- NOT as primary data store

### Use Vector DBs when...

- Building RAG with LLMs
- Semantic search is core feature
- You've already shipped and need better retrieval

**Options**: Pinecone (managed), Weaviate, or pgvector (if already on Postgres)

---

## Deployment & Hosting

### MVP Stage

| Service | Pick |
|---------|------|
| Full-stack app | Railway, Fly.io, or Render |
| Next.js frontend | Vercel |
| Database | Supabase, PlanetScale, or managed on Fly |
| File storage | Cloudinary (images) or S3 |

**Why**: Push to git → deployed. No YAML engineering.

### Scaling Stage

| Service | Pick |
|---------|------|
| Containers | AWS ECS (simpler than K8s) or stick with Fly |
| Database | AWS RDS, Google Cloud SQL |
| Cache | ElastiCache (Redis) or Upstash |
| CDN | CloudFlare (always, free tier is enough) |

---

## The Anti-Patterns List

### Don't do these on day 1

- ❌ **Microservices** (you'll own 10 deploy pipelines for 3 people)
- ❌ **Kubernetes** for "experience" (it's ops debt masquerading as sophistication)
- ❌ **Event sourcing / CQRS** (advanced patterns for advanced problems)
- ❌ **GraphQL** without a client team that needs it (REST is simpler)
- ❌ **NoSQL "because it scales"** (SQL scales further than you think)
- ❌ **Caching before measuring** (cache invalidation is hard, prove you need it)
- ❌ **Sharding before maxing out vertical** (120 CPU VMs exist)

### Don't optimize what you haven't measured

1. Profile first (Chrome DevTools, APM, slow query logs)
2. Fix O(N²) loops
3. Add database indices
4. Cache only repeated queries
5. Async jobs for heavy work
6. Only THEN redesign

---

## The Business Context

Before designing, understand:

1. **What's the #1 priority this year?** (growth? cost? reliability? speed?)
2. **What's a 1-hour outage worth?** (tells you redundancy budget)
3. **Monthly burn rate?** (tells you infrastructure budget)
4. **When do we expect 10x?** (tells you refactor timeline)

**Can't answer these?** Go talk to stakeholders first. You're not ready to design.

### Translate technical to business

| Technical Concern | Business Translation |
|-------------------|----------------------|
| "We need caching" | "Page load time affects conversion by X%" |
| "We need K8s" | "Deployment time blocks Y features/month" |
| "We need microservices" | "Team coordination blocks Z releases/week" |
| "We need a rewrite" | "Technical debt costs $X in velocity loss" |

---

## Metrics That Matter

Measure before deciding:

| Metric | Target | Tool |
|--------|--------|------|
| API response (p99) | < 500ms | APM or logs |
| Database query time | < 100ms | Slow query log |
| Error rate | < 0.1% | Sentry, Rollbar |
| Cost per user | Know your number | Cloud bill ÷ users |
| Deployment time | < 10 minutes | CI/CD logs |
| Time to recovery | < 30 minutes | Incident logs |

---

## The Migrations Truth

**Migrations are part of the job. They're not failures.**

- You WILL migrate databases
- You WILL rewrite services
- You WILL sunset old architectures

Design for evolvability, not permanence:
- Clear interfaces between components
- Feature flags for gradual rollout
- Data formats that can extend (don't break existing)
- Incremental deploys, not big bangs

---

## Decision Trees

### "Should we use serverless?"

```
Latency-sensitive (< 100ms matters)?
├─ YES → Containers (ECS, Fly, K8s)
└─ NO  → Load varies wildly (10 → 10K req/s)?
         ├─ YES → Serverless (Lambda) makes sense
         └─ NO  → Stick with containers (simpler)
```

### "Should we add a queue?"

```
Users waiting on slow operations (exports, emails, images)?
├─ YES → Add queue (Bull, SQS, RabbitMQ)
└─ NO  → Keep synchronous (simpler to reason about)
```

### "Should we use a separate service?"

```
Does it share the database?
├─ YES → Same codebase, separate route
└─ NO  → Different deployment cadence needed?
         ├─ YES → Separate service
         └─ NO  → Same codebase, different module
```

---

## References

- For cost calculations by stage, see [cost-models.md](cost-models.md)
- For library deep-dives, see [tool-comparisons.md](tool-comparisons.md)
- For migration patterns, see [evolution-patterns.md](evolution-patterns.md)
