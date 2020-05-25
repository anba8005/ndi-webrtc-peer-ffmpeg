# ffmpeg - http://ffmpeg.org/download.html
#
# From https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
#
# https://hub.docker.com/r/jrottenberg/ffmpeg/
#
#
FROM        ubuntu:focal AS base

WORKDIR     /tmp/workdir

RUN     apt-get -yqq update && \
        apt-get install -yq --no-install-recommends ca-certificates expat libgomp1 && \
        apt-get autoremove -y && \
        apt-get clean -y

ARG        PKG_CONFIG_PATH=/opt/ffmpeg/lib/pkgconfig
ARG        LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG        PREFIX=/opt/ffmpeg
ARG        MAKEFLAGS="-j4"

ENV         FFMPEG_VERSION=4.1.5 \
            FDKAAC_VERSION=0.1.6 \
            OPUS_VERSION=1.3.1 \
            X264_VERSION=20191217-2245-stable \
            SRC=/usr/local

ADD ["NDI SDK for Linux", "/usr/local/ndi/"]

ENV DEBIAN_FRONTEND=noninteractive

RUN      buildDeps="autoconf \
                    automake \
                    cmake \
                    curl \
                    bzip2 \
                    libexpat1-dev \
                    g++ \
                    gcc \
                    git \
                    gperf \
                    libtool \
                    make \
                    nasm \
                    perl \
                    pkg-config \
                    python \
                    libssl-dev \
                    yasm \
                    libavahi-client-dev \
                    libavahi-common-dev \
                    libopus-dev \
                    libva-dev \
                    zlib1g-dev" && \
        apt-get -yqq update && \
        apt-get install -yq --no-install-recommends ${buildDeps}
## x264 http://www.videolan.org/developers/x264.html
RUN \
        DIR=/tmp/x264 && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1 && \
        ./configure --prefix="${PREFIX}" --disable-shared --enable-static --enable-pic --disable-cli && \
        make && \
        make install && \
        rm -rf ${DIR}

RUN  \
        DIR=/tmp/ffmpeg && mkdir -p ${DIR} && cd ${DIR} && \
        curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
        tar -jx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.bz2

RUN \
        DIR=/tmp/ffmpeg && mkdir -p ${DIR} && cd ${DIR} && \
        ./configure \
        --disable-debug \
        --disable-doc \
        --disable-ffplay \
        --disable-ffprobe \
        --enable-libndi_newtek \
        --enable-static \
        --disable-shared \
        --enable-gpl \
        --enable-libx264 \
        --enable-nonfree \
        --enable-libopus \
        --enable-postproc \
        --enable-vaapi \
        --enable-runtime-cpudetect \
        --extra-cflags="-I${PREFIX}/ -I/usr/local/ndi/include" \
        --extra-ldflags="-L${PREFIX}/lib -L/usr/local/ndi/lib/x86_64-linux-gnu" \
        --extra-libs=-ldl \
        --prefix="${PREFIX}" && \
        make && make install && rm -rf ${DIR}

CMD /bin/cp -r /opt/ffmpeg/bin /ffmpeg-install && \
    /bin/cp -r /opt/ffmpeg/lib /ffmpeg-install && \
    /bin/cp -r /opt/ffmpeg/include /ffmpeg-install



