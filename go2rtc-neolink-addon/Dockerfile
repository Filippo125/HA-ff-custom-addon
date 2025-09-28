# Use Debian base (with S6) so we can apt-get gstreamer/ffmpeg and run glibc binaries
ARG BUILD_FROM="ghcr.io/hassio-addons/debian-base/amd64:stable"
FROM ${BUILD_FROM}

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
RUN curl -L -o /usr/local/bin/go2rtc \
    "https://github.com/AlexxIT/go2rtc/releases/download/v1.9.10/go2rtc_linux_amd64" \
  && chmod +x /usr/local/bin/go2rtc

# Download neolink (prebuilt glibc binaries)
#RUN curl -fsSL "https://github.com/QuantumEntangledAndy/neolink/releases/download/v0.6.3.rc.2/neolink_linux_x86_64_ubuntu.zip" -o /tmp/neolink.zip

#RUN unzip -o /tmp/neolink.zip -d /opt/neolink
#RUN ls -l /opt/neolink
ADD neolink /opt/neolink/neolink
RUN  chmod +x /opt/neolink/neolink && ln -sf /opt/neolink/neolink /usr/local/bin/neolink && \
  rm -f /tmp/neolink.zip

# Copy entrypoint and talk script
COPY run.sh /run.sh
RUN chmod +x /run.sh
COPY rootfs/ /
RUN chmod +x /usr/local/bin/neolink_talk.sh

CMD [ "/run.sh" ]
