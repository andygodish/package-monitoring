# Using an Untrusted CA Certificate with Grafana OAuth

When using my self-signed local CA cert in my UDS lab environment, I encounter the following pod log in Grafana after attempting to log in via the UI:

> grafana x509: certificate signed by unknown authority

## TLS SKIP VERIFY ENVIRONMENT VARIABLE

```bash
kubectl -n grafana set env deploy/grafana \
  GF_AUTH_GENERIC_OAUTH_TLS_SKIP_VERIFY_INSECURE=true
kubectl -n grafana rollout restart deploy/grafana
```

## Grafana Helm Chart Overrides

Two overrides are needed when using the upstream UDS Core monitoring package. First create a secret containing your CA cert:

```bash
kubectl -n grafana create secret generic uds-local-ca \
  --from-file=ca.crt=./certs/uds.local/uds.local-ca.crt
```

Utilize UDS variable overrides in a uds-config.yaml file as follows:

```yaml
EXTRA_SECRET_MOUNTS:
    # 
    - name: auth-generic-oauth-secret-mount
    secretName: sso-client-uds-core-admin-grafana
    defaultMode: 0440
    mountPath: /etc/secrets/auth_generic_oauth
    readOnly: true
    - name: uds-local-ca
    secretName: uds-local-ca
    defaultMode: 0444
    readOnly: true
    mountPath: /etc/grafana/certs
    items:
        - key: ca.crt
        path: ca.crt
ENV_GF_AUTH_GENERIC_OAUTH_TLS_CLIENT_CA: /etc/grafana/certs/ca.crt
```
