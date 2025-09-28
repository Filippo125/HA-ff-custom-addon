#!/usr/bin/with-contenv sh
set -eu

OPTS="/data/options.json"
CAM_IP="$(jq -r '.camera_ip' "${OPTS}")"
USER="$(jq -r '.username' "${OPTS}")"
PASS="$(jq -r '.password' "${OPTS}")"
STREAM="$(jq -r '.stream' "${OPTS}")"
EXTRA="$(jq -r '.extra_streams // empty' "${OPTS}")"

# 1) neolink config for 'talk'
cat >/etc/neolink.toml <<EOF
bind = "0.0.0.0"

[[cameras]]
name = "Doorbell"
username = "${USER}"
password = "${PASS}"
address = "${CAM_IP}:9000"
EOF

# 2) go2rtc config (FLV low-latency + RTSP fallback + backchannel exec)
mkdir -p /data
cat >/data/go2rtc.yaml <<EOF
streams:
  doorbell_${STREAM}:
    - >-
      ffmpeg:http://${CAM_IP}/flv?port=1935&app=bcs&stream=channel0_${STREAM}.bcs&user=${USER}&password=${PASS}#video=copy#audio=opus
    - rtsp://${USER}:${PASS}@${CAM_IP}:554/h264Preview_01_${STREAM}
    - exec:/usr/local/bin/neolink_talk.sh#backchannel=1
${EXTRA}
api:
  listen: :1984
rtsp:
  listen: :8554
EOF

echo "[go2rtc-neolink] Starting go2rtc with /data/go2rtc.yaml ..."
exec /usr/local/bin/go2rtc -config /data/go2rtc.yaml
