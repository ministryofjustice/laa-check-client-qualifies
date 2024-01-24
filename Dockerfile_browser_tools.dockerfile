# Build browser tools for test-executor
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install Puppeteer with Chromium
RUN sudo yarn add puppeteer@21.7.0

# Install Chrome
RUN sudo npx puppeteer browsers install chrome

# Install PDFTK
RUN sudo add-apt-repository --yes ppa:malteworld/ppa || true
RUN sudo apt update --allow-unauthenticated || true
RUN sudo apt install pdftk --allow-unauthenticated || true

COPY . .
