package mlops.drift

# Unit tests for drift retraining policy

import data.mlops.drift.allow_retrain

# Test: PSI breach triggers retrain
psi_breach {
  allow_retrain with input as {"psi": 0.25}
}

# Test: AUROC drop triggers retrain
auroc_drop {
  allow_retrain with input as {"auroc_delta": -0.06}
}

# Test: Latency breach triggers retrain
latency_breach {
  allow_retrain with input as {"latency_p95": 200}
}

# Test: Fairness breach triggers retrain
fairness_breach {
  allow_retrain with input as {"fairness_delta": -0.04}
}

# Test: No breach – no retrain
no_breach {
  not allow_retrain with input as {
    "psi": 0.1,
    "auroc_delta": -0.01,
    "latency_p95": 100,
    "fairness_delta": -0.01
  }
}