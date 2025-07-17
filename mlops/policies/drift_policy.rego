package mlops.drift

# Trigger retraining if drift_alert contains any KPI breach criteria
# Input example (from Pub/Sub message):
# {
#   "psi": 0.25,
#   "auroc_delta": -0.06,
#   "latency_p95": 180,
#   "fairness_delta": -0.04
# }

# Threshold constants (should sync with KPI matrix)
psi_threshold            := 0.2
auroc_drop_threshold     := 0.05   # absolute drop
latency_p95_threshold_ms := 150
fairness_delta_threshold := 0.03

# Default: do not retrain
default allow_retrain = false

# Policy: allow retrain if any metric crosses its threshold
allow_retrain {
    input.psi > psi_threshold
}

allow_retrain {
    abs(input.auroc_delta) > auroc_drop_threshold
}

allow_retrain {
    input.latency_p95 > latency_p95_threshold_ms
}

allow_retrain {
    abs(input.fairness_delta) > fairness_delta_threshold
}

# Utility function for absolute value
abs(x) = y {
    x >= 0
    y := x
}
abs(x) = y {
    x < 0
    y := x * -1
}