source scripts/linux/functions.sh

NEW_HOSTNAME='testhostname'
CURRENT_HOSTNAME=$HOSTNAME

test_update_hostname(){
    detect_platform
    #This test should not run in docker environemnt because, docker does not support updating hostnames
    #Potentially we can replace this with mockfile
    ! is_running_as_root || [[ $DETECTED_PLATFORM =~ DOCKER ]] && startSkipping
    assertFalse "Expected: Hostname $NEW_HOSTNAME to be non exisiting" "is_existing_hostname $NEW_HOSTNAME"
    update_hostname $NEW_HOSTNAME
    assertTrue "Expected: Hostname $NEW_HOSTNAME to exists" "is_existing_hostname $NEW_HOSTNAME"

    #set it back to current hostname
    sudo cp /etc/hosts.bak  /etc/hosts
    sudo cp /etc/hostname.bak  /etc/hostname
}

tearDown(){
    unset DETECTED_PLATFORM
}


. shunit2