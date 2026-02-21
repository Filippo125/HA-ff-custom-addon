#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
CUSTOM_CADDYFILE="/share/caddy/Caddyfile"
GENERATED_CADDYFILE="/data/Caddyfile"

domain="$(jq -r '.domain // empty' "$OPTIONS_FILE")"
email="$(jq -r '.email // empty' "$OPTIONS_FILE")"
ha_upstream="$(jq -r '.ha_upstream // "http://homeassistant:8123"' "$OPTIONS_FILE")"

ovh_endpoint="$(jq -r '.ovh_endpoint // "ovh-eu"' "$OPTIONS_FILE")"
ovh_application_key="$(jq -r '.ovh_application_key // empty' "$OPTIONS_FILE")"
ovh_application_secret="$(jq -r '.ovh_application_secret // empty' "$OPTIONS_FILE")"
ovh_consumer_key="$(jq -r '.ovh_consumer_key // empty' "$OPTIONS_FILE")"

prefer_custom="$(jq -r '.prefer_custom_caddyfile // true' "$OPTIONS_FILE")"

export OVH_ENDPOINT="$ovh_endpoint"
export OVH_APPLICATION_KEY="$ovh_application_key"
export OVH_APPLICATION_SECRET="$ovh_application_secret"
export OVH_CONSUMER_KEY="$ovh_consumer_key"

# Use custom Caddyfile if present
if [ "$prefer_custom" = "true" ] && [ -f "$CUSTOM_CADDYFILE" ]; then
  echo "[INFO] Using custom Caddyfile: $CUSTOM_CADDYFILE"
  exec caddy run --config "$CUSTOM_CADDYFILE" --adapter caddyfile
fi

if [ -z "$domain" ]; then
  echo "[ERROR] 'domain' is not set and no custom Caddyfile found."
  exit 1
fi

if [ -z "$OVH_APPLICATION_KEY" ] || [ -z "$OVH_APPLICATION_SECRET" ] || [ -z "$OVH_CONSUMER_KEY" ]; then
  echo "[ERROR] OVH credentials are missing."
  exit 1
fi

echo "[INFO] Generating Caddyfile..."

cat > "$GENERATED_CADDYFILE" <<EOF
{
  email $email
}

$domain {
  tls {
    dns ovh {
      endpoint {env.OVH_ENDPOINT}
      application_key {env.OVH_APPLICATION_KEY}
      application_secret {env.OVH_APPLICATION_SECRET}
      consumer_key {env.OVH_CONSUMER_KEY}
    }
  }

  reverse_proxy $ha_upstream
}
EOF

exec caddy run --config "$GENERATED_CADDYFILE" --adapter caddyfile