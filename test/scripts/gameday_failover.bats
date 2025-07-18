#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Mock AWS CLI using a simple stub in PATH
setup() {
  PATH="${BATS_TEST_DIRNAME}/stub:$PATH"
  mkdir -p "$BATS_TEST_DIRNAME/stub"
  cat >"$BATS_TEST_DIRNAME/stub/aws" <<'EOF'
#!/usr/bin/env bash
if [[ $1 == 'cloudwatch' && $2 == 'put-metric-data' ]]; then
  exit 0
fi
if [[ $1 == 'route53' ]]; then
  exit 0
fi
if [[ $1 == 'fis' ]]; then
  if [[ $2 == 'start-experiment' ]]; then
    echo '{"experiment":{"id":"exp-123"}}'
    exit 0
  fi
fi
exit 0
EOF
  chmod +x "$BATS_TEST_DIRNAME/stub/aws"
  cat >"$BATS_TEST_DIRNAME/stub/curl" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
  chmod +x "$BATS_TEST_DIRNAME/stub/curl"
  export ROUTE53_HOSTED_ZONE_ID="Z123"
  export DRY_RUN=true
}

@test "gameday_failover exits successfully in dry-run" {
  run bash scripts/gameday_failover.sh
  assert_success
  assert_output --partial "GameDay completed successfully"
}