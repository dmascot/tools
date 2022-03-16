source scripts/functions.sh


test_is_running_as_root_with_non_root(){

    ! is_running_as_root && startSkipping

    if is_running_as_root
    then
        NEW_USER='sudo_test_user'
        create_user $NEW_USER
        result=$(sudo -u $NEW_USER bash -c 'source scripts/functions.sh; is_running_as_root')
    fi
    
    assertEquals 1 $?

    if is_running_as_root;then userdel -r -f $NEW_USER > /dev/null 2>&1 ; fi 

}

test_is_running_as_root_with_sudo(){

    ! is_running_as_root && startSkipping

    if is_running_as_root; then result=$(sudo -u root bash -c 'source scripts/functions.sh; is_running_as_root'); fi 

    assertEquals 0 $?

}


. shunit2