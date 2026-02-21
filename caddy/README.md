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

To obtain credentials, please go ahed in the next section.

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

# Creating OVH API Credentials for DNS-01

To allow Caddy to complete the ACME DNS challenge, it needs permission to create and delete temporary TXT records in your OVH DNS zone.

Caddy uses the OVH API to automatically create _acme-challenge TXT records during certificate issuance and renewal.

## Step 1 - Open the OVH API Token Generator

Go to:

Europe:
https://eu.api.ovh.com/createToken/

Canada:
https://ca.api.ovh.com/createToken/

US:
https://api.us.ovhcloud.com/createToken/

Use the endpoint that matches your OVH account region.

## Step 2 - Fill in the Application Details

Application name (example: HomeAssistant Caddy)

Application description (example: Caddy DNS challenge for Let's Encrypt)

Validity: You can choose Unlimited 


## Step 3 - Add Required Permissions

You must grant the following API rights:

GET /domain/zone/yourdomain.com
POST /domain/zone/yourdomain.com/record
PUT /domain/zone/yourdomain.com/record/*
DELETE /domain/zone/yourdomain.com/record/*
POST /domain/zone/yourdomain.com/refresh

These permissions allow Caddy to:

- Create DNS TXT records
- Remove DNS TXT records
- Refresh the DNS zone

They do not grant access to other OVH services.

## Step 4 - Generate the Credentials

Click Create keys.

OVH will generate:

- Application Key
- Application Secret
- Consumer Key

Important:
You must copy the Application Secret immediately. It will not be shown again.

## Step 5 - Configure the Add-on

In the Home Assistant add-on configuration, enter:

ovh_endpoint: "ovh-eu"
ovh_application_key: "YOUR_APP_KEY"
ovh_application_secret: "YOUR_APP_SECRET"
ovh_consumer_key: "YOUR_CONSUMER_KEY"

Endpoint values:

- ovh-eu → Europe
- ovh-ca → Canada
- ovh-us → United States