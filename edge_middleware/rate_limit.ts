/*
 * Edge Rate-Limiter Middleware
 * ‑ LRU in-memory cache (per-edge instance)
 * ‑ Token-Bucket algorithm (refill per second)
 * ‑ Tier limits resolved from JWT claim `tier` (basic|pro|enterprise)
 *
 * NOTE: Designed for Edge runtimes like Cloudflare Workers / Vercel Edge / Next.js Middleware.
 */

import { incCounter, metricsText } from './metrics';

interface TierConfig {
  capacity: number;          // max tokens in bucket
  refillPerSec: number;      // tokens added per second
}

type Tier = 'basic' | 'pro' | 'enterprise';

const TIER_LIMITS: Record<Tier, TierConfig> = {
  basic: { capacity: 60, refillPerSec: 1 },          // 60 rpm  ≈ 1 rps
  pro: { capacity: 600, refillPerSec: 10 },          // 600 rpm ≈ 10 rps
  enterprise: { capacity: Number.MAX_SAFE_INTEGER, refillPerSec: Number.MAX_SAFE_INTEGER },
};

/** Lightweight token bucket */
class TokenBucket {
  private tokens: number;
  private lastRefill: number; // epoch ms
  constructor(private readonly cfg: TierConfig) {
    this.tokens = cfg.capacity;
    this.lastRefill = Date.now();
  }
  /** Attempt to consume `n` tokens, returns `true` if allowed */
  consume(n = 1): boolean {
    this.refill();
    if (this.tokens >= n) {
      this.tokens -= n;
      return true;
    }
    return false;
  }
  private refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000; // seconds
    const refill = elapsed * this.cfg.refillPerSec;
    if (refill > 0) {
      this.tokens = Math.min(this.cfg.capacity, this.tokens + refill);
      this.lastRefill = now;
    }
  }
}

/** Very small LRU cache (O(1) insert/lookup) */
class LRUCache<K, V> extends Map<K, V> {
  constructor(private readonly maxEntries: number) {
    super();
  }
  override get(key: K): V | undefined {
    const value = super.get(key);
    if (value !== undefined) {
      // refresh ordering by deleting & re-setting
      super.delete(key);
      super.set(key, value);
    }
    return value;
  }
  override set(key: K, value: V): this {
    if (this.has(key)) super.delete(key);
    super.set(key, value);
    if (this.size > this.maxEntries) {
      // evict oldest (first key)
      const oldestKey = this.keys().next().value as K;
      super.delete(oldestKey);
    }
    return this;
  }
}

// Global cache survives per-worker instance
const buckets = new LRUCache<string, TokenBucket>(10_000);

function getTierFromJwt(jwt: string | null): Tier {
  if (!jwt) return 'basic';
  try {
    const payloadB64 = jwt.split('.')[1];
    const json = atob(payloadB64);
    const data = JSON.parse(json);
    const tier = data.tier as Tier | undefined;
    if (tier === 'pro' || tier === 'enterprise') return tier;
    return 'basic';
  } catch (_) {
    return 'basic';
  }
}

/**
 * Edge middleware entry point
 *
 * Usage (Cloudflare worker example):
 * ```ts
 * export default {
 *   fetch: rateLimitHandler,
 * };
 * ```
 */
export async function rateLimitHandler(request: Request): Promise<Response> {
  const url = new URL(request.url);
  if (url.pathname === '/metrics') {
    return new Response(metricsText(), {
      headers: { 'Content-Type': 'text/plain; version=0.0.4' },
    });
  }
  const authHeader = request.headers.get('Authorization');
  const jwt = authHeader?.startsWith('Bearer ') ? authHeader.slice(7) : null;
  const tier = getTierFromJwt(jwt);

  const userKey = jwt ?? request.headers.get('X-Forwarded-For') ?? crypto.randomUUID();
  let bucket = buckets.get(userKey);
  if (!bucket) {
    bucket = new TokenBucket(TIER_LIMITS[tier]);
    buckets.set(userKey, bucket);
  }
  if (!bucket.consume()) {
    incCounter('veo_rate_limited_total');
    return new Response('Rate limit exceeded', {
      status: 429,
      headers: {
        'Retry-After': '60',
      },
    });
  }

  // Continue chain – here we simply proxy the request (placeholder)
  return fetch(request);
}

// Named export (useful for unit testing)
export { TokenBucket, TIER_LIMITS, buckets };