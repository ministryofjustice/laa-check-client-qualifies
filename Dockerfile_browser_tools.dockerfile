# Build custom docker image for test-executor
# Use the cimg/ruby:4.0.5-browsers image as the base image to extend out
FROM node:22-bookworm-slim@sha256:813a7480f28fdadac1f7f5c824bcdad435b5bc1322a5968bbbdef8d058f9dff4 AS node_runtime

FROM cimg/ruby:4.0.5-browsers@sha256:f43ba0010f468ef461112e310c60663653fe2261e31ac364be575f042130308b

WORKDIR /app

# Copy Node.js runtime/tooling from official Node image.
COPY --from=node_runtime /usr/local/ /usr/local/
COPY --from=node_runtime /opt/ /opt/

# Install PDFTK
RUN sudo apt update --allow-unauthenticated
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt install pdftk --allow-unauthenticated

# These 2 lines still need to mirror the actual version
# used by the application (in yarn.lock, not package.json)
RUN yarn add puppeteer@25.3.0
RUN npx puppeteer browsers install chrome --platform linux

COPY . .
