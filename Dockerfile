# This template builds two images, to optimise caching:
# builder: builds gems and node modules
# production: runs the actual app

# Build builder image
FROM ruby:3.2.2-bookworm as builder

WORKDIR /app

RUN addgroup --gid 1000 --system appgroup
RUN adduser --uid 1000 --system appuser --gid 1000

# Yarn doesn't have a native Debian package, so we need to download it from its own repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# yarn: node package manager
# git: to allow us to create the VERSION file
# npm - so that we can run puppeteer via npx
RUN apt update && apt install -y yarn nodejs git npm

# Install gems defined in Gemfile
COPY .ruby-version Gemfile Gemfile.lock ./

# Install gems
RUN bundler -v && \
    bundle config set no-binstubs 'true' && \
    bundle config set without 'development test' && \
    bundle cache --retry=5

# Install node packages defined in package.json
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --prod
RUN npx puppeteer browsers install chrome

# Copy all files to /app (except what is defined in .dockerignore)
COPY . .

# make the git commit hash available to the app so it can describe its current version
RUN git rev-parse --short HEAD > ./VERSION

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=required-to-run-but-not-used \
    bundle exec rails assets:precompile

RUN chown -R appuser:appgroup /app

USER 1000

# Build runtime image
FROM ruby:3.2.2-slim-bookworm as production

# The application runs from /app
WORKDIR /app

# Add the timezone (prod image) as it's not configured by default in Alpine
#RUN apk add --update --no-cache tzdata && \
#    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
#    echo "Europe/London" > /etc/timezone

RUN apt update
# possibly don't need to specify all these sub-dependencies any more...
# probably need ca-certificates so that chromium can talk to something
RUN apt install -y postgresql-client nodejs fonts-freefont-ttf libharfbuzz-bin nss-tlsd pdftk ca-certificates

# install all chromium's dependencies, but then remove chromium itself as we will be installing via puppeteer
RUN apt install -y chromium
RUN apt remove -y chromium

COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# make a config directory in $HOME
RUN mkdir -p /.config/chromium
RUN chown -R 1000:1000 /.config

RUN mkdir /.cache
COPY --from=builder /root/.cache/puppeteer /.cache/puppeteer
RUN chown -R 1000:1000 /.cache

USER 1000

CMD ["docker/run"]

