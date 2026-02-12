# Build custom docker image for test-executor
# Use the cimg/ruby:3.3.4-browsers image as the base image to extend out
FROM cimg/ruby:3.3.4-browsers

WORKDIR /app

# Download new GPG key for Google Chrome and 
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /tmp/google-chrome.gpg
COPY docker/google-chrome.list /etc/apt/sources.list.d/google-chrome.list

# Install PDFTK
RUN sudo apt update --allow-unauthenticated
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt install pdftk --allow-unauthenticated

# These 2 lines still need to mirror the actual version
# used by the application (in yarn.lock, not package.json)
RUN yarn add puppeteer@24.36.1
RUN npx puppeteer browsers install chrome

COPY . .
