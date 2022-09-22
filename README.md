# LAA estimate financial eligibility for legal aid

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22laa-estimate-financial-eligibility-for-legal-aid%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#laa-estimate-financial-eligibility-for-legal-aid "Link to report")

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

Install dependencies:

```
bundle install
yarn build
yarn build:css
```
