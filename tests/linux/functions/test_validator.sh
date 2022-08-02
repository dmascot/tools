#!/usr/bin/env bash

source scripts/linux/functions.sh

test_with_two_unset_variable(){
    unset DETECTED_OS
    unset DETECTED_PLATFORM
    unset DESIRED_UID
    assertFalse validator
}

test_with_one_unset_variable(){
    DETECTED_OS="Ubuntu"
    unset DETECTED_PLATFORM
    unset DESIRED_UID

    assertFalse validator
}


test_with_two_unset_variable(){
    DETECTED_OS="Ubuntu"
    DETECTED_PLATFORM="WSL"
    unset DESIRED_UID
    
    assertFalse validator
}

test_with_invalid_os(){
    DETECTED_OS="WhatOS"
    DETECTED_PLATFORM="WSL"
    DESIRED_UID=1000
    assertFalse validator
}

test_with_invalid_environment(){
    DETECTED_OS="Ubuntu"
    DETECTED_PLATFORM="SOMETHING"
    DESIRED_UID=1000

    assertFalse validator
}

test_with_invalid_UID(){
    DETECTED_OS="Ubuntu"
    DETECTED_PLATFORM="SOMETHING"
    DESIRED_UID="80000"

    assertFalse validator
}


test_with_valid_variable(){
    DETECTED_OS="Ubuntu"
    DETECTED_PLATFORM="WSL"
    DESIRED_UID=1000
    assertTrue validator
}

tearDown(){
    unset DETECTED_OS
    unset DETECTED_PLATFORM 
    unset DESIRED_UID
}

. shunit2