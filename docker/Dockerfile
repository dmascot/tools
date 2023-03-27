FROM ubuntu

COPY . /tools
COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint

RUN apt-get update -y && \
apt-get install -y bash fish zsh git make gettext curl && \
useradd -m -s /bin/bash bashdev && \ 
useradd -m -s /bin/fish fshdev && \
useradd -m -s /bin/zsh zshdev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* && \
chmod +x /usr/local/bin/entrypoint && \
git clone https://github.com/edc/bass

USER bashdev
RUN cd /tools && cat install.sh | /bin/bash

USER zshdev
RUN cd /tools && cat install.sh | /bin/zsh

USER fshdev
RUN cd /bass && make install && cd - && \
cd /tools && cat install.fish | /bin/fish

USER root
RUN rm -rf /tools && \
rm -rf /bass

#default user is bashdev
USER bashdev

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]