#!/usr/bin/env bash

source scripts/functions.sh

test_existing_hostname(){
    assertTrue "Expected: Hostname to exist" "is_existing_hostname $HOSTNAME"
}

test_non_existing_hostname(){
    assertFalse "Expected: Hostname to be non existing" "is_existing_hostname random1234host"
}

. shunit2