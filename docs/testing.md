# Testing guide

## Overview

The project uses RSpec and enforces line and branch coverage via SimpleCov.

There are roughly 1000 standalone tests, so running in parallel or targeting specific specs is faster for local iteration.

## Main commands

Standalone/default mode:

```bash
bundle exec rspec
```

Embedded mode:

```bash
CCQ_MODE=embedded bundle exec rspec
```

When using `CCQ_MODE=embedded`, RSpec runs specs in `spec/_embedded` and any specs in `spec` tagged with `ccq_mode: :embedded`.

End-to-end tagged tests:

```bash
bundle exec rspec -t end2end
```

CI coverage collation from a clean slate:

```bash
make test-ci-coverage
```

Useful make targets:

```bash
make test
make test-embedded
```

## Parallel tests

This service uses the `parallel_tests` gem.

If you hit errors such as `ActiveRecord::NoDatabaseError` for test shards (for example `ccq_test3`), prepare test databases and rerun:

```bash
bin/rails db:create RAILS_ENV=test
RAILS_ENV=test bundle exec rake parallel:prepare
bundle exec parallel_rspec spec -n 4
```

Adjust `-n` to your machine.

## Test types

### Form tests

- Location: `spec/forms`
- Type: feature specs
- Purpose: validation and session persistence for each form screen
- Note: these specs use `rack_session_access` to inspect and assert session behavior in feature tests

### CfeService tests

- Location: `spec/services`
- Purpose: behavior of SubmitXService classes and CFE request payloads

### CfeConnection tests

- Location: `spec/services/cfe_connection_spec.rb`
- Purpose: request shape and endpoint behavior at HTTP boundary

### Result screen tests

- Location: `spec/views/results`
- Purpose: rendered output from mocked CFE payloads

### UI flow tests

- Location: `spec/flows`
- Type: feature specs
- Purpose: assert navigation through major journeys and conditional paths

### End-to-end tests

- Location: `spec/end_to_end`
- Type: feature specs
- Purpose: start-to-result journeys with stubs and selected live-CFE paths

### System tests

- Location: `spec/system`
- Purpose: tests that exercise JavaScript behavior

## ChromeDriver note

After `brew upgrade chromedriver`, macOS may quarantine the binary. Remove quarantine if needed:

```bash
xattr -d com.apple.quarantine /opt/homebrew/bin/chromedriver
```
