#!/usr/bin/env bash 

source scripts/functions.sh

NEW_USER='testUser1'

test_add_user_to_sudoers(){
    ! is_running_as_root && startSkipping
    
    assertFalse "Expected:User $NEW_USER to be non sudoer" "is_existing_sudo_user $NEW_USER"

    if is_running_as_root 
    then 
        create_user $NEW_USER
        add_user_to_sudoers $NEW_USER
    fi 
    
    assertTrue "Expected:User $NEW_USER to be sudoer" "is_existing_sudo_user $NEW_USER"

}

tearDown(){
    if is_running_as_root
    then
        sed -i.bak "/$NEW_USER/d" /etc/sudoers
        userdel -r $NEW_USER > /dev/null 2>&1
    fi 
}


. shunit2