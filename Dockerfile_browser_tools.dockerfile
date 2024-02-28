# Build custom docker image for test-executor
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.3-browsers

WORKDIR /app

# Install PDFTK
RUN sudo apt update --allow-unauthenticated
RUN sudo add-apt-repository --yes ppa:malteworld/ppa
RUN sudo apt install pdftk --allow-unauthenticated

# Install Puppeteer via Yarn
RUN yarn add puppeteer

COPY . .
