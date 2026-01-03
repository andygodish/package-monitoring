# Using an Untrusted CA Certificate with Grafana OAuth

When using my self-signed local CA cert in my UDS lab environment, I encounter the following pod log in Grafana after attempting to log in via the UI:

> grafana x509: certificate signed by unknown authority

## TLS SKIP VERIFY ENVIRONMENT VARIABLE

```bash
kubectl -n grafana set env deploy/grafana \
  GF_AUTH_GENERIC_OAUTH_TLS_SKIP_VERIFY_INSECURE=true
kubectl -n grafana rollout restart deploy/grafana
```

