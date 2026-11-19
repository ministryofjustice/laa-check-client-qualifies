# Build custom docker image for test-executor
# Use the CircleCI Ruby browsers image as the base image to extend out
FROM node:26.13.0-bookworm-slim@sha256:add5c17c14752c54d2f3d519ec46a3815684d41c33f198bcb09fb998f7dcbf68 AS node_runtime
RUN npm install --global yarn@1.22.22

FROM cimg/ruby:4.0.9-browsers@sha256:722d5d50508f0c790815b30be6a2f600890b9ad54be438947f27dab77090a4b3

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
