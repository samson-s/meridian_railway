FROM node:22-bookworm-slim

RUN groupadd -r claude && \
    useradd -r -g claude -u 1000 -m -d /home/claude claude && \
    mkdir -p /home/claude/.claude && \
    chown -R claude:claude /home/claude

USER claude
WORKDIR /app

RUN npm install -g @rynfar/meridian

ENV MERIDIAN_HOST=0.0.0.0 \
    IS_SANDBOX=1

EXPOSE 3456

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD node -e "const p=process.env.MERIDIAN_PORT||process.env.PORT||3456;fetch('http://127.0.0.1:'+p+'/health').then(r=>process.exit(r.ok?0:1))"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["meridian"]
