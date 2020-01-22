FROM woahbase/alpine-glibc:x86_64

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="tranSKadooSHer" \
  org.label-schema.description="Alpine based image usable for running tranSKadooSH Projects" \
  org.label-schema.url="https://rokibhasansagar.github.io/docker_tranSKadooSher" \
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
    alpine-sdk coreutils bash sudo shadow curl ca-certificates openssl git \
    make libc-dev gcc libstdc++ wget wput megatools rsync sshpass \
    python3 zip unzip p7zip bzip2 gzip tar \
  && rm -rf /var/cache/apk/* /tmp/*

RUN set -xe \
    && groupadd --gid ${PGID} alpine \
    && useradd --uid ${PUID} --gid alpine --shell /bin/bash --create-home alpine \
    && echo 'alpine ALL=NOPASSWD: ALL' >> /etc/shadow

USER alpine

VOLUME /home/alpine/
WORKDIR /home/alpine/project/
