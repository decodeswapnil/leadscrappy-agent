# LeadScrappy agent image: the prebuilt agent plus a headless browser.
FROM node:22-bookworm-slim
ENV NODE_ENV=production \
    PLAYWRIGHT_BROWSERS_PATH=/opt/browsers \
    LEADSCRAPPY_STATE=/data/agent.json
WORKDIR /agent
RUN npm init -y >/dev/null \
 && npm install --omit=dev --no-audit --no-fund playwright@1.63.0 \
 && npx playwright install --with-deps --only-shell chromium \
 && rm -rf /var/lib/apt/lists/* /root/.npm /tmp/* \
 && chmod -R a+rX /opt/browsers \
 && mkdir /data && chown node:node /data
COPY agent.mjs ./agent.mjs
USER node
VOLUME ["/data"]
LABEL org.opencontainers.image.title="LeadScrappy agent" \
      org.opencontainers.image.description="Pairs with a LeadScrappy portal and runs its searches from this machine." \
      org.opencontainers.image.source="https://github.com/decodeswapnil/leadscrappy-agent"
ENTRYPOINT ["node", "/agent/agent.mjs", "--headless"]
