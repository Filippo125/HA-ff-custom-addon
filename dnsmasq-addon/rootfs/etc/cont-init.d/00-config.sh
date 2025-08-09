#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -euo pipefail

bashio::log.info "Generazione configurazione dnsmasq..."

DOMAIN=$(bashio::config 'domain')
CACHE_SIZE=$(bashio::config 'cache_size')
LOG_QUERIES=$(bashio::config 'log_queries')
ADD_MAC=$(bashio::config 'add_mac')

mkdir -p /etc/dnsmasq.d /var/run/dnsmasq /var/lib/misc

cat > /etc/dnsmasq.conf <<EOF
no-resolv
domain-needed
bogus-priv
$(for i in $(bashio::config 'interfaces|join " "'); do echo "interface=${i}"; done)
listen-address=0.0.0.0,::
cache-size=${CACHE_SIZE}
conf-dir=/etc/dnsmasq.d,*.conf
local=/$(echo "${DOMAIN}" | sed 's#\.#/#g')/
expand-hosts
log-facility=-
$(if bashio::var.true "${LOG_QUERIES}"; then echo "log-queries"; fi)
EOF

case "${ADD_MAC}" in
  base64)
    echo "add-mac=base64" >> /etc/dnsmasq.conf
    ;;
  text)
    echo "add-mac=text" >> /etc/dnsmasq.conf
    ;;
  disabled|"")
    :
    ;;
  *)
    echo "add-mac" >> /etc/dnsmasq.conf
    ;;
esac

if bashio::config.has_value 'upstream_dns'; then
  while read -r srv; do
    echo "server=${srv}" >> /etc/dnsmasq.conf
  done < <(bashio::config 'upstream_dns|join "\n"')
fi

if bashio::config.has_value 'forwards'; then
  while read -r dom srv; do
    echo "server=/${dom}/${srv}" >> /etc/dnsmasq.d/10-forwards.conf
  done < <(bashio::jq '(.forwards // [])[] | "\(.domain) \(.server)"')
fi

if bashio::config.has_value 'hosts'; then
  while read -r host ip; do
    echo "host-record=${host},${ip}" >> /etc/dnsmasq.d/20-hosts.conf
  done < <(bashio::jq '(.hosts // [])[] | "\(.host) \(.ip)"')
fi

if bashio::config.has_value 'cnames'; then
  while read -r alias target; do
    echo "cname=${alias},${target}" >> /etc/dnsmasq.d/30-cnames.conf
  done < <(bashio::jq '(.cnames // [])[] | "\(.alias) \(.target)"')
fi

if bashio::config.has_value 'advanced'; then
  bashio::log.info "Applico configurazione advanced (testo libero)."
  ADV_CONTENT=$(bashio::config 'advanced' | sed 's/\r$//')
  printf '%s\n' "${ADV_CONTENT}" > /etc/dnsmasq.d/99-advanced.conf
fi

bashio::log.info "Configurazione dnsmasq generata."
