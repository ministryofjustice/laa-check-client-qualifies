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
  - name: GOOGLE_ANALYTICS_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.fullname" . }}
        key: googleAnalyticsId
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

{{- end }}
