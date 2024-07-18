# CCQ (Check if your client qualifies for legal aid)

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Flaa-check-client-qualifies&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/laa-check-client-qualifies)

This is a calculator for legal aid providers to quickly check if a client is eligible for legal aid.

CCQ is effectively a front end for [CFE Civil](https://github.com/ministryofjustice/cfe-civil), which contains all eligibility logic.
CCQ only knows about the specifics of the eligibility ruleset to the extent that this knowledge is needed in order to be able to ask the right questions.

Currently CCQ only enables checks relating to civil legal aid; however a future roadmap ambition is to also provide checks for criminal legal aid.

## Documentation for developers.

## Dependencies

- Ruby version

  - Ruby version 3.1.3
  - Rails 7.0.x

- System dependencies
  - postgres
  - yarn
  - pdftk

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

## Running locally

To change settings for your local development environment, copy your `.env.sample` file to a new file and rename it to `.env.development`.

To run the server locally, you can use `bundle exec rails s` or `bin/dev`. The latter will automatically rebuild JS and CSS every time they change,
although it also has more verbose console output that can make debugging with `binding.p` harder.

## Tests

We test with [RSpec](https://rspec.info/) and enforce 100% line and branch coverage with [SimpleCov](https://www.learnhowtoprogram.com/ruby-and-rails/authentication-and-authorization/simplecov).

You can run tests with the command:

```
bundle exec rspec
```

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
Result screen tests are held in `spec/views/results/` mock a response payload from CFE and set expectations for what appears on the results screen accordingly. They comprehensively test what content gets displayed based on the eligibility outcome.

### Integration tests

The version of chromedriver has to be constantly updated to keep pace with chrome - we use chrome to generate PDFs, so switching to firefox is not an option.
After performing 'brew upgrade chromedriver' the first call will produce an warning dialog about trusting the binary. This can be suppressed with:

xattr -d com.apple.quarantine /opt/homebrew/bin/chromedriver

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

End-to-end tests are held in `spec/end_to_end` and are RSpec `feature` specs. Each test describes a journey from start page to result screen, describing the values that are filled on each screen along the way. Some tests test, via HTTP stubs, the values that are sent to CFE when loading the result screen. Some actually send the payload to CFE and test what appears on the results screen, but these must be explicitly enabled by calling `bundle exec rspec -t end2end`

There are end-to-end tests to cover the main categories of journey through the site, but the end-to-end tests are _not_ intended to be comprehensive.

#### System tests
"System" tests are held in /spec/system, and are where we hold tests that involve running our javascript.

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

When adding a `flag_name` to the list of static flags, you will need to decide if this is a `"global"` flag i.e. always taken from the env var and not the session, or a `"session"` flag i.e. taken from the `session_data` of the check.

We introduced this as a way of making our feature flags 'backwards compatible' - if a user check is underway during the switch-on of a flag, their user journey will not be affected by any flag-related changes. This is because we use their `session_data` to determine the value of the flag that was set at the start of their check. 

To use the feature flag in your code, call `FeatureFlags.enabled?(:flag_name, session_data)`. For cases where you are not able to pass in `session_data` e.g. on the start page, call `FeatureFlags.enabled?(:flag_name, without_session_data: true)`.

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

### PDF Accessibility 

When generating PDFs from an eligibility check, we found that the iOS screenreader, was having difficulty focussing on `<h2>` and `<p>` html elements on a mobile/tablet screen.

To combat this we replaced `<h2>` & `<p>` html elements, with `<li>` elements and nested them either in a `<h2>` or `<ul>`structure. Helper methods have been created in `results_helper.rb`, to construct these new html elements, remove stylings and only show them when a PDF is generated.

The iOS screenreader, was also having difficulty announcing the numbers in our tables. To combat this, we created the `pdf_friendly_numeric_table_cell` method which uses the `govuk-!-text-align-right` override class, instead of using the `numeric: true` class (for a cell with a number in it). 

Call this method (with the relevant arguments, for this method’s parameters) anytime you want to create a table cell with a number in it, for the use in a PDF.

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

e.g. `helm -n laa-check-client-qualifies-uat ls --all`

Deployments can be deleted by running:

`helm delete <name-of-deployment>`

e.g. `helm -n laa-check-client-qualifies-uat delete el-351-employment-questions-pa`

It is also possible to manually deploy to an environment from the command line, the structure of the command can be found in `bin/uat_deployment`

## Secrets

We keep secrets in AWS Secrets Manager. To edit them, visit the [AWS web console](https://justice-cloud-platform.eu.auth0.com/samlp/mQev56oEa7mrRCKAZRxSnDSoYt6Y7r5m?connection=github). The following secrets are currently stored in a secret called "aws-secrets" in each namespace we use:
* NOTIFICATIONS_API_KEY
* SECRET_KEY_BASE
* GECKOBOARD_API_KEY
* BASIC_AUTH_PASSWORD
* GOOGLE_OAUTH_CLIENT_SECRET

The current values for these are available as secure notes in 1Password for each environment, should they be lost from Kubernetes.

## Portal integration

### Secrets
   There is only 1 of these (the secret key) which is kept in k8s 'portal_secrets' secret
   This is a single key X509_KEY which contains the secret key for the certificate used to authenticate with Portal.

    Last parameter is 'no DES' (Data Encryption Standard) (rather than nodes) which means don't store a passphrase against it
    https://en.wikipedia.org/wiki/Data_Encryption_Standard
```
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes
```

```
    kubectl -n <namespace> create secret generic portal-secrets --from-file=X509_KEY=./private-key.pem
```
    where private-key.pem is the private key creeated via openssl: 


### Metadata files
  The metadata files are required by the portal team before they can do their integration - this is a little chicken-and-egg
  situation as the metadata files are produced by our Rails code at the url <hostname>:/providers/auth/saml/metadata 

  Once you have the `xml` metadata (from visiting <hostname>:/providers/auth/saml/metadata), copy and paste the metadata into appropriate file (`uat.xml` or `stg.xml` etc). 
  Remove the errant "..." from the file and format it with your IDE. 

  Then let the portal team know that you branch the new metadata for portal to "point back to". Once that is done, you can test out on this UAT branch: https://portal.uat.legalservices.gov.uk

  We also store the portal metadata files in our repository - they are in the Portal GitHub, but their repo is private so
  we can't easily get to them without creating a github access key - it was easier just to copy and paste their config files
  although this could be a potential future option - the code we inherited from crime apply does have the capability of loading 
  a Portal metadata file from a URL.

## Branch naming

We name our branches to start with the Jira ticket ID, followed by a short description of the work.

Due to case-sensitivity in the integration between CircleCi and Jira, the Jira ticket ID needs to be uppercase so that it exactly matches how it is on Jira.
For example:
❌ el-123-add-new-feature
✅ EL-123-add-new-feature