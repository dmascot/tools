# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

FROM ubuntu

COPY . /tools
COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint

ENV TZ=Europe/London

RUN apt-get update -y && apt-get install -y tzdata &&\
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
apt-get install -y bash fish zsh git make gettext locales \
build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev&& \
useradd -m -s /bin/bash bashdev && \ 
useradd -m -s /bin/fish fshdev && \
useradd -m -s /bin/zsh zshdev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* && \
locale-gen en_US.UTF-8 && \
chmod +x /usr/local/bin/entrypoint && \
git clone https://github.com/edc/bass

USER bashdev
RUN /bin/bash -c 'cd /tools && export CURRENT_SHELL=/bin/bash && source setup.sh; echo "setup status: $?"'

USER zshdev
RUN /bin/zsh -c 'cd /tools && export CURRENT_SHELL=/bin/zsh && source setup.sh; echo "setup status: $?" '

USER fshdev
RUN cd /bass && make install && cd - && \
/bin/fish -c 'cd /tools && source setup.fish' 

USER root
RUN rm -rf /tools && \
rm -rf /bass

#this sets bashdev as a default user
USER bashdev

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]