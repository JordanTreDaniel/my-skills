# Deep-Dive Decision Points

## Monolith vs. Microservices

### Monolith (Recommended for MVP → 100K users)

**Pros:**
- Single deployment pipeline, one thing to track
- Shared memory/data layer = no distributed complexity
- Easier debugging (stack traces show the whole flow)
- Team cohesion: one codebase everyone understands

**Cons:**
- If one service is slow, whole app feels slow
- One team can't own one feature end-to-end (deployment coupling)
- Language/framework locked in

**When to stay monolithic:**
- Team < 20 people
- Feature shipping speed matters more than independence
- Any one service isn't 80% of your load
- You haven't hit a specific team bottleneck

**Monolith structure that scales:**
```
api/
  ├── auth/           (auth service, but in same process)
  ├── users/          (user service, but in same process)
  ├── billing/        (billing service, but in same process)
  └── shared/         (database, cache, logging)
```

You can deploy this one service across 5 containers. The "monolith" is still fast.

---

### Microservices (Consider only after 100K users + team > 15)

**Trigger to split**: You have a team that can own an entire service top-to-bottom *and* the service is causing bottlenecks.

Example: At GitHub scale, they split Actions into separate services because:
- Massive traffic (hundreds of millions of requests/sec)
- Team of 10+ owns Actions; can move independently
- Actions' database doesn't share schema with rest of GitHub

**Common mistake**: Splitting before these conditions are true costs 3–6 months of ops debt.

---

## Caching Strategy

### Layer 1: Database Indices

Do this first. Always.

```sql
-- Before caching, ensure you have:
CREATE INDEX ON users(email);  -- for lookups
CREATE INDEX ON posts(user_id, created_at);  -- for filtering + sorting
```

9 times out of 10, slow response = missing index.

---

### Layer 2: Application Cache (Redis)

Use Redis when:
- Same query runs 100+ times/second
- Query is slow (> 100ms)
- Data changes rarely (cache invalidation is tractable)

Example:
```typescript
async function getUser(id: string) {
  const cached = await redis.get(`user:${id}`);
  if (cached) return JSON.parse(cached);
  
  const user = await db.users.findOne(id);
  await redis.set(`user:${id}`, JSON.stringify(user), "EX", 3600);  // 1h TTL
  return user;
}
```

**Don't cache:**
- User account settings (invalidation is hard)
- Financial transactions (must be consistent)
- Real-time data (blog comments, notifications)

---

### Layer 3: CDN

Use for:
- Static assets (JS bundles, CSS, images)
- Read-heavy, non-personalized endpoints (product catalog, public API)

CloudFlare caches everything by default; Vercel caches Next.js pages. Almost free.

---

### Layer 4: Client-Side Cache

Use browser cache headers:
```javascript
// Next.js example
export const revalidate = 3600;  // Cache page for 1 hour
```

But don't over-optimize here. Most bandwidth is static assets (cached by CDN automatically).

---

## Database Migration Path

### You're Here (PostgreSQL, 100K rows, single instance)

- Queries run fast
- Cost is $15/month
- Team understands SQL

### You're Here (PostgreSQL, 1M rows, slow on joins)

**Fix it**: Add indices, optimize queries. Don't move databases yet.

If indices don't help:
1. **Read replicas**: Point expensive reports to replica
2. **Denormalize**: Pre-compute aggregates, store alongside user record
3. **Archive**: Move old data to cold storage (S3)

### You're Here (PostgreSQL, 100M rows, still 90% reads)

**Stay on PostgreSQL**. Use read replicas.

```sql
-- PostgreSQL can handle 100M rows fine if:
CREATE INDEX ON events(user_id, created_at DESC);
-- And you query:
SELECT * FROM events WHERE user_id = ? ORDER BY created_at DESC LIMIT 100;
```

### You're Here (PostgreSQL, write-heavy, 1M rows/sec)

Now consider non-relational:
- **DynamoDB**: AWS, pay-per-request, scales infinitely
- **Cassandra**: Open-source, but operational complexity
- **MongoDB**: Time-series data, easier than Postgres for this

But honestly? GitHub handles millions of requests/sec on PostgreSQL. The problem isn't usually the database.

---

## API Design Trade-offs

### REST (Recommended)

**Pros:**
- Simple mental model (resources, HTTP verbs)
- Works in any language/framework
- Easy to cache (GET is cacheable)

**Cons:**
- Over-fetching (you get fields you don't need)
- Under-fetching (you need 10 endpoints to render one page)
- Versioning gets messy (/v1/, /v2/)

**Use for**: Public APIs, simple CRUD, anything where the client is external.

---

### GraphQL

**Pros:**
- Client asks for exactly what it needs
- One endpoint (no versioning hell)
- Built-in introspection (great DX)

**Cons:**
- Server-side complexity (resolver chains, N+1 queries)
- Caching is harder (one endpoint, not REST's simple GET caching)
- Overkill if you only have one client
- Learning curve (both build and debug)

**Use for**: Multiple clients (web + mobile) that need different data shapes. Otherwise, avoid.

---

### gRPC / Protocol Buffers

**Pros:**
- Extremely fast (binary, not JSON)
- Schema validation built-in

**Cons:**
- Can't call from browsers directly (need proxy)
- Tooling less mature than REST
- Overkill for most products

**Use for**: Internal service-to-service communication at massive scale. Not for MVP.

---

## Feature Flags & Gradual Deployments

### Why You Need This at Scale

At GitHub, a bug in Actions doesn't break Git. They ship features to 1% of traffic first, measure, then 10%, then 100%.

### Implementation (Dead Simple)

```typescript
async function isFeatureEnabled(userId: string, featureName: string): Promise<boolean> {
  // Hit a config service or database
  const config = await redis.get(`feature:${featureName}`);
  const rollout = JSON.parse(config);
  
  // Hash user ID to 0–100
  const hash = hashUserId(userId) % 100;
  return hash < rollout.percentage;
}

// Usage:
if (await isFeatureEnabled(userId, "new_dashboard")) {
  return renderNewDashboard();
} else {
  return renderOldDashboard();
}
```

**Tools:**
- DIY: Simple Redis + hash function (what GitHub uses internally)
- Managed: LaunchDarkly, Unleash, PostHog (easier, costs money)

---

## Security Considerations

### Data in Transit

- HTTPS everywhere (cost: $0, handled by Vercel/Railway)
- Certificate renewal: automatic (Certbot, Vercel handles it)

### Data at Rest

- Database: All managed services encrypt by default (RDS, Supabase, etc.)
- Secrets: Use environment variables, not in code
  - Never commit `.env`
  - Managed services (Railway, Vercel) handle secret rotation

### Authentication

- For users: Use JWT (stateless) or sessions (simpler to invalidate)
- For APIs: API keys or OAuth2
- Rate limiting: CloudFlare does this for free

### Common Mistakes

- ❌ Storing passwords (use bcrypt + salt, never hash with MD5)
- ❌ Logging sensitive data (credit cards, tokens, passwords)
- ❌ Allowing SQL injection (use parameterized queries always)
- ❌ Trusting client input (validate on backend)

### Compliance

- GDPR: Right to be forgotten, data portability (harder once you're big)
- CCPA: Similar to GDPR
- PCI-DSS: If you handle credit cards, use Stripe/Adyen (don't store them yourself)

**For MVP**: Focus on not losing data, not encryption. Encryption happens naturally.

---

## Observability (Logging, Metrics, Traces)

### Early Stage (< 10K users)

- Basic error tracking: **Sentry** (free tier covers you)
- Basic metrics: Build into logs (print to stdout, Docker captures it)

### Early Growth (10K–100K users)

- Structured logging: **Pino** (Node.js) or **loguru** (Python) — log as JSON
- Metrics: **Prometheus** (open-source, self-hosted) or **DataDog** (managed)
- Traces: Not yet (only add when response time is the problem)

### Scaling (100K+ users)

- All three: Logging + Metrics + Traces unified
- Tools: **DataDog**, **New Relic**, **Honeycomb** (pay, but worth it)
- Internal tools: Slack integration, on-call paging (PagerDuty)

### Simple Metrics to Track

```
- Response time (p50, p95, p99)
- Error rate (% of requests that error)
- Database query time (slow query log)
- CPU/memory (right-size your instances)
- Cost per user (total infra cost ÷ active users)
```

If you can't measure it, you're flying blind. Add 1 metric at a time.

---

## Testing Strategy

### Unit Tests (Test Individual Functions)

```typescript
// Good ROI: Functions with business logic
test("discountCalculator applies 10% for premium users", () => {
  expect(discountCalculator(100, "premium")).toBe(90);
});

// Low ROI: Just calling database
test("getUser queries database", async () => {
  // This test teaches nothing
  const user = await getUser(1);
  expect(user.name).toBe("Alice");
});
```

### Integration Tests (Test Services Together)

```typescript
// Good: Realistic flow
test("user signup creates user, sends email, logs event", async () => {
  const response = await POST("/api/signup", { email: "alice@example.com" });
  expect(response.status).toBe(201);
  expect(emailSent).toHaveBeenCalled();
});
```

### E2E Tests (Test User Workflows)

- Only for critical paths: signup, payment, main feature
- Don't test every button click (too slow, too flaky)
- Example: Playwright or Cypress for "user signs up, creates project, invites team"

### Rule of Thumb

- 70% integration tests (realistic flows)
- 20% unit tests (business logic, edge cases)
- 10% E2E tests (critical user journeys)

**For MVP**: Don't obsess over tests. Get users first, add tests when you're fixing bugs.
