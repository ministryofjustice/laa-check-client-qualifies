Running RSpec with `CCQ_MODE=embedded` will run all of the tests in the `spec/_embedded` directory, as well as any other specs tagged with `ccq_mode: :embedded` metadata.

The _embedded spec directory should contain specs which specifically test embedded mode routes/flows/functionality.

This repository uses SimpleCov with 100% coverage. Branches and execution paths for embedded mode _must_ be exercised in the regular spec flows as well and cannot be excluded, which usually means mocking `ModeConfig` members and testing logical branches in separate `context` blocks.

If a spec is reused via `ccq_mode: :embedded`, individual tests can be disabled in embedded test runs by adding the `:standalone_only` metadata. This tag is automatically excluded from embedded mode test runs by `rails_helper.rb`.