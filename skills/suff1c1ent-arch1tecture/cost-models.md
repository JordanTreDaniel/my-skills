# Cost Models by Stage

Realistic infrastructure costs for US-based startups (2024).

## MVP (0–100 users)

| Service | Provider | Monthly Cost |
|---------|----------|--------------|
| VM (4CPU/16GB) | Hetzner / DigitalOcean | $20–40 |
| Managed Postgres | Supabase / Railway | $0–25 (free tier) |
| CDN | Cloudflare | $0 (free tier) |
| File storage | Cloudinary | $0–25 |
| **Total** | | **$20–90/mo** |

## Early Traction (100–10K users)

| Service | Provider | Monthly Cost |
|---------|----------|--------------|
| VM (8CPU/32GB) | Hetzner / AWS | $80–160 |
| Managed Postgres | RDS / PlanetScale | $50–100 |
| Redis | Upstash / ElastiCache | $20–50 |
| CDN | Cloudflare Pro | $20 |
| Monitoring | Datadog (lite) | $0–50 |
| **Total** | | **$170–380/mo** |

## Product-Market Fit (10K–100K users)

| Service | Provider | Monthly Cost |
|---------|----------|--------------|
| Containers (3–5) | ECS / Fly | $200–400 |
| Database (primary + replica) | RDS | $200–400 |
| Redis (cluster) | ElastiCache | $100–200 |
| CDN + WAF | Cloudflare Business | $200 |
| Monitoring | Datadog / New Relic | $200–500 |
| Queue / Workers | SQS + ECS | $100–200 |
| **Total** | | **$1K–2K/mo** |

## Scaling Out (100K+ users)

Costs become highly variable. Budget $5K–20K/mo at this stage, but:
- Revenue should justify it
- You have dedicated infrastructure engineer(s)
- Every service is measured and optimized

## The Hidden Costs

### Don't forget:

| Cost | Typical Surprise |
|------|------------------|
| **Egress** | AWS charges $0.09/GB out. 1TB = $90. Use Cloudflare. |
| **Storage growth** | Logs, backups, old data. Archive to Glacier. |
| **Dev/staging** | Often 50% of prod costs. Use smaller instances. |
| **Third-party APIs** | SendGrid, Twilio, OpenAI. Track per-user cost. |
| **Seat licenses** | Datadog, Sentry charge by seat. Negotiate early. |

## Unit Economics

Calculate these monthly:

```
Infrastructure cost per user = Total infra cost / Active users
Cost per request = Total infra cost / Total requests
Cost per transaction = Total infra cost / Transactions processed
```

**Rule**: If cost per user is > 10% of revenue per user, optimize.
