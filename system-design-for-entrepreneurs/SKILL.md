---
name: system-design-for-entrepreneurs
description: Business-first system design framework for pragmatic developers. Use when you need to reason through an architecture decision from first principles: start with business constraints, move to scale analysis, then pick tech. Covers decision frameworks, architecture stages, and cost/growth trade-offs. Pairs with suff1c1ent-arch1tecture as the implementation reference.
---

# System Design for Entrepreneurs

**Core principle**: Design for today's constraints and next order of magnitude only. Business impact, not technical elegance, drives decisions.

---

## Quick Decision Framework

When facing a design choice, ask these three questions in order:

1. **What's the business problem we're solving?** (revenue, user retention, speed-to-market, cost, reliability?)
2. **What scale do we need today?** (10 users? 1M requests/day? 100M rows?)
3. **What will break first when we grow 10x?** (response time? storage? cost? team capacity?)

Then design to fix problem #3, *nothing more*.

---

## Architecture Patterns by Stage

### Stage 1: MVP to 1K Users (Single VM)

**Infrastructure**: One beefy VM (vertical scaling goes far)
- 4-8 CPU, 16GB RAM handles surprising load
- Managed database (PlanetScale, Railway, Fly Postgres) — not your ops problem
- Simple object storage (S3, Cloudinary) for media
- No caching, no queues, no sharding yet

**Tech choices**:
- Pick boring, well-documented tools (Node.js, Python FastAPI, Next.js, React)
- Use relational databases unless you have *specific* non-relational needs
- Write code to solve *today's* problem, not hypothetical tomorrow's

**When to move on**: When you're consistently at 80% of your database or API's limits. Not before.

### Stage 2: 1K–100K Users (Early Scaling)

**Infrastructure**: 
- Split into backend (3–5 containers) + database (replicated)
- Add caching (Redis) if database queries are the bottleneck
- CDN (Cloudflare, Fastly) for static assets
- Feature flags to roll out cautiously

**Tech choices**:
- Upgrade to what you measured breaks, not what you predict
- Still avoid "cloud native" buzzwords unless pain is real (Kubernetes probably isn't needed)
- Start thinking about database queries and indices, not complexity

**When to move on**: When specific subsystems (auth, reporting, image processing) become performance drains.

### Stage 3: 100K+ Users (Scaling Out)

**Infrastructure**:
- Kubernetes or ECS (now justified by actual load)
- Database read replicas, eventual consistency where safe
- Message queues (RabbitMQ, SQS) for async work
- Monitoring and gradual deployments essential

**Tech choices**:
- Consider specialized tools only for known pain: Elasticsearch for search, DynamoDB for time-series, ClickHouse for analytics
- Still solve specific problems, not theoretical ones
- Budget now includes "maintain the system we built"

---

## Tooling & Library Decisions

Use this tree to choose libraries and frameworks:

### UI Components & Styling

**Problem**: Which UI library or CSS solution?

- **Is this internal tooling?** → Keep it dead simple (Tailwind + vanilla HTML or shadcn/ui)
  - **Speed matters?** → Tailwind + Headless UI (zero CSS writing)
  - **Design required?** → shadcn/ui or Material UI (pre-built, opinionated)
  
- **Is this user-facing product?** → Design quality affects retention
  - **Team has designers?** → Build with Tailwind + design system
  - **No designers, fast ship needed?** → shadcn/ui or Parity UI
  - **Custom design required?** → Tailwind + CSS Modules (own the styling layer)

### Tables & Data Display

- **10K rows or less, no complex filtering?** → `react-table` (headless, lightweight)
- **Complex sorting, filtering, pagination?** → `TanStack Table` or `Ag-Grid` (if budget allows)
- **Real-time updates, live collaboration?** → `TanStack Table` + server-side cursor pagination
- **Analytics/BI dashboards?** → `Apache ECharts` or `Recharts` (simple charts beat fancy ones)

### Charts & Visualizations

- **Business metrics dashboard?** → `Recharts` (React-native, simple, works)
- **Real-time streaming charts?** → `Chart.js` (canvas performance is better)
- **Complex multi-axis, custom interactions?** → `D3.js` (but this is 3 weeks of work; reconsider)
- **Maps with markers/layers?** → `Leaflet` + OpenStreetMap (proven, lightweight)

### Notifications & Alerts

- **In-app toast/banner?** → `react-toastify` (battle-tested, tiny)
- **Email + SMS?** → `SendGrid` (email) + `Twilio` (SMS); don't build this
- **Push notifications?** → `OneSignal` or `Firebase Cloud Messaging` (manage externally)
- **Real-time events across users?** → WebSockets + `Socket.io` or `Pusher` (managed is cheaper than ops)

### Authentication

- **Low friction needed?** → Social logins (Google, GitHub) via `NextAuth.js` or `Auth0`
- **Enterprise customers?** → `Auth0` or `Okta` (SAML/OIDC support, non-negotiable for contracts)
- **DIY token-based?** → JWT stored securely (httpOnly cookies), refresh token rotation
- **Solo dev, don't care about ops?** → Firebase Auth (Google manages the security)

---

## Database Choices

### When to use Relational (SQL)

- You have structured, interconnected data (users, posts, comments, likes)
- You need consistency (no double-charging users, race conditions unacceptable)
- You need transactions ("transfer money: debit A, credit B, both succeed or both fail")
- Queries: joins, filters, sorting

**Default pick**: PostgreSQL (via Render, Railway, Fly, or managed AWS). Start with one, replicate later.

### When to use NoSQL (Document / Key-Value)

- Data is denormalized or unstructured (logs, events, JSON blobs)
- You need extreme scale (write-heavy, millions of events/second)
- Consistency isn't critical (eventual is fine)

**Options**:
- **DynamoDB** if on AWS (pay per request, scales automatically)
- **MongoDB** if you like it (but most projects don't need it initially)
- **Redis** only for caching, sessions, or rate limiting (not as primary store)

### When to use Vector DBs

- You're doing AI retrieval: RAG (Retrieval-Augmented Generation), semantic search
- You have embeddings you need to search by similarity

**Options**:
- **Pinecone** (managed, simplest)
- **Weaviate** (self-hosted or managed)
- **Supabase pgvector** (if already on Postgres)

**Don't use it yet if**: You haven't shipped anything with LLMs. Start with simple retrieval, add vectors only if search quality demands it.

---

## Deployment & Hosting

### MVP Stage (< 10K users)

| Need | Pick |
|------|------|
| Backend + DB + Cache | **Fly.io** or **Railway** (simplest, good free tiers) |
| Next.js Frontend | **Vercel** (tight Next.js integration, free tier works) |
| Database | **PlanetScale** (MySQL), **Supabase** (Postgres), or managed on Fly |
| Storage | **Cloudinary** (images) or **S3** (if you want to own it) |

**Why**: Minimal ops, predictable cost, good DX.

### Early Scaling (10K–100K users)

| Need | Pick |
|------|------|
| Container hosting | **AWS ECS** (simpler than K8s) or **Fly.io** (if it still fits) |
| Database | **AWS RDS** (Postgres), **PlanetScale** (MySQL), or **Supabase** |
| Cache | **ElastiCache** (Redis on AWS) or **Upstash** (serverless Redis) |
| CDN | **CloudFlare** (always on, caches your site) |

**Why**: You want managed services to avoid ops burden.

### Scaling Out (100K+ users)

| Need | Pick |
|------|------|
| Orchestration | **Kubernetes** (EKS on AWS) or **AWS ECS** (still simpler) |
| Database | **RDS** with read replicas, **DynamoDB** for specific use cases |
| Message Queue | **SQS** or **RabbitMQ** for async work |
| Monitoring | **Datadog** or **New Relic** (Prometheus if DIY) |

---

## Red Flags: Don't Do This (Yet)

### Premature Patterns
- ❌ Microservices on day 1 (you'll own 10 deployment pipelines for 3 people)
- ❌ Kubernetes for "cloud native" brownie points (it's operational debt masquerading as sophistication)
- ❌ Event streaming (Kafka) without known scaling pain from events
- ❌ CQRS or event sourcing (advanced patterns; use after you've shipped something)

### Premature Tech
- ❌ NoSQL "because it scales" (wrong reason; SQL scales fine)
- ❌ GraphQL without a client team that needs it (REST is simpler)
- ❌ Complicated caching strategies before measuring actual bottlenecks
- ❌ Sharding before database is genuinely maxed out

### Premature Learning
- ❌ Deep-diving Kubernetes, gRPC, distributed tracing *before* you need them
- ❌ Optimizing code you haven't profiled
- ❌ Building "reusable" abstraction layers for code you've only written once

---

## Refactoring & Evolution

Your system will break in one of these ways. When it does, refactor *that thing* only:

### Response Time Too Slow
1. Profile first (don't guess)
2. Fix O(N²) loops
3. Add database indices
4. Cache if queries are repeated
5. Split into async jobs if safe
6. Only then consider database redesign

### Storage Too Large
1. Archive old data (you don't need 5 years of logs online)
2. Compress storage (GZIP, WEBP for images)
3. Only then: shard the database

### Costs Too High
1. **Find the leak** (often forgotten VMs, unused RDS instances, egress costs)
2. Right-size instances (don't pay for 16 cores if you use 2)
3. Move to cheaper storage class (S3 Glacier for cold data)
4. Only then: architectural changes (DynamoDB pay-per-request, etc.)

### Team Can't Keep Up
1. **Hire, not architecture** (more bodies, not more complexity)
2. Modularize carefully (clear interfaces, explicit contracts)
3. Async work queues if blocking is the pain
4. Only then: consider microservices (and you'll probably regret it)

---

## Decision Tree Example: "Should We Go Serverless?"

```
Q: Is your API latency-sensitive (< 100ms matter)?
├─ YES → Don't use serverless (cold starts are 100–500ms)
│       Use: Containers on ECS, Kubernetes, or Railway
└─ NO → Does your load vary wildly (10 requests/sec → 10k/sec)?
        ├─ YES → Serverless (Lambda, Cloud Functions) makes sense
        │       Reason: Auto-scaling is baked in, pay for actual compute
        └─ NO → Stick with containers
                Reason: Simpler ops, predictable costs, better DX

Final check: Is anyone on the team comfortable managing Lambda?
├─ NO → Don't use it (hidden complexity kills teams)
└─ YES → Go for it if the above tree says yes
```

---

## Metrics That Matter

Before making a big architecture call, measure these:

| Metric | How to Measure | Why It Matters |
|--------|----------------|----------------|
| **Response time (p99)** | APM tool or server logs | User experience; anything > 1s feels broken |
| **Database query time** | Database slow query logs | Identifies bottleneck fastest |
| **Error rate** | APM or error tracking | Silent failures (> 0.1% is bad) |
| **Cost per user** | Total infra cost ÷ users | Know your unit economics |
| **Deployment time** | Measure or just notice | Long deploys slow down shipping |
| **MTTR** (time to recovery) | Alert logs | When stuff breaks, how long are you down? |

**Rule**: Don't optimize what you haven't measured. Guessing wrong is expensive.

---

## Business Context Questions

Before designing, ask the business:

1. **What's the #1 thing we need to win this year?** (user growth? cost reduction? reliability? speed?)
2. **How much is a 1-hour outage worth in lost revenue?** (tells you how much to spend on redundancy)
3. **Do we have customers in different regions?** (tells you if you need multi-region)
4. **What's our monthly burn rate?** (tells you the infrastructure budget)
5. **When do we expect 10x growth?** (tells you your refactor timeline)

If they can't answer these, you're not ready to design yet—go talk to them first.

---

## References

- For deep-dive on scaling decisions, see [decisions.md](decisions.md)
- For library/framework detailed comparison, see [tools-reference.md](tools-reference.md)
- For infrastructure cost calculators, see [cost-examples.md](cost-examples.md)
