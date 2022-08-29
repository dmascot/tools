#!/usr/bin/env bash 

source scripts/linux/functions.sh

NEW_USER='testUser1'

test_create_user(){
    #This test needs sudo/root access, if that is not the case skip it
    ! is_running_as_root && startSkipping
    assertFalse "Expected:User $NEW_USER to be non existing" "is_existing_user $NEW_USER"

    if is_running_as_root; then  create_user $NEW_USER 2000; fi 

    assertTrue "Expected:User $NEW_USER to exist" "is_existing_user $NEW_USER"
}

tearDown(){
    #This test needs sudo/root access, if that is not the case skip it
    if is_running_as_root
    then 
        userdel -r $NEW_USER > /dev/null 2>&1
    fi 

}

. shunit2