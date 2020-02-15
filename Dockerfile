FROM woahbase/alpine-glibc:x86_64

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="tranSKadooSHer" \
  org.label-schema.description="Alpine based image usable for running tranSKadooSH Projects" \
  org.label-schema.url="https://rokibhasansagar.github.io" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.vendor="Rokib Hasan Sagar" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

LABEL maintainer="fr3akyphantom <rokibhasansagar2014@outlook.com>"

ARG PUID=1000
ARG PGID=1000
ENV LANG=C.UTF-8

RUN set -xe \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN set -xe \
  && apk add -uU --no-cache --purge \
    alpine-sdk coreutils bash sudo shadow curl ca-certificates git \
    make libc-dev libstdc++ wget wput rsync sshpass openssh openssl \
    python3 zip unzip tar xz tree \
  && rm -rf /var/cache/apk/* /tmp/*

RUN set -xe \
  && groupadd --gid ${PGID} alpine \
  && useradd --uid ${PUID} --gid alpine --shell /bin/bash --create-home alpine \
  && echo 'alpine ALL=NOPASSWD: ALL' >> /etc/shadow

RUN set -xe \
  && git clone https://github.com/krasCGQ/pxz --depth 1 /tmp/pxz \
  && cd /tmp/pxz \
  && make all install \
  && cd - \
  && which pxz

RUN set -xe \
  && curl -sL https://github.com/akhilnarang/repo/raw/master/repo -o /usr/bin/repo \
  && curl -s https://api.github.com/repos/tcnksm/ghr/releases/latest | grep "browser_download_url" | grep "amd64.tar.gz" | cut -d '"' -f 4 | wget -qi - \
  && tar -xzf ghr_*_amd64.tar.gz \
  && cp ghr_*_amd64/ghr /usr/bin/ \
  && rm -rf ghr_* \
  && curl -sL https://github.com/fabianonline/telegram.sh/raw/master/telegram -o /usr/bin/telegram \
  && sed -i '1s/python/python3/g' /usr/bin/repo \
  && chmod a+x /usr/bin/repo /usr/bin/ghr /usr/bin/telegram

USER alpine

VOLUME [/home/alpine/]
