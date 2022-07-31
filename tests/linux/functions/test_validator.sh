#!/usr/bin/env bash

source scripts/linux/functions.sh

test_with_two_unset_variable(){
    unset DETECTED_OS
    unset DETECTED_ENVIRONMENT

    assertFalse "Expected: fail" "validator"
}

test_with_one_unset_variable(){
    DETECTED_OS="Ubuntu"
    unset DETECTED_ENVIRONMENT

    assertFalse "Expected: fail" "validator"
}

test_with_invalid_os(){
    DETECTED_OS="WhatOS"
    DETECTED_ENVIRONMENT="WSL"
    assertFalse "Expected: fail" "validator"
}

test_with_invalid_environment(){
    DETECTED_OS="Ubuntu"
    DETECTED_ENVIRONMENT="SOMETHING"

    assertFalse "Expected: fail" "validator"
}

test_with_valid_variable(){
    DETECTED_OS="Ubuntu"
    DETECTED_ENVIRONMENT="WSL"
    assertTrue "Expected: pass" "validator"
}

tearDown(){
    unset DETECTED_OS
    unset DETECTED_ENVIRONMENT 
}

. shunit2