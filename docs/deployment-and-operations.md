# Deployment and operations

## Deployments

Deployments use Helm to deploy to Cloud Platform environments via CI.

### Install Helm:

```bash
brew install helm
```

List releases in a namespace:

```bash
helm -n <namespace> ls --all
```

Delete a release:

```bash
helm -n <namespace> delete <release-name>
```

Another option is the [VSCode Kubernetes extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools).


## Secrets

Secrets are stored in AWS Secrets Manager per namespace.

Examples used by this service include:

- `SECRET_KEY_BASE`
- `NOTIFICATIONS_API_KEY`
- `BLAZER_DATABASE_PASSWORD`
- `SLACK_WEBHOOK_URL`
- `BASIC_AUTH_PASSWORD`
- `GOOGLE_OAUTH_CLIENT_SECRET`

To access and edit:

1. [Open the Cloud Platform AWS console](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/accessing-the-cloud-console.html#accessing-the-aws-console-read-only).
2. Use London region.
3. Navigate to Secrets Manager.
4. Locate the live namespace secret for UAT, staging, or production by searching for `check-client-qualifies`.


## DevSecOps pre-commit hooks

This repository uses MoJ DevSecOps hooks for detecting hardcoded secrets.

Project:

- https://github.com/ministryofjustice/devsecops-hooks

Install and run locally:

```bash
curl --proto '=https' --tlsv1.2 \
  -LsSf https://raw.githubusercontent.com/ministryofjustice/devsecops-hooks/e85ca6127808ef407bc1e8ff21efed0bbd32bb1a/prek/prek-installer.sh | sh

prek install
prek run
```

## Rails logging

Rails logs use one JSON object per line when both `CCQ_MODE=embedded` and
`RAILS_ENV=production`. This applies to the existing stdout logger when
`RAILS_LOG_TO_STDOUT` is set and to the default file logger otherwise.
Standalone production, development, and test formatting are unchanged.
Production keeps its INFO threshold, so DEBUG messages are not emitted.

The formatter is in `app/lib/json_log_formatter.rb`; production configuration
selects it in `config/environments/production.rb`. No new dependency, logging
flag, or database migration is required. Deploying and restarting the application
applies the change.

Each entry contains `timestamp` (UTC), `level`, `service`, `environment`,
`correlationId`, `message`, and `context`. `environment` is the Rails environment,
not a deployment label such as UAT. A structured message can supply a
`correlationId`; otherwise the existing first Rails request tag supplies it.
Outside a request it can be null. Native tags are retained in `context.tags`.

Application code can supply structured data without encoding JSON itself:

```ruby
Rails.logger.warn(message: "Host unavailable", context: { statusCode: 503 })
```

Ordinary framework messages still work. Quotes and line breaks are escaped in
JSON, and exception messages retain their class and backtrace. This formatter
does not redact sensitive data: callers must still avoid logging bodies,
credentials, tokens, and personal information. Process-manager and access logs
are outside the Rails JSON guarantee.

Run the focused checks with the project's Ruby environment and installed bundle:

```bash
CCQ_MODE=embedded mise exec -- bundle exec rspec spec/lib/json_log_formatter_spec.rb
```

The spec checks serialization and starts separate Rails processes to verify
embedded production stdout/file output and unchanged standalone/local formatting.
It does not require `rails_helper` or boot the main test process in production.

### Embedded controller outcomes

Embedded controllers emit the following events. The private `log_embedded_event`
helper in `EmbeddedBaseController` supplies the current request ID and
`context.caseId`; the owning controller supplies the outcome. The formatter above
serializes the entry. Controllers do not encode JSON themselves.

| Level | Event | Meaning |
| --- | --- | --- |
| INFO | `embedded.journey.started` | Fresh journey hydrated and cache writes finished successfully. |
| INFO | `embedded.journey.resumed` | Previous assessment hydrated successfully. |
| INFO | `embedded.journey.completed` | Host save and cache cleanup finished successfully. |
| INFO | `security.authentication.required` | CCQ redirected to an allowed host sign-in location. |
| WARN | `security.authentication.failed` | Host returned 401. |
| WARN | `security.authorisation.denied` | Host returned 403. |
| WARN | `embedded.session.missing` / `embedded.session.invalid` | An existing session-recovery handler was used. |
| ERROR | `embedded.host.request.failed` | Host transport failed or returned an unexpected status. |
| ERROR | `embedded.host.redirect_rejected` | Host sign-in redirect was missing, invalid, or disallowed. |

`context.operation` distinguishes `embedded.journey.load`,
`embedded.journey.save`, and `embedded.session.recover`. Host outcomes include
`dependency: host-service` and an available `statusCode`. Transport failures omit
the status code. Redirect rejection reasons are `missing_location`,
`invalid_location`, and `disallowed_location`; raw URLs are not included.

Successful hydration is logged after controller callbacks, including the final
cache write. Completion is logged only after both host saving and cache deletion.
A failed cache operation does not produce a success event; existing response and
cache behavior remains unchanged. Ordinary form pages do not add outcome events.
Unhandled exceptions, including CFE errors, remain Rails' responsibility so the
application does not catch, log, and rethrow them or duplicate their stack traces.

Run the controller, serialized-request, cache-isolation, and formatter checks:

```bash
CCQ_MODE=embedded mise exec -- bundle exec rspec spec/controllers/embedded_*_spec.rb spec/requests/embedded_logging_spec.rb spec/requests/embedded_journey_cache_partition_spec.rb spec/lib/json_log_formatter_spec.rb
CFE_HOST=http://cfe.test mise exec -- bundle exec rspec spec/services/host_service_client_spec.rb spec/services/cfe_connection_spec.rb
```

The fake CFE URL is only for the stubbed service tests. Request logging tests use
minimal test-only templates, leaving controllers and middleware real while
avoiding frontend assets and unrelated page translations. They also enable
production-like exception rendering for their unhandled-exception checks.

After deployment, use synthetic cases to check start, resume, completion, and safe
failure paths. Search by `context.event`, `context.caseId`, and `correlationId`.
Confirm the request ID forwarded by ingress is retained and each handled outcome
appears once. No migration applies; deployment rollback restores previous logging.

## Observability (Sentry)

Sentry is used for application monitoring and error tracking across environments.

Set `SENTRY_FEATURE_FLAG=enabled` to enable reporting. Standalone mode uses
`SENTRY_DSN`, while `CCQ_MODE=embedded` uses `SENTRY_EMBEDDED_DSN`. Supply the
appropriate project's DSN in the runtime environment and restart the application
after changing it. If the selected DSN is missing or blank, Sentry is disabled;
Embedded mode does not fall back to the standalone DSN.

Common reporting methods:

```ruby
Sentry.capture_exception(exception)
Sentry.capture_message("Descriptive message")
```

