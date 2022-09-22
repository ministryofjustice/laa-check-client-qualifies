# LAA estimate financial eligibility for legal aid

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22laa-estimate-financial-eligibility-for-legal-aid%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#laa-estimate-financial-eligibility-for-legal-aid "Link to report")

This is a calculator for providers to obtain a quick estimate to decide if a client is eligible for Legal Aid

## Documentation for developers.

## Dependencies

- Ruby version

  - Ruby version 3.x
  - Rails 7.0.x

- System dependencies
  - postgres
  - yarn

Install dependencies:

```
bundle install
yarn build
yarn build:css
```

### Initial setup

Git-crypt is used for encryption. It uses either your personal public key or a symmetric key.

To obtain the symmetric key you will need to get access to LastPass. Liase with a team member for this. Once you have the the key you can unlock:

    git-crypt unlock path-to-symmetric-key

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
