#!/usr/bin/env bash

shopt -s expand_aliases

. scripts/functions.sh

test_detect_wsl(){
    #mock kernel name
    alias uname="echo 'some-WSL-kernel'"
    alias cat="echo 'init (1, #threads:1)'"
    detect_environment
    assertEquals "WSL" ${DETECTED_ENVIRONMENT}
}

test_detect_docker(){
    #mock kernel name 
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'bash (1, #threads:1)'"

    detect_environment
    assertEquals "DOCKER" ${DETECTED_ENVIRONMENT}
}


test_detect_wsl_docker(){
    #mock kernel name 
    alias uname="echo 'some-WSL-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'bash (1, #threads:1)'"

    detect_environment
    assertEquals "WSL_DOCKER" ${DETECTED_ENVIRONMENT}
}

test_detect_cicircle_docker(){
    #mock kernel name 
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'docker-init (1, #threads:1)'"

    detect_environment
    assertEquals "DOCKER" ${DETECTED_ENVIRONMENT}
}

test_detect_unsupported(){
    #mock kernel name 
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'init (1, #threads:1)'"

    detect_environment
    assertEquals "UNSUPPORTED" ${DETECTED_ENVIRONMENT}
}

tearDown(){
    unalias uname 
    unalias cat
}
. shunit2