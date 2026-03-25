# Tools & Libraries Reference

## Complete Decision Matrix

### Frontend Frameworks

| Tool | Best For | Complexity | Learning Curve |
|------|----------|-----------|-----------------|
| Next.js | Full-stack, SSR needed | Medium | 1-2 weeks |
| React + Vite | SPA, custom backend | Medium | 1 week |
| Svelte | Lightweight interactivity | Low | 3 days |
| Vue | Gentle ramp-up | Low | 1 week |
| Remix | Forms, progressive enhancement | Medium | 1-2 weeks |

**Recommendation**: Next.js for first project (includes backend, deployment, API routes).

---

### CSS Solutions

| Tool | Best For | How to Pick |
|------|----------|-----------|
| **Tailwind** | Any project | Default choice; 99% of cases |
| **Shadcn/ui** | Pre-built components | Want components + Tailwind |
| **Material UI** | Enterprise feel | Opinionated design, less flexibility |
| **Chakra UI** | Accessibility-first | Built-in a11y |
| **CSS Modules** | Legacy projects, custom | Only if Tailwind doesn't fit |
| **SCSS/LESS** | Complex styling | Avoid; use Tailwind instead |

**Recommendation**: Tailwind + shadcn/ui for 90% of projects.

**When to deviate**:
- Internal admin tool with no designers → Shadcn/ui
- Pixel-perfect design needed → Custom CSS + Tailwind
- Accessibility critical → Chakra UI

---

### Form Libraries

| Tool | Best For | Complexity |
|------|----------|-----------|
| **React Hook Form** | Any form | Minimal, very good |
| **Formik** | Complex forms | Medium overhead |
| **Zod + React Hook Form** | With validation | Best DX |
| **Remix Forms** | Server-driven forms | Good if on Remix |

**Recommendation**: React Hook Form + Zod.

```typescript
import { useForm } from "react-hook-form";
import { z } from "zod";

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

function LoginForm() {
  const { register, handleSubmit } = useForm<z.infer<typeof schema>>();
  return <form onSubmit={handleSubmit(onSubmit)}>{/* ... */}</form>;
}
```

---

### Backend Frameworks

| Tool | Language | Best For | Maturity |
|------|----------|----------|----------|
| **Express** | Node.js | Simple APIs | Very stable |
| **NestJS** | Node.js | Structured projects | Modern, opinionated |
| **Fastify** | Node.js | High performance | Solid |
| **FastAPI** | Python | Quick APIs | Modern, great DX |
| **Django** | Python | Full-stack, batteries included | Very stable |
| **Rails** | Ruby | Rapid dev | Older, still solid |

**Recommendation**: FastAPI (Python) or Express (Node.js) for startups.

**When to pick each**:
- FastAPI: You know Python, want speed
- Express: Team knows JS, want simplicity
- NestJS: Team is large (> 5), want structure

---

### Databases: Managed Services

| Service | DB Type | Best For | Cost at 100K users |
|---------|---------|----------|-------------------|
| **Supabase** | PostgreSQL | MVP → 10K users | Free–$100/mo |
| **PlanetScale** | MySQL | MVP → 100K users | Free–$50/mo |
| **Railway** | PostgreSQL | Any scale | $5–50/mo |
| **Fly** | PostgreSQL | Self-hosted + managed | $10–100/mo |
| **AWS RDS** | PostgreSQL/MySQL | 100K+ users | $100–500/mo |
| **DynamoDB** | NoSQL | Write-heavy | $50–500/mo (pay per request) |

**Recommendation**: Start with Supabase or PlanetScale (free, managed, simple). Migrate to RDS at 100K users.

---

### Caching & Sessions

| Tool | Use Case | Managed Option |
|------|----------|----------------|
| **Redis** | Cache, sessions, rate limiting | Upstash (serverless) or AWS ElastiCache |
| **Memcached** | Cache only | Rarely used; just use Redis |
| **Database sessions** | Sessions (slower) | Use Redis instead |

**Recommendation**: Upstash Redis for managed, no-ops cache.

---

### Message Queues

| Tool | Use Case | When Needed |
|------|----------|------------|
| **Bull** (Redis-backed) | Job processing in Node.js | After 10K users with async work |
| **Celery** (Python) | Async tasks in Python | After 10K users with async work |
| **SQS** (AWS) | Managed queue | 100K+ users, AWS shop |
| **RabbitMQ** | Complex routing | Advanced use case; rare for startups |
| **Kafka** | Event streaming | 100M+ events/sec; very rare |

**Recommendation**: Don't use until you have measured async work is a bottleneck. Then use Bull (simplest).

---

### Search

| Tool | Use Case | Complexity |
|------|----------|-----------|
| **Database LIKE** | Full-text search on < 1M rows | 0 (just use SQL) |
| **Elasticsearch** | Full-text search + analytics | High (operational overhead) |
| **Typesense** | Managed full-text search | Low (simpler than Elasticsearch) |
| **Meilisearch** | Instant search (UI) | Low (designed for ease) |
| **Algolia** | Managed search as service | Medium cost, zero ops |

**Recommendation**: Use database LIKE until 100K rows. Then Typesense or Meilisearch (avoid Elasticsearch until you have a search team).

---

### Real-Time Communication

| Tool | Use Case | Complexity |
|------|----------|-----------|
| **WebSockets (raw)** | Chat, live updates | Medium |
| **Socket.io** | WebSockets with fallback | Low (great DX) |
| **Pusher** | Managed WebSockets | Low, but costs money |
| **Firebase Realtime** | Real-time data sync | Low if all in Firebase |

**Recommendation**: Socket.io for self-hosted, Pusher if you want to avoid ops.

---

### Analytics & Metrics

| Tool | Type | Cost | Recommendation |
|------|------|------|-----------------|
| **Segment** | Event tracking | $$$ | Only at scale |
| **PostHog** | Product analytics | Self-hosted free | Best for startups |
| **Mixpanel** | User analytics | $$ | Works |
| **Plausible** | Privacy-first analytics | $ | Good for simple tracking |
| **Google Analytics** | Free basic | Free | Good for MVP |

**Recommendation**: Google Analytics for MVP, PostHog self-hosted at 10K users.

---

### Error Tracking

| Tool | Free Tier | Recommendation |
|------|-----------|-----------------|
| **Sentry** | 5K events/mo | Best in class |
| **Rollbar** | 5K events/mo | Good alternative |
| **Bugsnag** | 5K events/mo | Solid |
| **Airbrake** | Paid only | Overkill for startups |

**Recommendation**: Sentry (free tier covers you to 100K users).

---

### Deployment Platforms

| Platform | Best For | Cost | Complexity |
|----------|----------|------|-----------|
| **Vercel** | Next.js frontend | Free–$20/mo | Zero (just push) |
| **Fly.io** | Full-stack apps | Free–$50/mo | Low (Docker-based) |
| **Railway** | Full-stack apps | Free–$100/mo | Low (almost as easy as Vercel) |
| **Heroku** | Quick deployment | $50–500/mo | Low (expensive) |
| **AWS** | Everything | $100–1000s/mo | High |
| **DigitalOcean** | VMs + containers | $6–100/mo | Medium |

**Recommendation**: Vercel (frontend) + Fly.io (backend) for simplicity. Switch to AWS at scale.

---

### Container Orchestration

| Tool | When Needed | Complexity |
|------|------------|-----------|
| **Docker** | Always (even for local dev) | Low |
| **Docker Compose** | Local multi-container dev | Low |
| **Kubernetes** | 100K+ users, team > 10 | Very High |
| **ECS** (AWS) | 100K+ users, AWS shop | Medium |
| **Nomad** | Alternative to K8s | High |

**Recommendation**: Docker + Docker Compose for dev. Deploy on Fly.io (handles containers for you). Skip Kubernetes until pain is real.

---

### Email & Notifications

| Service | Type | Cost |
|---------|------|------|
| **SendGrid** | Transactional email | Free for first 100/day |
| **Mailgun** | Transactional email | Free for first 5K/mo |
| **Resend** | Email for developers | Free tier good |
| **Twilio** | SMS | $0.01–0.05 per SMS |
| **Firebase Cloud Messaging** | Push notifications | Free |
| **OneSignal** | Push + email | Free tier |

**Recommendation**: SendGrid for email, Firebase for push. Don't build these yourself.

---

### Testing Tools

| Tool | Type | Recommendation |
|------|------|-----------------|
| **Vitest** | Unit tests | Fast, modern |
| **Jest** | Unit tests | Industry standard |
| **React Testing Library** | Component tests | Best practices |
| **Cypress** | E2E tests | Great DX |
| **Playwright** | E2E tests | Faster than Cypress |
| **Postman** | API testing | Good for manual checks |

**Recommendation**: Vitest + React Testing Library for unit/component. Playwright for E2E.

---

## Framework Combinations (Quick Stacks)

### "I want to ship fast"
- Frontend: Next.js (includes React + routes)
- Backend: Built into Next.js (API routes)
- Database: Supabase (PostgreSQL, managed)
- Deployment: Vercel

**Time to deploy**: 30 min from zero.

### "I want flexibility"
- Frontend: React + Vite
- Backend: Express (Node) or FastAPI (Python)
- Database: PostgreSQL (Railway or Supabase)
- Deployment: Fly.io or Railway

**Time to deploy**: 2 hours.

### "I know Python"
- Frontend: Next.js or React
- Backend: FastAPI
- Database: PostgreSQL (Supabase)
- Deployment: Railway

**Time to deploy**: 1 hour.

### "I'm building an MVP that might pivot"
- Everything: Firebase (Firestore + Auth + Hosting)
- Frontend: React or Vue

**Time to deploy**: 20 min. Trade-off: Vendor lock-in.

---

## Library Pick Heuristics

When choosing a library:

1. **Is there a clear market leader?** (like Tailwind for CSS)
   → Use it. Don't be clever.

2. **Does it solve a real problem for your project?** 
   → If no, don't add it.

3. **Can you understand the code in 1 day?**
   → If no, skip it or read its source.

4. **Does the team know it?**
   → If no, add learning time to estimate.

5. **Is it maintained?** (Last commit in last 3 months?)
   → If no, pick something else.

**Your goal**: Boring, proven tools. The less clever your tech stack, the faster you ship.
