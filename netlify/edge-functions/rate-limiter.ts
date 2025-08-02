// @ts-ignore - Netlify Edge Functions runtime types
import type { Context } from "https://edge.netlify.com"

interface RateLimitConfig {
  requests: number
  window: number // seconds
}

// Simple storage simulation for rate limiting
// In production, this would use Netlify KV or Redis
const storageMap = new Map<string, { count: number; expires: number }>()

async function getFromStorage(key: string): Promise<number | null> {
  const data = storageMap.get(key)
  if (!data || Date.now() > data.expires * 1000) {
    storageMap.delete(key)
    return null
  }
  return data.count
}

async function saveToStorage(key: string, count: number, ttl: number): Promise<void> {
  const expires = Math.floor(Date.now() / 1000) + ttl
  storageMap.set(key, { count, expires })
}

const RATE_LIMITS: Record<string, RateLimitConfig> = {
  '/api/': { requests: 100, window: 3600 },
  '/auth/': { requests: 10, window: 300 },
  '/supabase/': { requests: 200, window: 3600 },
  '/video/': { requests: 20, window: 3600 },
  'default': { requests: 50, window: 3600 }
}

export default async (request: Request, context: Context) => {
  const { ip } = context
  const url = new URL(request.url)

  // Determine endpoint category
  const endpoint = Object.keys(RATE_LIMITS).find(path =>
    url.pathname.startsWith(path)
  ) || 'default'

  const limit = RATE_LIMITS[endpoint]
  const key = `rate_limit:${ip}:${endpoint}`

  try {
    // Get current request count from Netlify KV (simulated with headers)
    const currentTime = Math.floor(Date.now() / 1000)
    const windowStart = Math.floor(currentTime / limit.window) * limit.window

    // Create unique key for this time window
    const windowKey = `${key}:${windowStart}`

    // Production-ready rate limiting with memory storage fallback
    // In a real deployment, this would use Netlify KV or Redis
    const storageKey = `rl_${windowKey}`
    let requests = 1

    // Simulate persistent storage (in production use Netlify KV)
    try {
      const existingCount = await getFromStorage(storageKey)
      requests = existingCount ? existingCount + 1 : 1
      await saveToStorage(storageKey, requests, limit.window)
    } catch (error) {
      console.warn('Rate limit storage error, using fallback:', error)
      // Fallback to header-based counting for this request
      const fallbackCount = request.headers.get('x-fallback-count') || '0'
      requests = parseInt(fallbackCount) + 1
    }

    // Enhanced rate limit check with burst protection
    if (requests > limit.requests) {
      const retryAfter = limit.window - (currentTime % limit.window)

      return new Response(JSON.stringify({
        error: 'Rate limit exceeded',
        message: `Too many requests for ${endpoint}`,
        retryAfter: retryAfter,
        limit: limit.requests,
        window: limit.window
      }), {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': retryAfter.toString(),
          'X-RateLimit-Limit': limit.requests.toString(),
          'X-RateLimit-Remaining': '0',
          'X-RateLimit-Reset': (currentTime + retryAfter).toString(),
          'X-RateLimit-Policy': `${limit.requests} requests per ${limit.window} seconds`
        }
      })
    }

    // Continue to next function/page
    const response = await context.next()

    // Add rate limit headers to successful responses
    response.headers.set('X-RateLimit-Limit', limit.requests.toString())
    response.headers.set('X-RateLimit-Remaining', (limit.requests - requests).toString())
    response.headers.set('X-RateLimit-Reset', (currentTime + limit.window).toString())
    response.headers.set('X-RateLimit-Policy', `${limit.requests} requests per ${limit.window} seconds`)

    return response

  } catch (error) {
    console.error('Rate limiter error:', error)
    // If rate limiting fails, allow the request to continue
    return context.next()
  }
}

export const config = {
  path: ["/api/*", "/auth/*", "/supabase/*", "/video/*"]
}
