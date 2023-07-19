#!/usr/bin/env bash
# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# set SSH_PRIVATE_KEY in .bashrc to use this functionality 
# source /location/to/keychain.sh

if [ ! -z $SSH_PRIVATE_KEY ]
then 
    /usr/bin/keychain -q --nogui $SSH_PRIVATE_KEY
    source $HOME/.keychain/$HOSTNAME-sh
fi 