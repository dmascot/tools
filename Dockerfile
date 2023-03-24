FROM ubuntu

COPY . /tools

RUN apt-get update -y && \
apt-get install -y bash fish zsh git make gettext curl && \
useradd -m -s /bin/bash bashdev && \ 
useradd -m -s /bin/fish fishdev && \
useradd -m -s /bin/zsh zshdev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/*

USER bashdev
RUN cd /tools && cat install.sh | /bin/bash

USER zshdev
RUN cd /tools && cat install.sh | /bin/zsh

USER fishdev
RUN cd /tools && cat install.fish| /bin/fish

USER root
RUN rm -rf /tools

USER bashdev

CMD ["tail","-f","/dev/null"]