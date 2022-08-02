#!/usr/bin/env bash

source scripts/linux/functions.sh

test_existing_file(){
    assertTrue "Expected: file to exist" "is_existing_file /etc/passwd"
}

test_existing_file(){
    assertFalse "Expected: file to be non existing" "is_existing_file /etc/thisdoesnotexist"
}

. shunit2