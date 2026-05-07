# CCQ (Check if your client qualifies for legal aid)

## Embedded mode

### Dependencies

- Additional system dependencies
  - redis


### Setting up the app

Use [Homebrew](https://brew.sh/) to install any dependencies.

Install `redis`:

```bash
brew install redis
brew services start redis
```

Then set up the app:

```bash
bundle install
```

Create the development and test databases and run migrations:

```bash
bundle exec rails db:create
bundle exec rails db:migrate:with_data
bundle exec rails db:migrate:with_data RAILS_ENV=test
```

Install [Yarn](https://classic.yarnpkg.com/en/) (you can use Homebrew for this) and run the below:

```bash
brew install yarn
yarn install
yarn build
yarn build:css
```

### Tests

RSpec is configured to be smart about which tests it runs based on the `CCQ_MODE` value. If no value is given, or if the value is `standalone`, it will run CCQ's standalone tests in `/spec`:

```bash
bundle exec rspec
```

If the value is `embedded`, RSpec will run CCQ's embedded mode tests in `spec/_embedded`. It will also run any specs in `/spec` which are tagged with the `ccq_mode: :embedded` metadata:

```bash
CCQ_MODE=embedded bundle exec rspec
```

There is a [Makefile](Makefile) with some useful targets:

```bash
make test
make test-embedded
```

Be aware, there are roughly 1000 tests for standalone mode and these can take a while to run in sequence. It is recommended to run these in parallel or target specific specs.