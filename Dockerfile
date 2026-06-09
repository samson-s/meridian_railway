FROM node:22-bookworm-slim

RUN mkdir -p /home/node/.claude && \
    chown -R node:node /home/node && \
    npm install -g @rynfar/meridian

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
