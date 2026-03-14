# Package: Monitoring

Deploy the [Core Monitoring](https://github.com/defenseunicorns/uds-core) package configured to your environment.

## Durable alerting / Mattermost notifications

This repo includes additional Kubernetes manifests applied during `uds run deploy` to make the dev deployment durable across redeploys (no one-off `kubectl patch`):
- `PrometheusRule` for HTTP **421** alerting (tenant gateway)
- `AlertmanagerConfig` receiver/route for Mattermost
- `NetworkPolicy` egress allow for Alertmanager → tenant gateway (443)

### Required env var

When deploying, set:
- `MATTERMOST_WEBHOOK_URL` (Mattermost incoming webhook URL)

Example:
```bash
MATTERMOST_WEBHOOK_URL="https://chat.uds.dev/hooks/<token>" uds run deploy
```
