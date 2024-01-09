# Build browser tools for test-executor 
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

# Install PDFTK
RUN apt-get update && apt-get install -y pdftk

# Install Puppeteer with Chromium
RUN yarn add puppeteer@19.2.0

