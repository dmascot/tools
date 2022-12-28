#!/usr/bin/env bash
# set SSH_PRIVATE_KEY in .bashrc to use this functionality 
# source /location/to/keychain.sh

if [ ! -z $SSH_PRIVATE_KEY ]
then 
    /usr/bin/keychain -q --nogui $SSH_PRIVATE_KEY
    source $HOME/.keychain/$HOSTNAME-sh
fi 