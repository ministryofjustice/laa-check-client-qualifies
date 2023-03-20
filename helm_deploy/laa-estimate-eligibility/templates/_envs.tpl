{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "app.envs" }}
env:
  {{ if .Values.postgresql.enabled }}
  - name: POSTGRES_USER
    value: {{ .Values.postgresql.postgresqlUsername }}
  - name: POSTGRES_PASSWORD
    value: {{ .Values.postgresql.auth.postgresPassword }}
  - name: POSTGRES_HOST
    value: {{ printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" }}
  - name: POSTGRES_DATABASE
    value: {{ .Values.postgresql.auth.database }}
  {{ else }}
  - name: POSTGRES_USER
    valueFrom:
      secretKeyRef:
        name: rds-postgresql-instance-output
        key: database_username
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: rds-postgresql-instance-output
        key: database_password
  - name: POSTGRES_HOST
    valueFrom:
      secretKeyRef:
        name: rds-postgresql-instance-output
        key: rds_instance_address
  - name: POSTGRES_DATABASE
    valueFrom:
      secretKeyRef:
        name: rds-postgresql-instance-output
        key: database_name
  {{ end }}
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
  - name: CW_FORMS_FEATURE_FLAG
    value: {{ .Values.featureFlags.cwForms }}
  - name: NOTIFICATIONS_API_KEY
    valueFrom:
      secretKeyRef:
        name: kube-secrets
        key: notifications-api-key
  - name: NOTIFICATIONS_ERROR_MESSAGE_TEMPLATE_ID
    value:  {{ .Values.notifications.errorMessageTemplateId }}
  - name: NOTIFICATIONS_RECIPIENT
    value: {{ .Values.notifications.recipient }}
  - name: GECKOBOARD_API_KEY
    valueFrom:
      secretKeyRef:
        name: kube-secrets
        key: geckoboard-api-key
  - name: GECKOBOARD_METRIC_DATASET_NAME
    value:  {{ .Values.geckoboard.metricsDataset }}
  - name: GECKOBOARD_LAST_PAGE_DATASET_NAME
    value:  {{ .Values.geckoboard.lastPagesDataset }}
  - name: GECKOBOARD_ALL_METRIC_DATASET_NAME
    value:  {{ .Values.geckoboard.allMetricsDataset }}
  - name: GECKOBOARD_RECENT_VALIDATION_DATASET_NAME
    value:  {{ .Values.geckoboard.recentValidationsDataset }}
  - name: GECKOBOARD_ALL_VALIDATION_DATASET_NAME
    value:  {{ .Values.geckoboard.allValidationsDataset }}
  - name: GECKOBOARD_ENABLED
    value: {{ .Values.geckoboard.enabled }}

{{- end }}
