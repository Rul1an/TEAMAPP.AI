import { describe, it, expect, vi } from 'vitest';
import { TokenBucket, TIER_LIMITS } from '../rate_limit';

describe('TokenBucket', () => {
  it('allows up to capacity tokens immediately', () => {
    const bucket = new TokenBucket(TIER_LIMITS.basic);
    for (let i = 0; i < 60; i++) {
      expect(bucket.consume()).toBe(true);
    }
    expect(bucket.consume()).toBe(false);
  });

  it('refills tokens over time', () => {
    vi.useFakeTimers();
    const bucket = new TokenBucket(TIER_LIMITS.basic);
    for (let i = 0; i < 60; i++) bucket.consume();
    expect(bucket.consume()).toBe(false);
    vi.advanceTimersByTime(2000); // 2 seconds -> +2 tokens
    expect(bucket.consume()).toBe(true);
    expect(bucket.consume()).toBe(true);
    expect(bucket.consume()).toBe(false);
    vi.useRealTimers();
  });
});