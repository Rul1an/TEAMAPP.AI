import { metrics } from "npm:@opentelemetry/api@1";

const meter = metrics.getMeter("veo-edge", "1.0.0");

// Histogram capturing time (ms) to ingest highlights for a match
export const ingestDurationHist = meter.createHistogram("veo.ingest.duration", {
  description: "Duration of ingesting Veo highlights (ms)",
  unit: "ms",
});

// Counter for number of highlights successfully inserted
export const highlightsInsertedCounter = meter.createCounter("veo.ingest.inserted", {
  description: "Number of highlights inserted into database",
});