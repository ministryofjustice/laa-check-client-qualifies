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

## Observability (Sentry)

Sentry is used for application monitoring and error tracking across environments.

Common reporting methods:

```ruby
Sentry.capture_exception(exception)
Sentry.capture_message("Descriptive message")
```

