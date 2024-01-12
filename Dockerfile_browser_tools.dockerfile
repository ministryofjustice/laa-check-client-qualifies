# # Build browser tools for test-executor 
# # Use the cimg/ruby:3.2.2-browsers image as the base image to extend out
# FROM cimg/ruby:3.2.2-browsers

# # Install Chrome
# RUN sudo apt-get install -y wget
# RUN sudo wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
# RUN sudo npx puppeteer browsers install chrome || true \
# RUN sudo npm install -g npm@10.3.0

# # Install PDFTK
# RUN sudo add-apt-repository --yes ppa:malteworld/ppa || true
# RUN sudo apt update --allow-unauthenticated || true
# RUN sudo apt install pdftk --allow-unauthenticated || true

# # Install Puppeteer with Chromium
# RUN yarn add puppeteer@19.2.0

# -------

# Use the ghcr.io/puppeteer/puppeteer:latest image as the base image to extend out
FROM ghcr.io/puppeteer/puppeteer:latest

# Set the working directory
WORKDIR /app

# Copy the script.js file to the working directory
COPY path/to/script.js /app

# Run the script.js file with Puppeteer
CMD ["node", "-e", "$(cat /app/script.js)"]