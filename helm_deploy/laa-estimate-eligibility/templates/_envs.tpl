{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "app.envs" }}
env:
  - name: SECRET_KEY_BASE
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: secretKeyBase
  - name: RAILS_ENV
    value: production
  - name: RAILS_SERVE_STATIC_FILES
    value: 'true'
  - name: RAILS_LOG_TO_STDOUT
    value: 'true'
  - name: HOST
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: deployHost
  - name: SENTRY_DSN
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: sentryDsn
  - name: GOOGLE_TAG_MANAGER_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: googleTagManagerId
  - name: CFE_HOST
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: checkFinancialEligibilityHost
  - name: REDIS_URL
    valueFrom:
      secretKeyRef:
        name: laa-estimate-financial-eligibility-elasticache-instance-output
        key: url
  - name: PARTNER_FEATURE_FLAG
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: partnerFeatureFlag
  - name: SENTRY_FEATURE_FLAG
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: sentryFeatureFlag
  - name: CONTROLLED_FEATURE_FLAG
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: controlledFeatureFlag
  - name: NOTIFICATIONS_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: notificationsApiKey
  - name: NOTIFICATIONS_ERROR_MESSAGE_TEMPLATE_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: notificationsErrorMessageTemplateId
  - name: NOTIFICATIONS_RECIPIENT
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: notificationsRecipient

{{- end }}
