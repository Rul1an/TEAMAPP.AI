import { trace } from "npm:@opentelemetry/api@1";

// Shared tracer for all Veo Edge Functions.
// The service name is picked up from OTEL_SERVICE_NAME env var (e.g., "veo-edge").
export const tracer = trace.getTracer("veo-edge");