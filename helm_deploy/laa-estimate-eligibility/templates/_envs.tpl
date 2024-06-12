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
        name: aws-secrets
        key: SECRET_KEY_BASE
  - name: RAILS_ENV
    value: production
  - name: RAILS_SERVE_STATIC_FILES
    value: 'true'
  - name: RAILS_LOG_TO_STDOUT
    value: 'true'
  - name: SENTRY_DSN
    value: {{ .Values.sentry.dsn }}
  - name: GOOGLE_TAG_MANAGER_ID
    value: {{ .Values.googleTagManager.containerId }}
  - name: CFE_HOST
    value: {{ .Values.cfe.host }}
  - name: CFE_ENVIRONMENT_NAME
    value: {{ .Values.cfe.environment_name }}
  - name: REDIS_URL
    valueFrom:
      secretKeyRef:
        name: laa-check-client-qualifies-elasticache-instance-output
        key: url
  - name: SENTRY_FEATURE_FLAG
    value: {{ .Values.featureFlags.sentry }}
  - name: INDEX_PRODUCTION_FEATURE_FLAG
    value: {{ .Values.featureFlags.indexProduction }}
  - name: MAINTENANCE_MODE_FEATURE_FLAG
    value: {{ .Values.featureFlags.maintenanceMode }}
  - name: BASIC_AUTHENTICATION_FEATURE_FLAG
    value: {{ .Values.featureFlags.basicAuthentication }}
  - name: OUTGOINGS_FLOW_FEATURE_FLAG
    value: {{ .Values.featureFlags.outgoingsFlow }}
  - name: EARLY_ELIGIBILITY_FEATURE_FLAG
    value: {{ .Values.featureFlags.earlyEligibility }}
  - name: LEGACY_ASSETS_NO_REVEAL_FEATURE_FLAG
    value: {{ .Values.featureFlags.legacyAssetNoReveals }}
  - name: LEGACY_HOUSING_BENEFIT_WITHOUT_REVEALS_FEATURE_FLAG
    value: {{ .Values.featureFlags.legacyHousingBenefitWithoutReveals }}
  - name: FEATURE_FLAG_OVERRIDES
    value: {{ .Values.featureFlags.overrides }}
  - name: NOTIFICATIONS_API_KEY
    valueFrom:
      secretKeyRef:
        name: aws-secrets
        key: NOTIFICATIONS_API_KEY
  - name: NOTIFICATIONS_ERROR_MESSAGE_TEMPLATE_ID
    value:  {{ .Values.notifications.errorMessageTemplateId }}
  - name: NOTIFICATIONS_RECIPIENT
    value: {{ .Values.notifications.recipient }}
  - name: GECKOBOARD_API_KEY
    valueFrom:
      secretKeyRef:
        name: aws-secrets
        key: GECKOBOARD_API_KEY
  - name: GECKOBOARD_METRIC_DATASET_NAME
    value:  {{ .Values.geckoboard.metricsDataset }}
  - name: GECKOBOARD_LAST_PAGE_DATASET_NAME
    value:  {{ .Values.geckoboard.lastPagesDataset }}
  - name: GECKOBOARD_ALL_METRIC_DATASET_NAME
    value:  {{ .Values.geckoboard.allMetricsDataset }}
  - name: GECKOBOARD_VALIDATION_DATASET_NAME
    value:  {{ .Values.geckoboard.validationsDataset }}
  - name: GECKOBOARD_ALL_JOURNEYS_DATASET_NAME
    value:  {{ .Values.geckoboard.allJourneysDataset }}
  - name: GECKOBOARD_MONTHLY_JOURNEYS_DATASET_NAME
    value:  {{ .Values.geckoboard.monthlyJourneysDataset }}
  - name: GECKOBOARD_RECENT_JOURNEYS_DATASET_NAME
    value:  {{ .Values.geckoboard.recentJourneysDataset }}
  - name: GECKOBOARD_ENABLED
    value: {{ .Values.geckoboard.enabled }}
  - name: BLAZER_DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: aws-secrets
        key: BLAZER_DATABASE_PASSWORD
  - name: BASIC_AUTH_PASSWORD
    valueFrom:
      secretKeyRef:
        name: aws-secrets
        key: BASIC_AUTH_PASSWORD
  - name: CSP_REPORT_ENDPOINT
    value: {{ .Values.sentry.cspReportEndpoint }}
  - name: PRIMARY_HOST
    value: {{ .Values.app.primaryHost }}
  - name: GOOGLE_OAUTH_CLIENT_ID
    value: {{ .Values.google.oauthClientId }}
  - name: GOOGLE_OAUTH_REDIRECT_URI
    value: {{ .Values.google.oauthRedirectUri }}
  - name: GOOGLE_OAUTH_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: aws-secrets
        key: GOOGLE_OAUTH_CLIENT_SECRET
  - name: SEED_ADMINS
    value: {{ .Values.app.seedAdmins }}

{{- end }}
