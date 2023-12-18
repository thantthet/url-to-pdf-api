# reference https://developers.google.com/web/tools/puppeteer/troubleshooting#setting_up_chrome_linux_sandbox
FROM node:18-alpine

COPY Noto_Sans_Myanmar/ /usr/share/fonts/

# manually installing chrome
RUN apk add chromium

WORKDIR /app

COPY package*.json ./

# skips puppeteer installing chrome and points to correct binary
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /node_modules \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules \
    && chown -R pptruser:pptruser package.json \
    && chown -R pptruser:pptruser package-lock.json \
    && npm install

# Run everything after as non-privileged user.
USER pptruser

COPY . .

EXPOSE 8080

ENV NODE_ENV=production
ENV PORT=8080
ENV ALLOW_HTTP=true

CMD ["node", "src/index.js"]
