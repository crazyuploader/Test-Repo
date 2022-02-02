#
# Created by Jugal Kishore --- 2020
#
# Speedtest CLI Docker Image
#
# Using Ubuntu as base
FROM ubuntu:latest AS builder

ARG DEBIAN_FRONTEND=noninteractive

# Installing Dependencies
RUN apt-get update && \
    apt-get install -y wget

# Build time Environment Variable
ARG VERSION="1.1.1"

# Setting Work Directory
WORKDIR /tmp

# Install Speedtest CLI
RUN set -e && \
    ARCH=$(arch) && \
    if ! wget --quiet --output-document speedtest.tar.tgz https://install.speedtest.net/app/cli/ookla-speedtest-"${VERSION}"-linux-"${ARCH}".tgz; \
    then \
        echo "Getting Speedtest Failed"; \
        exit 1; \
    fi

# Extracting Speedtest CLI, and putting in /usr/bin
RUN tar xf speedtest.tar.tgz

FROM ubuntu:latest AS runner

# Copy Speedtest CLI binary to /usr/bin
COPY --from=builder /tmp/speedtest /usr/bin

# Accept license & run it
RUN speedtest --accept-license || \
    speedtest --accept-gdpr

ENTRYPOINT ["/usr/bin/speedtest"]
