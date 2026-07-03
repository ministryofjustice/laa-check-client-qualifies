# CCQ (Check if your client qualifies for legal aid)

CCQ is a Rails application used by legal aid providers to check client eligibility.

CCQ acts as a front end for [CFE Civil](https://github.com/ministryofjustice/cfe-civil), which contains the core civil legal aid eligibility logic.

Standalone mode serves https://check-your-client-qualifies-for-legal-aid.service.gov.uk/

## Running modes

CCQ supports two modes:
- `CCQ_MODE=standalone` - full service journey (**default**)
- `CCQ_MODE=embedded` - journey fragment for host services

## Dependencies
### Runtime versions
- Ruby `4.0.5` (see `.ruby-version`)
- Rails `8.1.2`

### System packages
- PostgreSQL
- Yarn
- pdftk
- Redis (required for `embedded` mode)

#### Install system packages on macOS with Homebrew
```bash
brew install postgresql@17 yarn redis
brew services start postgresql@17
brew services start redis
```

Install `pdftk` separately (for example from pdflabs).

## Setup
#### Install gems and JavaScript dependencies
```bash
bundle install
yarn install
yarn build
yarn build:css
```

#### Create and migrate databases
```bash
bundle exec rails db:create
bundle exec rails db:migrate:with_data
bundle exec rails db:migrate:with_data RAILS_ENV=test
```

#### Enable local dev cache if needed
```bash
bundle exec rails dev:cache
```

#### Create local env file
```bash
cp .env.sample .env.development
```

## Run locally
#### Start Rails directly
```bash
bundle exec rails s
```

#### Run the dev process manager (auto rebuilds CSS/JS)
```bash
bin/dev
```

`bin/dev` rebuilds JS and CSS on change, but the output is more verbose and can make debugging with breakpoints harder.

#### Run in embedded mode
```bash
CCQ_MODE=embedded bin/dev
```

## Run with Docker Compose
The docker compose configuration is designed to enable you to run both standalone and embedded mode versions of CCQ side by side using the same underlying image.

#### Build the app image used by `docker-compose.yml`
```bash
make build
```

#### Run standalone mode (app + postgres + migrator)
```bash
docker compose up ccq-standalone
```
http://localhost:3001

#### Run embedded mode (nginx + app + redis + host service stub)
```bash
docker compose up nginx
```
http://localhost:8080/applications/1234/eligibility

## Test commands
The test setup for CCQ is complex. For more detail, see [Testing](docs/testing.md).

#### Run full spec suite (standalone default)
```bash
bundle exec rspec
```

#### Run embedded-mode tests
```bash
CCQ_MODE=embedded bundle exec rspec
```

#### Run end-to-end tagged specs
```bash
bundle exec rspec -t end2end
```

#### Run CI-equivalent coverage collation
```bash
make test-ci-coverage
```

## Additional documentation
Context and implementation details can be found in the `docs` folder:
- [Testing guide](docs/testing.md)
- [Feature flags](docs/feature-flags.md)
- [PDF generation and Puppeteer](docs/pdf-generation.md)
- [Architecture notes](docs/architecture.md)
- [Deployment and operations](docs/deployment-and-operations.md)
- [Contributing conventions](docs/contributing.md)