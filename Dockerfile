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
        libdaemon-dev \
        popt-dev \
        alsa-lib-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        cargo \
        libasound2-data\
        libasound2-dev\
        libasound2-plugins\
        libasound2\
        libssl-dev\
        pkg-config\
        rustc\
 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd shairport-sync \
 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-libasound2 \
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
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        libasound2-dev \
        libssl-dev \
        pkg-config \
        rustc \
 && apk add \
        dbus \
        libdaemon \
        alsa-lib \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
        libasound2-plugins\
        libasound2\
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
    io.hass.name="Shairport Sync forked" \
    io.hass.description="Shairport Sync for Hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Maido Käära <m@maido.io>"
