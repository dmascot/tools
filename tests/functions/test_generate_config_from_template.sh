#!/usr/bin/env bash

source scripts/functions.sh 

test_generate_template_from_config(){

    export DESIRED_USER="newUser"
    export DESIRED_HOSTNAME="newHost"

    TEMPLATE_SRC='resources/wsl.template'
    TEMPLATE_DEST='/tmp/wsl.conf'

    generate_conf_from_template $TEMPLATE_SRC $TEMPLATE_DEST
    grep -q $DESIRED_USER $TEMPLATE_DEST
    assertTrue $?
    grep -q $DESIRED_HOSTNAME $TEMPLATE_DEST
    assertTrue $?
    
    unset DESIRED_USER
    unset DESIRED_HOSTNAME
    rm -f $TEMPLATE_DEST
}

. shunit2