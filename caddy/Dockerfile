# Build Caddy with OVH module
FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/ovh

# Runtime
FROM caddy:2

# Add jq to read /data/options.json (option HA add-on)
RUN apk add --no-cache jq

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Dirs tipiche del container Caddy
VOLUME ["/data", "/config"]

CMD ["/run.sh"]