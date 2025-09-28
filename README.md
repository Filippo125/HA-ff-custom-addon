# Filippo Home Assistant Add-ons

Collection of custom Home Assistant add-ons maintained by Filippo Ferrazini. Each directory contains an add-on ready to install through a custom repository.

## Add-on Index

| Add-on | Slug | Short description |
| --- | --- | --- |
| iCloud Photo Downloader | `ha-icloudpd-addon` | Automatically downloads photos from iCloud into a Home Assistant folder |
| go2rtc + neolink (Reolink 2-way) | `go2rtc_neolink` | Runs go2rtc with backchannel audio support via neolink for Reolink doorbells/cameras |
| dnsmasq (ff) | `dnsmasq_ff` | Local DNS resolver based on dnsmasq with host records, CNAME, forwarding, and add-mac |

## iCloud Photo Downloader (`ha-icloudpd-addon`)

- Base image: `icloudpd/icloudpd:1.26.1`
- Provides a supervisor panel with icon `mdi:cloud-download`
- Mounts `media` read/write to store photos under `/media/photos`
- Defaults: uses MFA and password providers exposed by the built-in web UI

### Usage tips
1. Make sure Home Assistant exposes the destination folder (`/media/photos`).
2. Enter your iCloud credentials through the add-on web UI on first launch.
3. Complete the two-factor authentication process when prompted.

## go2rtc + neolink (Reolink 2-way) (`go2rtc_neolink`)

Add-on that combines go2rtc and `neolink talk` to enable two-way audio (backchannel) on Reolink devices.

- Supported architectures: `aarch64`, `amd64`
- Web UI reachable at `http://<HA_IP>:1984/`
- Exposes RTSP/WebRTC ports (`1984/tcp`, `8554/tcp`)
- Auto-generates `neolink.toml` and `go2rtc.yaml` based on the add-on configuration

### Sample configuration
```yaml
camera_ip: "192.168.1.50"
username: "admin"
password: "changeme"
stream: "sub"            # "sub" = low latency; "main" = higher quality
extra_streams: ""         # Optional YAML to append to the streams section
```

For Lovelace you can use the **WebRTC Camera** card:
```yaml
type: custom:webrtc-camera
url: webrtc://doorbell_sub
ui: true
background: true
muted: false
```
Remember that the microphone button requires HTTPS on the Home Assistant dashboard to grant audio permissions.

## dnsmasq (ff) (`dnsmasq_ff`)

Local DNS resolver running `dockurr/dnsmasq` with advanced configuration options exposed via the UI.

- Supported architectures: `aarch64`, `amd64`, `armv7`, `armhf`
- Uses host networking (`host_network: true`) and watchdog on `tcp://127.0.0.1:53`
- Maps `config`, `share`, and `ssl`

### Key options
```json
{
  "domain": "lan",
  "interfaces": ["eth0"],
  "upstream_dns": ["1.1.1.1", "8.8.8.8"],
  "hosts": [{"host": "home.lan", "ip": "192.168.1.10"}],
  "cnames": [{"alias": "nas.local", "target": "nas.lan"}],
  "forwards": [{"domain": "corp.local", "server": "10.0.0.53"}]
}
```
The `advanced` field lets you paste additional dnsmasq configuration directives.

## Using the repository

1. In Home Assistant go to *Settings → Add-ons → Add-on Store*.
2. Open the three-dot menu and choose *Repositories*.
3. Add the repository URL (`https://github.com/Filippo125/ha-ff-addon`).
4. Install the desired add-on from the list.

For in-depth details check each add-on's `config.yaml`, `DOCS.md`, and helper scripts.
