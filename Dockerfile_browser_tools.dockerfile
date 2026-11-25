# Build custom docker image for test-executor
# Use the CircleCI Ruby browsers image as the base image to extend out
FROM node:26.13.1-bookworm-slim@sha256:5df79989ed685e09f0a98019db4cebfb22fb9df1a53c0161664a011f7ff6b0f1 AS node_runtime
RUN npm install --global yarn@1.22.22

FROM cimg/ruby:4.0.10-browsers@sha256:5b7e2b347a5e64593f2095a0d60cd4ab5f40e759758606a21be67783a13ffa18

WORKDIR /app

# Copy Node.js runtime/tooling from official Node image.
COPY --from=node_runtime /usr/local/ /usr/local/
COPY --from=node_runtime /opt/ /opt/

# Install pdftk from Ubuntu's archive; its OpenJDK 11 runtime is unaffected by CVE-2026-114938.
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends pdftk libatomic1

# These 2 lines still need to mirror the actual version
# used by the application (in yarn.lock, not package.json)
RUN yarn add puppeteer@25.16.0
RUN npx puppeteer browsers install chrome --platform linux
RUN sudo rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
