# Caddy (OVH DNS) Add-on

This add-on runs Caddy 2 as a reverse proxy for Home Assistant using ACME DNS-01 with OVH.

## Configuration

Set the following options:

- `domain`: e.g. ha.yourdomain.com
- `email`: email for Let's Encrypt
- `ha_upstream`: usually http://homeassistant:8123
- `ovh_endpoint`: typically ovh-eu
- `ovh_application_key`
- `ovh_application_secret`
- `ovh_consumer_key`

## Optional Custom Caddyfile

If you create:

/share/caddy/Caddyfile

and keep `prefer_custom_caddyfile: true`, it will be used instead of the auto-generated one.

## Home Assistant Configuration

Add to configuration.yaml:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.0.0/16
```