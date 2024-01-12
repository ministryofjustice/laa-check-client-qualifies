# Build browser tools for test-executor 
# Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install Chrome
RUN sudo apt-get install -y wget
RUN sudo wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN sudo npx puppeteer browsers install chrome || true 
    # && sudo mkdir -p /home/circleci/project/.cache/puppeteer \
    # && sudo mv /root/.cache/puppeteer/chrome/linux-119.0.6045.105/chrome-linux64/chrome /home/circleci/project/.cache/puppeteer
RUN sudo npm install -g npm@10.3.0

# Install PDFTK
RUN sudo add-apt-repository --yes ppa:malteworld/ppa || true
RUN sudo apt update --allow-unauthenticated || true
RUN sudo apt install pdftk --allow-unauthenticated || true

# Install Puppeteer with Chromium
RUN yarn add puppeteer@19.2.0

