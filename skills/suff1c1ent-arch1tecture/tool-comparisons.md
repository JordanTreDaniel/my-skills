# Tool Comparison Reference

## Frontend Frameworks

### React Ecosystem

| Tool | Best For | Learning Curve | Bundle Size |
|------|----------|----------------|-------------|
| **Next.js** | Full-stack React, SSR/SSG | Medium | ~100KB |
| **Remix** | Web standards, forms | Medium | ~80KB |
| **Vite + React** | SPA, client-side only | Low | ~40KB |
| **Astro** | Content sites, partial hydration | Low | 0KB (by default) |

**Verdict**: Start with Next.js (Vercel). Move to Remix if forms/routes get complex. Use Astro for marketing sites.

### Backend Frameworks

| Language | Framework | Best For |
|----------|-----------|----------|
| **Node.js** | Express | APIs, simple CRUD |
| **Node.js** | Fastify | High-throughput APIs |
| **Node.js** | NestJS | Enterprise, large teams |
| **Python** | FastAPI | APIs, data pipelines |
| **Python** | Django | Full-stack, admin-heavy |
| **Go** | Gin / Echo | Microservices, high perf |
| **Go** | stdlib + Chi | APIs, minimal abstraction |

**Verdict**: Node/Fastify for solo devs. Python/FastAPI for data-heavy. Go when you need every last CPU cycle.

## Databases

### SQL Options

| Database | Best For | Managed Options |
|----------|----------|-----------------|
| **PostgreSQL** | Default choice | RDS, Supabase, Railway |
| **MySQL** | Legacy systems | RDS, PlanetScale |
| **SQLite** | Single-tenant apps, embedded | Litestream (backups) |

### NoSQL Options

| Database | Best For | When to Use |
|----------|----------|-------------|
| **DynamoDB** | AWS, massive scale, predictable cost | > 10K writes/sec |
| **MongoDB** | Flexible schemas, document storage | Team knows it |
| **Redis** | Caching, sessions, real-time | Always add this |
| **ClickHouse** | Analytics, time-series | Big data queries |

## Message Queues

| Tool | Best For | Complexity |
|------|----------|------------|
| **Bull (Redis)** | Node.js apps, simple | Low |
| **BullMQ** | Bull but modern | Low |
| **SQS** | AWS ecosystem | Low (managed) |
| **RabbitMQ** | Complex routing, features | Medium |
| **Kafka** | Event streaming, log aggregation | High |

**Verdict**: Start with Bull/BullMQ. Move to SQS if on AWS. Kafka only if you're logging millions of events/sec.

## Monitoring & Observability

| Tool | Best For | Cost |
|------|----------|------|
| **Sentry** | Error tracking | Free tier generous |
| **LogRocket** | Session replay + logs | $$ |
| **Datadog** | Full observability | $$$ |
| **New Relic** | APM, infrastructure | $$$ |
| **Grafana + Prometheus** | Self-hosted, cheap | Setup cost |

**Verdict**: Sentry (free) → Datadog (when revenue justifies).

## Authentication Providers

| Provider | Best For | Price |
|----------|----------|-------|
| **Clerk** | Modern SaaS, great DX | $25/mo starter |
| **Auth0** | Enterprise, SAML/OIDC | $23/mo + enterprise |
| **Supabase Auth** | Tight Supabase integration | Free tier generous |
| **Firebase Auth** | Google ecosystem | Free tier generous |
| **NextAuth.js** | Self-hosted, social only | Free (you host) |

**Verdict**: Clerk for new SaaS. Auth0 for enterprise. Supabase if already using Supabase.
