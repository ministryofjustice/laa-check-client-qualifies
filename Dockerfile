# This template builds two images, to optimise caching:
# builder: builds gems and node modules
# production: runs the actual app

# Build builder image
FROM ruby:3.2.2-bookworm as builder

# RUN apk -U upgrade && \
#     apk add --update --no-cache gcc git libc6-compat libc-dev make nodejs \
#     postgresql13-dev yarn

WORKDIR /app

RUN addgroup --gid 1000 --system appgroup
RUN adduser --uid 1000 --system appuser --gid 1000

# Add the timezone (builder image) as it's not configured by default in Alpine
#RUN apt get --update --no-cache tzdata && \
#    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
#    echo "Europe/London" > /etc/timezone

# build-base: dependencies for bundle
# yarn: node package manager
# postgresql-dev: postgres driver and libraries
# git: to allow us to create the VERSION file
#RUN apk add --no-cache build-base yarn postgresql13-dev git
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn nodejs git npm

# Install gems defined in Gemfile
COPY .ruby-version Gemfile Gemfile.lock ./

# Install gems and remove gem cache
RUN bundler -v && \
    bundle config set no-cache 'true' && \
    bundle config set no-binstubs 'true' && \
    bundle config set without 'development test' && \
    bundle install --retry=5 --jobs=4 && \
    rm -rf /usr/local/bundle/cache

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

# Cleanup to save space in the production image
RUN rm -rf node_modules log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache && \
    rm -rf .env && \
    rm -rf .git && \
    find /usr/local/bundle/gems -name "*.c" -delete && \
    find /usr/local/bundle/gems -name "*.h" -delete && \
    find /usr/local/bundle/gems -name "*.o" -delete && \
    find /usr/local/bundle/gems -name "*.html" -delete

RUN chown -R appuser:appgroup /app

USER 1000

# Build PDFTK
#FROM ghcr.io/graalvm/graalvm-ce:22.2.0 as pdftkbuilder
#RUN gu install native-image
#WORKDIR /build
#RUN curl https://gitlab.com/api/v4/projects/5024297/packages/generic/pdftk-java/v3.3.3/pdftk-all.jar --output pdftk-all.jar \
#	&& curl https://gitlab.com/pdftk-java/pdftk/-/raw/v3.3.3/META-INF/native-image/reflect-config.json --output reflect-config.json \
#	&& curl https://gitlab.com/pdftk-java/pdftk/-/raw/v3.3.3/META-INF/native-image/resource-config.json --output resource-config.json \
#	&& native-image --static -jar pdftk-all.jar \
#        -H:Name=pdftk \
#        -H:ResourceConfigurationFiles='resource-config.json' \
#        -H:ReflectionConfigurationFiles='reflect-config.json' \
#        -H:GenerateDebugInfo=0


# Build runtime image
FROM ruby:3.2.2-slim-bookworm as production

# The application runs from /app
WORKDIR /app

# Add the timezone (prod image) as it's not configured by default in Alpine
#RUN apk add --update --no-cache tzdata && \
#    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
#    echo "Europe/London" > /etc/timezone

# libpq: required to run postgres
#RUN apk add --no-cache libpq postgresql-client
RUN apt update
RUN apt install -y postgresql-client nodejs fonts-freefont-ttf libharfbuzz-bin nss-tlsd pdftk

COPY --from=builder /root/.cache/puppeteer /.cache/puppeteer
RUN chown -R 1000:1000 /.cache

# Install Chromium and Puppeteer for PDF generation
# Installs latest Chromium package available on Alpine (Chromium 108)
#RUN apk add --no-cache \
#        chromium \
#        nss \
#        freetype \
#        harfbuzz \
#        ca-certificates \
#        ttf-freefont \
#        nodejs \
#        yarn

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
#ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install latest version of Puppeteer that works with Chromium 108
#RUN yarn add puppeteer@19.2.0

# Copy files generated in the builder images
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
#COPY --from=pdftkbuilder /build/pdftk /usr/bin/pdftk

USER 1000

CMD ["docker/run"]

