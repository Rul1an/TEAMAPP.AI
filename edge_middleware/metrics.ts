/**
 * In-memory metrics collector (Edge-safe)
 * Supports Prometheus plaintext exposition.
 */

const counters: Record<string, number> = {};

export function incCounter(name: string, delta = 1) {
  counters[name] = (counters[name] ?? 0) + delta;
}

export function metricsText(): string {
  return Object.entries(counters)
    .map(([key, val]) => `${key} ${val}`)
    .join('\n');
}