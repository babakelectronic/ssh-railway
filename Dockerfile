FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 2222

CMD ["sh", "/start.sh"]
