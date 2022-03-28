#!/usr/bin/env bash

source scripts/functions.sh

test_docker_defaults(){
    DETECTED_ENVIRONMENT="DOCKER"

    assertTrue "set_defaults"
    set_defaults
    assertEquals "ubuntu" "${DESIRED_USER}"
    assertEquals "sandbox" "${DESIRED_HOSTNAME}"

    unset DETECTED_ENVIRONMENT
}

test_wsl_defaults(){

    DETECTED_ENVIRONMENT="WSL"

    assertTrue "set_defaults"
    set_defaults
    assertEquals "${USER}" "${DESIRED_USER}"
    assertEquals "${HOSTNAME}" "${DESIRED_HOSTNAME}"

    unset DETECTED_ENVIRONMENT
}

test_unsupported_defaults(){
    DETECTED_ENVIRONMENT="UNSUPPORTED"

    assertFalse "set_defaults"

    unset DETECTED_ENVIRONMENT    
}

tearDown(){
    unset DESIRED_USER
    unset DESIRED_HOSTNAME
}

. shunit2