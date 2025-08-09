FROM dockurr/dnsmasq:2.91

LABEL \
  io.hass.name="dnsmasq (custom)" \
  io.hass.description="Resolver DNS locale con dnsmasq" \
  io.hass.type="addon" \
  io.hass.version="1.3.1"

RUN apk add --no-cache dnsmasq tzdata

COPY rootfs /

EXPOSE 53/udp 53/tcp
