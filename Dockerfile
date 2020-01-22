FROM woahbase/alpine-glibc:x86_64
#
LABEL maintainer="fr3akyphantom <rokibhasansagar2014@outlook.com>"
LABEL Description="This Alpine based image is used to run tranSKadooSH Projects"
#
ARG PUID=1000
ARG PGID=1000
ENV LANG=C.UTF-8
#
RUN set -xe \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
#
RUN set -xe \
  && apk add -uU --no-cache --purge \
    alpine-sdk coreutils bash sudo shadow curl ca-certificates openssl git \
    make libc-dev gcc libstdc++ wget wput megatools rsync sshpass \
    python3 zip unzip p7zip bzip2 gzip tar \
  && rm -rf /var/cache/apk/* /tmp/*
#
RUN set -xe \
    && groupadd --gid ${PGID} alpine \
    && useradd --uid ${PUID} --gid alpine --shell /bin/bash --create-home alpine \
    && echo 'alpine ALL=NOPASSWD: ALL' >> /etc/shadow
#
USER alpine
#
VOLUME /home/alpine/
WORKDIR /home/alpine/project/
