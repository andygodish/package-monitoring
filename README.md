# Package: Monitoring

Deploy the [Core Monitoring](https://github.com/defenseunicorns/uds-core) package configured to your environment.

## Durable alerting / Mattermost notifications (dev)

This repo includes a **local Zarf package** (`packages/monitoring-extras`) that is bundled into `uds-bundle.yaml` so the dev deployment stays correct across redeploys (no one-off `kubectl apply/patch`). It provides:
- PodMonitors for admin + tenant Istio gateways (Envoy `/stats/prometheus` scraping)
- `PrometheusRule` for HTTP **421** alerting (tenant gateway)
- `AlertmanagerConfig` receiver/route for Mattermost
- `NetworkPolicy` egress allow for Alertmanager → tenant gateway (443)
- `Secret` for the Mattermost incoming webhook URL

### Deploy

Preferred dev flow (bundle):
- `uds run deploy` (creates + deploys the local bundle)

Core-only flow:
- `uds run deploy-core-only`

### Required env var

When deploying the bundle, set:
- `MATTERMOST_WEBHOOK_URL` (Mattermost incoming webhook URL)

Example:
```bash
MATTERMOST_WEBHOOK_URL="https://chat.uds.dev/hooks/<token>" uds run deploy
```
