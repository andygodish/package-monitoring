apiVersion: v1
kind: Secret
metadata:
  name: mattermost-webhook
  namespace: monitoring
type: Opaque
stringData:
  # Incoming webhook URL (Mattermost): https://chat.<domain>/hooks/<token>
  url: "${MATTERMOST_WEBHOOK_URL}"
