#!/usr/bin/env bash

source scripts/functions.sh

test_exisiting_sudo_user(){
    #This test needs sudo/root access, if that is not the case skip it
    ! is_running_as_root && startSkipping
    TEST_USER='root'
    assertTrue "Expected: User $TEST_USER to be sudoer" "is_existing_sudo_user $TEST_USER"
}

test_non_exisiting_sudo_user(){
    #This test needs sudo/root access, if that is not the case skip it
    ! is_running_as_root && startSkipping
    TEST_USER='someuser'
    assertFalse "Expected: User $TEST_USER to be non sudoer" "is_existing_sudo_user $TEST_USER"
}

. shunit2