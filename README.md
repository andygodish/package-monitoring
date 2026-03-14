# Package: Monitoring

Deploy the [Core Monitoring](https://github.com/defenseunicorns/uds-core) package configured to your environment.

## Dev deployment (durable extras)

This repo includes a small local Zarf package (`monitoring-extras/`) that contains the “one-off” fixes we want to persist across clean redeploys:
- gateway PodMonitors
- HTTP **421** PrometheusRule (tenant gateway)
- AlertmanagerConfig for Mattermost routing
- supporting NetworkPolicy

To deploy **Core Monitoring + extras** as a single unit, create and deploy the bundle:

- `uds run create-bundle`
- `uds run deploy-bundle`

`uds run deploy` deploys the upstream Core Monitoring Zarf package only (no local extras).

### Required env var (for Mattermost routing)

When deploying the bundle (or otherwise applying monitoring-extras), set:
- `MATTERMOST_WEBHOOK_URL` (Mattermost incoming webhook URL)
