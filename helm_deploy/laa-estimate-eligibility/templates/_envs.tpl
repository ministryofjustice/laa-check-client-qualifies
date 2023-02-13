{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "app.envs" }}
env:
  - name: SECRET_KEY_BASE
    valueFrom:
      secretKeyRef:
        name: kube-secrets
        key: secret-key-base
  - name: RAILS_ENV
    value: production
  - name: RAILS_SERVE_STATIC_FILES
    value: 'true'
  - name: RAILS_LOG_TO_STDOUT
    value: 'true'
  - name: HOST
    value: {{ .Values.deploy.host }}
  - name: SENTRY_DSN
    valueFrom:
      secretKeyRef:
        name: kube-secrets
        key: sentry-dsn
  - name: GOOGLE_TAG_MANAGER_ID
    value: {{ .Values.googleTagManager.containerId }}
  - name: CFE_HOST
    value: {{ .Values.cfe.host }}
  - name: REDIS_URL
    valueFrom:
      secretKeyRef:
        name: laa-estimate-financial-eligibility-elasticache-instance-output
        key: url
  - name: SENTRY_FEATURE_FLAG
    value: {{ .Values.featureFlags.sentry }}
  - name: CONTROLLED_FEATURE_FLAG
    value: {{ .Values.featureFlags.controlled }}
  - name: ASYLUM_AND_IMMIGRATION_FEATURE_FLAG
    value: {{ .Values.featureFlags.asylumAndImmigration }}
  - name: NOTIFICATIONS_API_KEY
    valueFrom:
      secretKeyRef:
        name: kube-secrets
        key: notifications-api-key
  - name: NOTIFICATIONS_ERROR_MESSAGE_TEMPLATE_ID
    value:  {{ .Values.notifications.errorMessageTemplateId }}
  - name: NOTIFICATIONS_RECIPIENT
    value: {{ .Values.notifications.recipient }}

{{- end }}
