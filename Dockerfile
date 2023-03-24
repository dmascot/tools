FROM ubuntu

COPY . /tools

RUN apt-get update -y && \
apt-get install -y fish zsh git make gettext locales && \
locale-gen en_US.UTF-8 && \
dpkg-reconfigure locales && \
useradd -m -s /usr/bin/bash bashdev && \ 
useradd -m -s /usr/bin/fish fishdev && \
useradd -m -s /usr/bin/zsh zshdev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/*

RUN su --login bashdev -c 'cd /tools && source setup.sh' && \
su --login zshdev -c 'cd /tools && source setup.sh' && \
su --login fishdev -c 'git clone https://github.com/edc/bass .bass && cd .bass && make install && cd /tools && source setup.fish'

USER bashdev

CMD ["tail","-f","/dev/null"]