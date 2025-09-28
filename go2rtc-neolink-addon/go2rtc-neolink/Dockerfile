# Use Debian base (with S6) so we can apt-get gstreamer/ffmpeg and run glibc binaries
ARG BUILD_FROM
FROM $BUILD_FROM

ARG GO2RTC_VERSION=1.9.3
ARG NEOLINK_REPO=QuantumEntangledAndy/neolink
ARG NEOLINK_TAG=latest

ENV DEBIAN_FRONTEND=noninteractive

# Core deps: ffmpeg, gstreamer (for 'neolink talk'), jq for reading add-on options.json
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl unzip ffmpeg jq \
    libgstreamer1.0-0 gstreamer1.0-tools \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-alsa gstreamer1.0-libav gstreamer1.0-x \
 && rm -rf /var/lib/apt/lists/*

# Download go2rtc static binary (select correct asset by dpkg arch)
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "$arch" in \
    amd64) GO2RTC_ASSET="go2rtc_linux_amd64" ;; \
    arm64) GO2RTC_ASSET="go2rtc_linux_arm64" ;; \
    armhf|arm) GO2RTC_ASSET="go2rtc_linux_arm" ;; \
    i386) GO2RTC_ASSET="go2rtc_linux_i386" ;; \
    *) echo "Arch non supportata: $arch"; exit 1 ;; \
  esac; \
  curl -L -o /usr/local/bin/go2rtc \
    "https://github.com/AlexxIT/go2rtc/releases/download/v${GO2RTC_VERSION}/${GO2RTC_ASSET}" \
  && chmod +x /usr/local/bin/go2rtc

# Download neolink (prebuilt glibc binaries; fallback to nightly artifacts)
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  mkdir -p /opt/neolink; \
  # Try nightly.link for maintained fork assets
  if curl -fsSLI "https://github.com/${NEOLINK_REPO}/releases/${NEOLINK_TAG}" >/dev/null 2>&1; then \
    for URL in \
      "https://nightly.link/${NEOLINK_REPO}/workflows/build/${NEOLINK_TAG}/neolink_linux_${arch}.zip" \
      "https://nightly.link/${NEOLINK_REPO}/workflows/build/${NEOLINK_TAG}/release-${arch}.zip" \
    ; do \
      if curl -fSL "$URL" -o /tmp/neolink.zip; then break; fi; \
    done; \
  fi; \
  if [ ! -s /tmp/neolink.zip ]; then \
    # Fallback to historical repo nightly builds with debian-based artifacts
    case "$arch" in \
      amd64) NURL="https://nightly.link/thirtythreeforty/neolink/workflows/build/master/release-x86_64-bionic.zip" ;; \
      arm64) NURL="https://nightly.link/thirtythreeforty/neolink/workflows/build/master/release-arm64-buster.zip" ;; \
      armhf) NURL="https://nightly.link/thirtythreeforty/neolink/workflows/build/master/release-armhf-buster.zip" ;; \
      *) echo "Nessun asset precompilato per $arch"; exit 1 ;; \
    esac; \
    curl -fSL "$NURL" -o /tmp/neolink.zip; \
  fi; \
  apt-get update && apt-get install -y --no-install-recommends unzip && \
  unzip -o /tmp/neolink.zip -d /opt/neolink && \
  chmod +x /opt/neolink/neolink && ln -sf /opt/neolink/neolink /usr/local/bin/neolink && \
  rm -rf /var/lib/apt/lists/* /tmp/neolink.zip

# Copy entrypoint and talk script
COPY run.sh /run.sh
RUN chmod +x /run.sh
COPY rootfs/ /
RUN chmod +x /usr/local/bin/neolink_talk.sh

CMD [ "/run.sh" ]
