#!/usr/bin/env bash

shopt -s expand_aliases

. scripts/linux/functions.sh

grep_pass(){
    echo 1
}

grep_fail(){
    echo 0
}

test_detect_wsl(){
    #mock kernel name
    alias grep=grep_pass
    alias uname="echo 'some-WSL-kernel'"
    alias cat="echo 'init (1, #threads:1)'"
    detect_platform
    assertEquals "WSL" ${DETECTED_PLATFORM}
}


test_detect_docker(){
    #mock kernel name 
    alias grep=grep_pass
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'bash (1, #threads:1)'"

    detect_platform
    assertEquals "DOCKER" ${DETECTED_PLATFORM}
}


test_detect_wsl_docker(){
    #mock kernel name 
    alias grep=grep_pass
    alias uname="echo 'some-WSL-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'bash (1, #threads:1)'"

    detect_platform
    assertEquals "WSL_DOCKER" ${DETECTED_PLATFORM}
}

test_detect_cicircle_docker(){
    #mock kernel name 
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'docker-init (1, #threads:1)'"
    alias grep=grep_pass

    detect_platform
    assertEquals "DOCKER" ${DETECTED_PLATFORM}
}

test_detect_generic(){
    #mock kernel name 
    alias uname="echo 'not-what-you-want-kernel'"
    #mock $(cat /proc/1/sched | head -n 1) which is bash if it is docker and init if it is actual system
    alias cat="echo 'docker-init (1, #threads:1)'"
    alias grep=grep_fail
    detect_platform
    assertEquals "GENERIC" ${DETECTED_PLATFORM}
}

tearDown(){
    unalias uname 
    unalias cat
    unalias grep
}
. shunit2