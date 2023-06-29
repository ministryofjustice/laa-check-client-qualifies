# LAA estimate financial eligibility for legal aid

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Flaa-estimate-financial-eligibility-for-legal-aid)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#laa-estimate-financial-eligibility-for-legal-aid "Link to report")

This is a calculator for providers to obtain a quick estimate to decide if a client is eligible for Legal Aid

## Documentation for developers.

The new 'propshaft' asset pipeline (specifically jsbundling-rails and cssbundling-rails gems) has a 'test:prepare'
task that gets invoked in lots of useful places -
see https://stackoverflow.com/questions/71262775/how-do-i-ensure-assets-are-present-with-rail-7-cssbundling-rails-jsbundling-ra

## Dependencies

- Ruby version

  - Ruby version 3.1.3
  - Rails 7.0.x

- System dependencies
  - postgres
  - yarn
  - pdftk
  - exiftool

## Setting up the app

You can use [Homebrew](https://brew.sh/) to install any dependencies. The Homebrew documentation has lots of useful commands.

If using Homebrew:

Install PostgreSQL. You will need to select a version if using brew. Run the below command, changing the version number as appropriate:

```
brew install postgresql@14
```

You will be prompted on the command line to start the server with something like:

```
brew services start postgresql@14
```

Next install exiftool:

```
brew install exiftool
```

You will also need pdftk. There is a [Mac installer](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg) for convenience.

If you are running Ruby version 3.1.3, then [Bundler](https://bundler.io/) should already be installed. You may run into an error here if you are not using the correct Ruby version:

```
bundle install
```

Create the development and test databases and run migrations

```
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:migrate RAILS_ENV=test
```

Install [Yarn](https://classic.yarnpkg.com/en/) (you can use Homebrew for this) and run the below:

```
brew install yarn
yarn install
yarn build
yarn build:css
```

To change settings for your local development environment, copy your `.env.sample` file to a new file and rename it to `.env.development`. 

## Tests

We test with [RSpec](https://rspec.info/) and enforce 100% line and branch coverage with [SimpleCov](https://www.learnhowtoprogram.com/ruby-and-rails/authentication-and-authorization/simplecov).

You can run tests with the command:

```
bundle exec rspec
```

Our test suite is in the process of being refactored. Below is the _intended_ main structure of the test suite, which our actual test suite does not yet reflect.

### Unit tests

#### Form tests
Form test files are held in `spec/forms`. Form tests are RSpec `feature` specs, with each test file describing the behaviour of a given form screen. Every form has form tests.

The purpose of form tests is to demonstrate that a given form screen performs the correct validation on data entered, and if data entered passes validation, that
the correct information is stored in the session. If the structure or copy of a form is affected by the content of the session, we test that too in these specs.

Since feature specs don't normally provide session access, we use the [rack_session_access](https://github.com/railsware/rack_session_access) gem.

#### CfeService tests
CfeService test files are held in `spec/services`, and there is one for each of the various SubmitXService classes. These tests comprehensively describe the behaviour of these classes, by providing session data as input and setting expectations on what methods get called on `CfeConnection` and what arguments are passed to it.

#### CfeConnection tests
CfeConnection is tested in `spec/services/cfe_connection_spec.rb`.  It validates that for each method on CfeConnection, whatever gets passed in gets turned into an appropriate HTTP request. We set expectations with `stub_request` calls.

#### Result screen tests
Result screen tests are held in `spec/views/estimates/` mock a response payload from CFE and set expectations for what appears on the results screen accordingly. They comprehensively test what content gets displayed based on the eligibility outcome.

### Integration tests

#### UI flow tests

UI flow tests are held in `spec/flows`, and are RSpec `feature` specs. Each test describes a different journey from the start page to the check answers page, making explicit what screens are reached. These flows do not explore validation errors (which are covered in form tests), or data passed to CFE. They do specify explicitly which
screens are filled out in what order, although they do not specify how the screens are filled out (instead this is delegated to helper functions) except to the extent that it affects the flow. There are flows for:

* Similar parallel pathways such as controlled vs certificated
* Collections of screens that are toggled or skipped in response to an answer given on a previous screen, such as partner questions, passporting questions etc
* The effect of specific feature flags
* Looping flows like the 'add another' benefits journey
* The check answers journey, both simple loops and more complex ones caused by changing answers in the check answers flow
* The effect of using the back button and changing answers

#### End-to-end tests

End-to-end tests are held in `spec/end_to_end` and are RSpec `feature` specs. Each test describes a journey from start page to result screen, describing the values that are filled on each screen and, via HTTP stubs, the values that are sent to CFE when loading the result screen.

There are end-to-end tests to cover the main categories of journey through the site, but the end-to-end tests are _not_ intended to be comprehensive.

**The above is not a comprehensive list of tests, and we are pragmatic about how best to test any given piece functionality. Classes not comprehensively exercised by the above tests get their own unit tests.**

## Significant libraries we use

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

For "static" feature flags we set the flag values in env vars.
To add a new feature flag, set a `"#{flag_name.upcase}_FEATURE_FLAG"` env var with value `"ENABLED"` in all environments where you want the flag enabled.
Then add `flag_name` to the list of flags  in `app/lib/feature_flags.rb`.

To use the feature flag in your code, just call `FeatureFlags.enabled?(:flag_name)`.

In tests, you can temporarily enable a feature flag by setting the ENV value.
However, flags are _not_ reset between specs, so to avoid polluting other tests use an `around` block and change the ENV value back once the test has run.

We also have time-dependent flags, defined in `app/lib/feature_flags.rb`, which default to disabled but also have a date associated.
They will be enabled _on_ the associated date.

When the `FEATURE_FLAG_OVERRIDES` env var is set to `enabled`, it is possible to use the `/feature-flags` endpoint to set database values that override
env values for both static and time-based feature flags. The username is "flags" and the password is a secret stored alongside our other secrets in K8s.

### Saving as PDF

We use Grover to save pages as PDF files for download, which in turn uses Puppeteer. For it to work, the app needs to make HTTP requests to the app, to load assets. This means that it only works in a multi-threaded environment. To run the app multithreadedly in development mode, set the `MULTI_THREAD` environment variable, e.g.:

```bash
MULTI_THREAD=1 bundle exec rails s
```

### Data analysis

We use Blazer for our Cloud Platform environments.
You can access the UI at `/data`, with username "blazer" and a password that is stored in 1Password alongside the other secrets for any given environment.
Blazer has readonly access to the database so it can't accidentally be used to overwrite real data.

## Retrieving user-entered data for a given check

User-entered values are stored in the session. However, rather than retrieve values directly from the session, most places retrieve them from associated
model objects and helpers, of which there is a hierarchy:

**Steps::Logic** contains methods that directly interrogate a session object for a few specific attributes that affect navigation flow through the form.
It knows how answers to certain questions affect the relevance of certain other questions.

**Steps::Helper** uses Steps::Logic to determine which screens, or steps, should be displayed for a given check, based on the answers provided so far.

**Flow::Handler** knows, for any given step, which Form object to populate to back the HTML form displayed on screen

**Check** provides access to all _relevant_ data for a check. For any attribute it uses Steps::Helper and Flow::Handler to determine whether,
given the other answers supplied, the attribute is relevant. If not, when asked for that attribute it will return `nil`. Otherwise it will return that attribute.

## I18n

We keep all user-facing content strings in locale files. In particular, `config/locales/en.yml` contains nearly every piece of text on the site.
 We have a utility to help identify obsolete content built into our test suite.
You can run `CHECK_UNUSED_KEYS=true bundle exec rspec` and it will print out, at the end of the test run, all keys found in `en.yml` that don't get looked up by the test suite.
Using this periodically can help remove stale content from that file.

## Deploying to UAT/Staging/Production

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
* geckoboard-api-key
* blazer-password
* blazer-database-password
* feature-flags-password

The current values for these are available as secure notes in 1Password for each environment, should they be lost from Kubernetes.