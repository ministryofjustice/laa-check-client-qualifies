# Build browser tools for test-executor
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install Chrome & Puppeteer with Chromium
RUN npx puppeteer browsers install chrome \ 
    && sudo yarn add puppeteer@21.5.0

# Install PDFTK
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt update --allow-unauthenticated
RUN sudo apt install pdftk --allow-unauthenticated

COPY . .
