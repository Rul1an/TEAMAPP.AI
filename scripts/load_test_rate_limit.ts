import { TokenBucket, TIER_LIMITS } from '../edge_middleware/rate_limit';

const bucket = new TokenBucket(TIER_LIMITS.basic);
let allowed = 0;
let blocked = 0;

const durationMs = 10_000; // 10 seconds
const end = Date.now() + durationMs;

while (Date.now() < end) {
  if (bucket.consume()) {
    allowed++;
  } else {
    blocked++;
  }
}

console.log(`Basic tier load test (10s): allowed=${allowed}, blocked=${blocked}`);

// For a basic tier (1 rps), we expect <= 20 allowed in 10s (a bit of tolerance)
if (allowed <= 20 && blocked > allowed) {
  console.log('✅ Load test passed');
  process.exit(0);
} else {
  console.error('❌ Load test failed: allowed too many or blocked too few');
  process.exit(1);
}