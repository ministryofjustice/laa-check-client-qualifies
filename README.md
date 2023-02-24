# LAA estimate financial eligibility for legal aid

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Flaa-estimate-financial-eligibility-for-legal-aid)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#laa-estimate-financial-eligibility-for-legal-aid "Link to report")

This is a calculator for providers to obtain a quick estimate to decide if a client is eligible for Legal Aid

## Documentation for developers.

The new 'propshaft' asset pipeline (specifically jsbundling-rails and cssbundling-rails gems) has a 'test:prepare'
task that gets invoked in lots of useful places -
see https://stackoverflow.com/questions/71262775/how-do-i-ensure-assets-are-present-with-rail-7-cssbundling-rails-jsbundling-ra

## Dependencies

- Ruby version

  - Ruby version 3.x
  - Rails 7.0.x

- System dependencies
  - postgres
  - yarn

You can install postgres with `brew install postgresql` if you have homebrew. Then please run `bundle exec rails db:create` to set up the development and test databases.

Install dependencies:

```
bundle install
yarn build
yarn build:css
```

### Sentry

Sentry is a realtime application monitoring and error tracking service. The service has separate monitoring for UAT/dev, Staging and Production.

New error messages can be added using the ```Sentry.capture_exception()``` or ```Sentry.capture_message()``` methods:
```
def test_sentry 
  begin 
    1 / 0 
  rescue ZeroDivisionError => exception 
    Sentry.capture_exception(exception) 
   end
end
```
or

```Sentry.capture_message("This is the error message that is sent to Sentry")```

### Feature flags

We use Flipper to manage feature flags.
While our flagging requirements are simple we set desired flag values in env vars and transfer them to Flipper's file-based data store in an initializer.
To add a new feature flag, set a `"#{flag_name.upcase}_FEATURE_FLAG"` env var in all environments where you want the flag enabled.
Then add `flag_name` to the list of flags Flipper should read from in `app/lib/feature_flags.rb`.

To use the feature flag in your code, just call `FeatureFlags.enabled?(:flag_name)`.

In tests, you can temporarily enable a feature flag with `Flipper.enable(:flag_name)`.
However, flags are _not_ reset between specs, so to avoid polluting other tests use an `around` block and call `Flipper.disable(:flag_name)` once the test has run.

### Saving as PDF

We use Grover to save pages as PDF files for download, which in turn uses Puppeteer. For it to work, the app needs to make HTTP requests to the app, to load assets. This means that it only works in a multi-threaded environment. To run the app multithreadedly in development mode, set the `MULTI_THREAD` environment variable, e.g.:

```bash
MULTI_THREAD=1 bundle exec rails s
```

### Deploying to UAT/Staging/Production

The service uses `helm` to deploy to Cloud Platform Environments via CircleCI. This can be installed using:

`brew install helm`

To view helm deployments in a namespace the command is:

`helm -n <namespace> ls --all`

e.g. `helm -n laa-estimate-financial-eligibility-for-legal-aid-uat ls --all`

Deployments can be deleted by running:

`helm delete <name-of-deployment>`

e.g. `helm -n laa-estimate-financial-eligibility-for-legal-aid-uat delete el-351-employment-questions-pa`

It is also possible to manually deploy to an environment from the command line, the structure of the command can be found in `bin/uat_deployment`

Secrets have been stored for each environment using `kubectl create secret`. The following secrets are currently in use:

* sentry-dsn
* notifications-api-key
* secret-key-base

The current values for these are available as secure notes in LastPass for each environment, should they be lost from Kubernetes.