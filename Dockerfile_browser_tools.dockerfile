# Build custom docker image for test-executor
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install Chrome
RUN npx puppeteer browsers install chrome

# # Tell Puppeteer to skip installing Chromium. We'll be using the installed package.
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# ENV PUPPETEER_EXECUTABLE_PATH=/home/circleci/.cache/puppeteer/chrome/linux-121.0.6167.85/chrome-linux64/chrome

# Install Puppeteer with Chromium
# Chromium version 119.0.6045.105 is mapped to Puppeteer version 21.5.0, as per documentation -> https://pptr.dev/chromium-support
RUN sudo yarn add puppeteer@21.5.0

# Install PDFTK
RUN sudo add-apt-repository --yes ppa:malteworld/ppa || true
RUN sudo apt update --allow-unauthenticated || true
RUN sudo apt install pdftk --allow-unauthenticated || true

COPY . .
