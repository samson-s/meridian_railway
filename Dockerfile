FROM node:22-bookworm-slim

RUN mkdir -p /home/node/.claude /home/node/.config/meridian && \
    chown -R node:node /home/node && \
    npm install -g @rynfar/meridian && \
    npm install -g @rynfar/meridian-plugin-opencode-scrub && \
    printf '{"plugins":[{"path":"/usr/local/lib/node_modules/@rynfar/meridian-plugin-opencode-scrub/dist/index.js","enabled":true}]}\n' > /home/node/.config/meridian/plugins.json && \
    chown node:node /home/node/.config/meridian/plugins.json

USER node
WORKDIR /app

ENV MERIDIAN_HOST=0.0.0.0 \
    IS_SANDBOX=1

EXPOSE 3456

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD node -e "const p=process.env.MERIDIAN_PORT||process.env.PORT||3456;fetch('http://127.0.0.1:'+p+'/health').then(r=>process.exit(r.ok?0:1))"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["meridian"]
