# Build browser tools for test-executor 
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

# Install PDFTK
RUN add-apt-repository --yes ppa:malteworld/ppa || true
RUN apt update --allow-unauthenticated || true
RUN apt install pdftk --allow-unauthenticated || true

# Install Puppeteer with Chromium
RUN yarn add puppeteer@19.2.0

CMD ["docker/run"]