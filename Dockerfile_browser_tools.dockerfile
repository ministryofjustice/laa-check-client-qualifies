# Build custom docker image for test-executor
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install PDFTK
RUN sudo apt update --allow-unauthenticated
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt install pdftk --allow-unauthenticated

# Tell Puppeteer to skip installing Chromium. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Puppeteer via Yarn
RUN yarn add puppeteer

RUN sudo apt-get install -y wget
RUN sudo wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN sudo apt-get install -y ./google-chrome-stable_current_amd64.deb


COPY . .
