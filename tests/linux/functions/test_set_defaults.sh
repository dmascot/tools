#!/usr/bin/env bash

source scripts/linux/functions.sh

test_docker_defaults(){
    DETECTED_PLATFORM="DOCKER"

    DESIRED_USER="ubuntu"
    DESIRED_HOSTNAME="sandbox"

    set_defaults

    assertEquals "ubuntu" "${DESIRED_USER}"
    assertEquals "sandbox" "${DESIRED_HOSTNAME}"

    unset DETECTED_PLATFORM
}

test_wsl_defaults(){

    DETECTED_PLATFORM="WSL"
     set_defaults
    assertEquals "${USER}" "${DESIRED_USER}"
    assertEquals "${HOSTNAME}" "${DESIRED_HOSTNAME}"

    unset DETECTED_PLATFORM
}

test_GENERIC_defaults(){
    DETECTED_PLATFORM="GENERIC"

    set_defaults
    assertEquals "${USER}" "${DESIRED_USER}"
    assertEquals "${HOSTNAME}" "${DESIRED_HOSTNAME}"

    unset DETECTED_PLATFORM    
}

tearDown(){
    unset DESIRED_USER
    unset DESIRED_HOSTNAME
}

. shunit2