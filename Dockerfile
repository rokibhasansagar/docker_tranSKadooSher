FROM woahbase/alpine-glibc:x86_64

LABEL maintainer="fr3akyphantom <rokibhasansagar2014@outlook.com>"

ENV LANG=C.UTF-8

RUN set -xe \
  && echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN set -xe \
  && apk update -q --force-refresh \
  && apk upgrade -q --no-cache --available \
  && apk add -uU --no-cache --purge \
    alpine-sdk coreutils build-base util-linux bash sudo shadow curl jq ca-certificates git \
    make libc-dev libgcc libstdc++ wget wput rsync sshpass openssh openssl gnupg xterm \
    python3-dev zip unzip tar zlib xz lz4 brotli pixz tree gawk p7zip zstd pigz \
  && find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; 2>/dev/null \
  && rm -rf /var/cache/apk/* /tmp/*

ENV TERM=xterm-256color

RUN set -xe \
  && groupadd --gid 1000 alpine \
  && useradd --uid 1000 --gid alpine --shell /bin/bash --create-home alpine \
  && echo "alpine ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/alpine \
  && chmod 0440 /etc/sudoers.d/alpine

WORKDIR /home

RUN set -xe \
  && curl -sL https://gerrit.googlesource.com/git-repo/+/refs/heads/stable/repo?format=TEXT | base64 --decode > /usr/bin/repo \
  && curl -s https://api.github.com/repos/tcnksm/ghr/releases/latest \
    | jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' | wget -qi - \
  && tar -xzf ghr_*_amd64.tar.gz \
  && cp ghr_*_amd64/ghr /usr/bin/ \
  && rm -rf ghr_* \
  && curl -sL https://github.com/yshalsager/telegram.py/raw/master/telegram.py -o /usr/bin/telegram.py \
  && sed -i '1i #!\/usr\/bin\/python3' /usr/bin/telegram.py \
  && sed -i '1s/python/python3/g' /usr/bin/repo \
  && curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
  && python3 get-pip.py --upgrade --disable-pip-version-check --no-cache-dir \
  && rm -f get-pip.py \
  && pip3 install future requests \
  && find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; 2>/dev/null \
  && chmod a+rx /usr/bin/repo \
  && chmod a+x /usr/bin/ghr /usr/bin/telegram.py

USER alpine

WORKDIR /home/alpine

VOLUME ["/home/alpine", "/projects"]
