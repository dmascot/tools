source scripts/linux/functions.sh

NEW_HOSTNAME='testhostname'

test_update_hostname(){
    detect_environment
    #This test should not run in docker environemnt because, docker does not support updating hostnames
    #Potentially we can replace this with mockfile
    ! is_running_as_root || [[ $DETECTED_ENVIRONMENT =~ DOCKER ]] && startSkipping
    assertFalse "Expected: Hostname $NEW_HOSTNAME to be non exisiting" "is_existing_hostname $NEW_HOSTNAME"
    update_hostname $NEW_HOSTNAME
    assertTrue "Expected: Hostname $NEW_HOSTNAME to exists" "is_existing_hostname $NEW_HOSTNAME"
}

tearDown(){

    if is_running_as_root && ! [[ $DETECTED_ENVIRONMENT =~ DOCKER ]]
    then 
        mv /etc/hosts.bak /etc/hosts.bak 
        mv /etc/hostname.bak /etc/hostname
    fi 
    unset DETECTED_ENVIRONMENT
}


. shunit2