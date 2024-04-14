# Copyright (c) 2023 DMascot
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

FROM ubuntu

COPY ./lib/  /usr/local/dmascot/tools_lib
COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint

ENV TZ=Europe/London

RUN apt-get update -y && apt-get install -y tzdata &&\
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
apt-get install -y bash fish zsh git make gettext locales \
build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev&& \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* && \
locale-gen en_US.UTF-8 && \
chmod +x /usr/local/bin/entrypoint && \
git clone https://github.com/edc/bass


USER root

ENTRYPOINT [ "/bin/bash","-c","/usr/local/bin/entrypoint" ]