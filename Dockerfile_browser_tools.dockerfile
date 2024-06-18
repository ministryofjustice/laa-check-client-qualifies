# Build custom docker image for test-executor
# Use the cimg/ruby:3.3.1-browsers image as the base image to extend out
FROM cimg/ruby:3.3.1-browsers

WORKDIR /app

# Install PDFTK
RUN sudo apt update --allow-unauthenticated
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt install pdftk --allow-unauthenticated

# These 2 lines still need to mirror the actual version
# used by the application (in yarn.lock, not package.json)
RUN yarn add puppeteer@22.11.0
RUN npx puppeteer browsers install chrome

COPY . .
