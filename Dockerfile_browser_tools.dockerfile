# Multi-stage build

# Stage 1: Build puppeteer dependencies / based on this documentation - https://pptr.dev/guides/docker
FROM node:20@sha256:cb7cd40ba6483f37f791e1aace576df449fc5f75332c19ff59e2c6064797160e AS builder

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] https://dl-ssl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 dbus dbus-x11 \
      --no-install-recommends \
    && service dbus start \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r pptruser && useradd -rm -g pptruser -G audio,video pptruser

USER pptruser

WORKDIR /home/pptruser

COPY puppeteer-browsers-latest.tgz puppeteer-latest.tgz puppeteer-core-latest.tgz ./

ENV DBUS_SESSION_BUS_ADDRESS autolaunch:

# Install @puppeteer/browsers, puppeteer and puppeteer-core into /home/pptruser/node_modules.
RUN npm i ./puppeteer-browsers-latest.tgz ./puppeteer-core-latest.tgz ./puppeteer-latest.tgz \
    && rm ./puppeteer-browsers-latest.tgz ./puppeteer-core-latest.tgz ./puppeteer-latest.tgz \
    && (node -e "require('child_process').execSync(require('puppeteer').executablePath() + ' --credits', {stdio: 'inherit'})" > THIRD_PARTY_NOTICES)


# Stage 2: Final image combined with ruby & PDFTK dependancies
FROM cimg/ruby:3.2.2-browsers

WORKDIR /app

# Install PDFTK
RUN sudo add-apt-repository --yes ppa:malteworld/ppa || true
RUN sudo apt update --allow-unauthenticated || true
RUN sudo apt install pdftk --allow-unauthenticated || true

COPY --from=builder /home/pptruser/node_modules /app/node_modules
COPY . .
