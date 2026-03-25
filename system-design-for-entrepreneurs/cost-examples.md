# Real Cost Examples & Calculators

## Early Stage: MVP with 100–1K Users

### Tech Stack
- Frontend: Vercel (Next.js)
- Backend: Fly.io (Node/Python)
- Database: Supabase (PostgreSQL)
- Cache: None yet
- Storage: Cloudinary

### Monthly Costs
```
Vercel:        $0 (free tier)
Fly.io:        $0–5 (free tier covers small app)
Supabase:      $0 (free tier: 1GB storage, 50K monthly active users)
Cloudinary:    $0 (free tier: 25GB/month)
Domain:        ~$12
Monitoring:    $0 (Sentry free: 5K events/month)
─────────────
Total:         ~$12/month
```

**Why it works**: Free tiers are absurdly generous for early projects.

---

## Growth Stage: 10K–100K Users

### Tech Stack
- Frontend: Vercel
- Backend: Fly.io or Railway
- Database: Supabase → RDS PostgreSQL (as you scale)
- Cache: Upstash Redis
- Storage: S3
- Monitoring: Sentry + basic APM

### Monthly Costs (at 50K users)
```
Vercel:         $20 (ISR, edge functions)
Fly.io:         $30–50 (3 containers, shared Postgres)
Supabase:       $25 (scaling; still within free if you're lucky)
Upstash Redis:  $10 (serverless, minimal use)
S3 storage:     ~$5 (10GB)
S3 egress:      ~$20 (depends on usage; can be 50% of bill)
Sentry:         $29 (cheapest paid plan)
Domain:         $12
─────────────
Total:          ~$150–200/month
```

**What changed**:
- Moved to paid Fly/Railway for redundancy
- Added Redis for caching
- Moved to S3 for more storage
- Paid Sentry for better error tracking

**Cost per user**: $3–4/month

---

## Scaling: 100K–1M Users

### Tech Stack
- Frontend: Vercel + CloudFlare
- Backend: AWS ECS or Kubernetes
- Database: AWS RDS (read replicas)
- Cache: ElastiCache Redis
- Storage: S3 (with Glacier for cold data)
- Monitoring: DataDog or New Relic
- CDN: CloudFlare or CloudFront

### Monthly Costs (at 500K users)
```
Vercel:          $100 (high ISR usage)
CloudFlare:      $20 (pro plan for caching)
ECS/Containers:  $300–500 (multiple availability zones)
RDS:             $200–500 (read replicas)
ElastiCache:     $100 (Redis cluster)
S3:              $200 (100GB storage + egress)
DataDog:         $300 (APM + logging)
DNS/Domain:      $50
─────────────
Total:           ~$1,200–1,500/month
```

**Cost per user**: $2.40–3/month (economies of scale help)

**Key insight**: Egress costs are brutal. CloudFlare caching saves 50%+ here.

---

## Scaling Enterprise: 1M+ Users

### Tech Stack
Everything becomes custom, but rough numbers:

```
Compute:        $2,000–5,000
Databases:      $1,000–3,000
Caching:        $500–1,000
CDN/Egress:     $500–2,000
Monitoring:     $500–1,000
Disaster recovery: $1,000+
─────────────
Total:          ~$5,000–15,000/month
```

**Cost per user**: $5–15/month (⚠️ costs scale with business, not users)

At this scale, your infra bill is 5–10% of revenue. If you're profitable, this is fine.

---

## Common Cost Drains (Watch Out)

### 1. Database Egress ($$$)

**The trap**: RDS charges for data leaving AWS region.

```
1GB/day egress = $0.02 × 30 = $0.60
But at scale:
100GB/day egress = $60/day = $1,800/month
```

**How to avoid**:
- Keep compute and database in same region
- Use CDN to cache (CloudFlare caches everything)
- Don't stream 100MB files to user browsers (use signed S3 URLs instead)

### 2. Unused Instances

**The trap**: Spin up an RDS instance for dev, forget about it.

```
t3.medium RDS: $50/month
× 5 forgotten instances = $250/month you're not using
```

**How to avoid**: Monthly audit of running instances (takes 15 min).

### 3. Image Resizing / Transform Costs

**The trap**: CDN or serverless function resizes every image, charges per transform.

```
Cloudinary free: 25GB
Paying: $0.10 per 1000 transforms
100K transforms/month = $10 ✓
1M transforms/month = $100 ✓
10M transforms/month = $1,000 ✗
```

**How to avoid**: Resize on upload (not per-request), cache aggressively.

### 4. DynamoDB On-Demand Pricing

**The trap**: Pay-per-request sounds great until you have a traffic spike.

```
1M reads/month = ~$0.25
1M writes/month = ~$1.25
But 10x spike:
10M writes/month = $12.50
```

**How to avoid**: Use provisioned capacity if your load is predictable, on-demand if it's not (trade-off: higher baseline cost).

---

## Cost Optimization Checklist

### Monthly ($12 cost from MVP)

- [ ] Review RDS instance size (right-size, don't over-provision)
- [ ] Check S3 storage class (archive old data to Glacier)
- [ ] Verify all containers are running (no zombie instances)

### Quarterly ($150+ cost from growth)

- [ ] Analyze CloudFront/egress (biggest cost usually)
- [ ] Check database slow queries (bad queries = more compute)
- [ ] Audit feature flag usage (remove stale flags)
- [ ] Review log volume (Datadog/Sentry charges per event)

### Annually ($1,000+ cost from scaling)

- [ ] Reserved instances (AWS gives 30% discount for 1-year commitment)
- [ ] Savings plans (similar to reserved, more flexible)
- [ ] Evaluate new regions (lower cost in some geographies)

---

## When to Accept Higher Costs

### Worth It ✅

- **Managed services over DIY**: $50/mo Supabase vs. $500/mo for one engineer to manage Postgres
- **Reliability**: $100/mo extra for multi-region vs. 1% downtime = lost revenue
- **Developer velocity**: Using Rails (fast to ship) vs. Go (you'll build 3x more tools)

### Not Worth It ❌

- **Premature scale**: $10K/mo Kubernetes for team of 5 shipping slowly
- **Vanity infrastructure**: Microservices because they look cool
- **Over-instrumenting**: Datadog on every function call (ship first, optimize after)

---

## Revenue-Cost Alignment

### Example: SaaS Product

```
Pricing: $29/user/month
Revenue per user: $29

Cost per user: $2–5
Gross margin: 83–93%
Runway: Forever (costs < revenue immediately)
```

**Good**: You can afford to grow.

```
Pricing: $9/user/month
Cost per user: $4
Gross margin: 56%
Problem: At scale, fixed costs (team) dominate
```

**Tighter**: Need scale to be viable.

### Example: Ad-Supported Product

```
1M users, $2 CPM (cost per 1000 impressions)
Monthly impressions: 100M
Monthly revenue: $200K
Monthly infra cost: $10K
Gross margin: 95%
```

**Good**: High-volume, low-cost infra.

---

## Calculator: Estimate Your Costs

Given:
- Backend framework (Node / Python / other): affects compute
- Database size (users, data): affects storage + queries
- Traffic (requests/sec): affects compute + egress
- Team size: affects maintenance

**Quick calculator** (rough, for MVP):

```
Backend compute:      N containers × $10/mo = $10N
Database:             (GB size / 10) × $0.50 = depends on size
Cache (if needed):    $10–20/mo
Storage:              (GB / 100) × $1 = minimal
Monitoring:           $0–30/mo
Deployment:           $10–50/mo
─────────────────
Total baseline:       $40–150/mo
```

Example: 3 containers, 50GB data, Redis, monitoring
= (30) + (5) + (20) + (0.5) + (20) + (30) = ~$105/mo

**At 10K users**: Cost per user = $105 / (10,000 / 30) ≈ $0.31/user (✓ healthy)

**At 100K users**: Cost per user = $300 / (100,000 / 30) ≈ $0.09/user (✓ scales down)
