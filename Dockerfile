FROM ubuntu

COPY . /tools

RUN apt-get update -y && \
apt-get install -y fish zsh git make gettext locales && \
locale-gen en_US.UTF-8 && \
dpkg-reconfigure locales && \
useradd -m -s /bin/bash bashdev && \ 
useradd -m -s /bin/fish fishdev && \
useradd -m -s /bin/zsh zshdev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/*

USER bashdev
RUN /bin/bash -c 'cd /tools && source setup.sh'

USER zshdev
RUN /bin/zsh -c 'cd /tools && source setup.sh'

USER fishdev
RUN /bin/fish -c 'cd /tools && source setup.fish'

CMD ["tail","-f","/dev/null"]