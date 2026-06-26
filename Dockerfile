############################################################
FROM node:22-bookworm-slim AS node_runtime

############################################################
FROM ruby:4.0.5-slim-bookworm AS base

ARG TARGETARCH
RUN if [ "$TARGETARCH" != "amd64" ]; then \
      echo "This image must be built as linux/amd64."; \
      echo "PDF generation uses Puppeteer-managed Chrome, which is only available as amd64."; \
      exit 1; \
    fi

ENV RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH=/usr/local/bundle \
    PUPPETEER_CACHE_DIR=/usr/local/share/puppeteer \
    HOME=/home/user \
    XDG_CONFIG_HOME=/home/user/.config

WORKDIR /app

# Copy Node.js runtime/tooling from official Node image.
COPY --from=node_runtime /usr/local/ /usr/local/
COPY --from=node_runtime /opt/ /opt/

############################################################
FROM base AS builder

# Install native build dependencies, remove cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential ca-certificates curl git \
      libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install ruby gems, remove cache
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=5 && \
    bundle clean --force && \
    rm -rf \
      /usr/local/bundle/cache/*.gem \
      /usr/local/bundle/ruby/*/cache \
      /usr/local/bundle/ruby/*/bundler/gems/*/.git

# install production Node packages
# puppeteer by default installs various things we don't need - skip in this stage
COPY package.json yarn.lock ./
RUN PUPPETEER_SKIP_DOWNLOAD=true \
    yarn install --frozen-lockfile --production=true && \
    yarn cache clean && \
    rm -rf /root/.cache /tmp/* /var/tmp/*

# Copy everything to WORKDIR
COPY . .

# Persist commit SHA so app can describe its current version
RUN git rev-parse --short HEAD > ./VERSION

# SECRET_KEY_BASE required but not used
RUN SECRET_KEY_BASE=anything \
    bundle exec rails assets:precompile

############################################################
FROM base AS runner

# Install runtime packages and PostgreSQL client 17.
# curl/gnupg are only needed to add the PGDG repo.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
      | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" \
      > /etc/apt/sources.list.d/postgresql.list && \
    \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      libpq5 pdftk postgresql-client-17 tar unzip xz-utils && \
    apt-get remove -y curl gnupg && \
    rm -rf /var/lib/apt/lists/* /root/.cache /tmp/* /var/tmp/*

# do this here so COPY --chown can be used,
# avoids recursive chown on big copied directories
RUN adduser --uid 10001 --system user && \
    mkdir -p /home/user/.cache /home/user/.config/chromium && \
    chown -R 10001 /home/user && \
    chown 10001 /app

COPY --from=builder --chown=10001 /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=10001 /app /app

# Install Puppeteer's managed Chrome and required Linux dependencies.
RUN apt-get update && \
    ./node_modules/.bin/puppeteer browsers install chrome --platform linux --install-deps && \
    rm -rf /var/lib/apt/lists/* /root/.cache /tmp/* /var/tmp/*

# Ensure tmp directories exist with correct ownership so Puma can write its
# pidfile on Linux/EKS (these are git-ignored and absent from the build context).
RUN mkdir -p /app/tmp/pids /app/tmp/cache /app/tmp/sockets && \
    chown -R 10001 /app/tmp

# Run as non-root user
USER 10001

CMD ["docker/run"]