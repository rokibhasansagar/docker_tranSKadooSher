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

ENV LANG=C.UTF-8

RUN set -xe \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN set -xe \
  && apk add -uU --no-cache --purge \
    alpine-sdk coreutils build-base util-linux bash sudo shadow curl ca-certificates git \
    make libc-dev zlib libstdc++ wget wput rsync sshpass openssh openssl gnupg \
    python3 py3-pip zip unzip tar xz pixz tree gawk p7zip \
  && rm -rf /var/cache/apk/* /tmp/*

RUN set -xe \
  && groupadd --gid 1000 alpine \
  && useradd --uid 1000 --gid alpine --shell /bin/bash --create-home alpine \
  && echo "alpine ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/alpine \
  && chmod 0440 /etc/sudoers.d/alpine

RUN set -xe \
  && curl -sL https://github.com/GerritCodeReview/git-repo/raw/stable/repo -o /usr/bin/repo \
  && curl -s https://api.github.com/repos/tcnksm/ghr/releases/latest | grep "browser_download_url" | grep "amd64.tar.gz" | cut -d '"' -f 4 | wget -qi - \
  && tar -xzf ghr_*_amd64.tar.gz \
  && cp ghr_*_amd64/ghr /usr/bin/ \
  && rm -rf ghr_* \
  && curl -sL https://github.com/yshalsager/telegram.py/raw/master/telegram.py -o /usr/bin/telegram.py \
  && sed -i '1i #!\/usr\/bin\/python3' /usr/bin/telegram.py \
  && pip3 install requests \
  && sed -i '1s/python/python3/g' /usr/bin/repo \
  && chmod a+rx /usr/bin/repo \
  && chmod a+x /usr/bin/ghr /usr/bin/telegram.py

USER alpine

VOLUME [/home/alpine/]
