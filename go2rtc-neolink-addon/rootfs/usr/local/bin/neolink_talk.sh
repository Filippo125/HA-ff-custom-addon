#!/bin/bash
# Read A-Law 8kHz mono from STDIN (WebRTC backchannel) -> WAV -> neolink talk
set -euo pipefail

ffmpeg -hide_banner -loglevel error -fflags nobuffer \
  -f alaw -ar 8000 -ac 1 -i - -f wav -  \
| neolink talk Doorbell -c /etc/neolink.toml -m -i "fdsrc fd=0"
