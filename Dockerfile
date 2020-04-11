ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential=12.4ubuntu1 \
        cargo=0.40.0-3ubuntu1~18.04.1 \
        git=1:2.17.1-1ubuntu0.5 \
        libasound2-data=1.1.3-5ubuntu0.2 \
        libasound2-dev=1.1.3-5ubuntu0.2 \
        libasound2-plugins=1.1.1-1ubuntu1 \
        libasound2=1.1.3-5ubuntu0.2 \
        libssl-dev=1.1.1-1ubuntu2.1~18.04.5 \
        pkg-config=0.29.1-0ubuntu2 \
        rustc=1.39.0+dfsg1+llvm-3ubuntu1~18.04.1 \
 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd shairport-sync \
 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
 && make \
 && make install \
 && cd / \
 && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
\
&& apt-get purge -y --auto-remove \
        build-essential \
        cargo \
        git \
        libasound2-dev \
        libssl-dev \
        pkg-config \
        rustc \
    \
 && apk add \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
 && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /lib/apt/lists/*\
        /root/shairport-sync

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Shairport Sync" \
    io.hass.description="Shairport Sync for Hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Maido Käära <m@maido.io>"
