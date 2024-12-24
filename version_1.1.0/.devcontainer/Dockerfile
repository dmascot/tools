# Copyright (c) 2023 DMascot
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

FROM ubuntu:latest

RUN apt-get update -y &&\
    apt-get install -y fish zsh make git gettext &&\
    git clone https://github.com/shellspec/shellspec.git /opt/shellspec &&\
    cd /opt/shellspec && make install &&\
    apt-get clean -y &&\
    apt-get autoremove -y
