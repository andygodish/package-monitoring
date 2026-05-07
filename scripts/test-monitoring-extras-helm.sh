#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHART_DIR="$ROOT_DIR/packages/monitoring-extras/chart"

if ! command -v helm >/dev/null 2>&1; then
  echo "helm is required for this test" >&2
  exit 1
fi

# Render with required CRDs.
out="$(helm template monitoring-extras "$CHART_DIR" \
  --api-versions monitoring.coreos.com/v1 \
  --api-versions monitoring.coreos.com/v1alpha1 \
  --set mattermost.webhookUrl=https://example.invalid/webhook)"

echo "$out" | grep -q "kind: PrometheusRule"
echo "$out" | grep -q "name: \"tenant-gateway-421\""

echo "$out" | grep -q "kind: AlertmanagerConfig"
echo "$out" | grep -q "name: \"mattermost\""

echo "$out" | grep -q "kind: NetworkPolicy"
echo "$out" | grep -q "name: \"allow-alertmanager-egress-chat-via-tenant-gateway\""

echo "$out" | grep -q "kind: Secret"
echo "$out" | grep -q "name: \"mattermost-webhook\""

# Render without CRDs - should not include PrometheusRule/AlertmanagerConfig.
out2="$(helm template monitoring-extras "$CHART_DIR" \
  --set mattermost.webhookUrl=https://example.invalid/webhook)"
if echo "$out2" | grep -q "kind: PrometheusRule"; then
  echo "expected no PrometheusRule output when CRD is not available" >&2
  exit 1
fi
if echo "$out2" | grep -q "kind: AlertmanagerConfig"; then
  echo "expected no AlertmanagerConfig output when CRD is not available" >&2
  exit 1
fi

# Secret should not render when webhookUrl is empty.
out3="$(helm template monitoring-extras "$CHART_DIR" \
  --api-versions monitoring.coreos.com/v1alpha1)"
if echo "$out3" | grep -q "kind: Secret"; then
  echo "expected no Secret output when mattermost.webhookUrl is empty" >&2
  exit 1
fi

echo "ok"
