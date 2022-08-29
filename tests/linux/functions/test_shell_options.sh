#!/usr/bin/env bash

source scripts/linux/functions.sh

test_functions_without_args(){
  
    shell_options
    assertEquals "" "${DESIRED_USER}"
    assertEquals "" "${DESIRED_HOSTNAME}"
    unset $DESIRED_USER $DESIRED_HOSTNAME
}

test_functions_with_user(){
    ARGS=('-u' 'justme')
    shell_options "${ARGS[@]}"
    assertEquals "justme" "${DESIRED_USER}"
    assertEquals "" "${DESIRED_HOSTNAME}"
}

test_functions_with_hostname(){
    ARGS=('-n' 'devbox')
    shell_options "${ARGS[@]}"
    assertEquals "" "${DESIRED_USER}"
    assertEquals "devbox" "${DESIRED_HOSTNAME}"
}

test_functions_with_user_and_hostname(){
    ARGS=('-u' 'justme' '-n' 'devbox')
    shell_options "${ARGS[@]}"
    assertEquals "justme" "${DESIRED_USER}"
    assertEquals "devbox" "${DESIRED_HOSTNAME}"
}


test_functions_with_long_options_user(){
    ARGS=('--user' 'justme')
    shell_options "${ARGS[@]}"
    assertEquals "justme" "${DESIRED_USER}"
    assertEquals "" "${DESIRED_HOSTNAME}"
}


test_functions_with_long_options_hostname(){
    ARGS=('--hostname' 'devbox')
    shell_options "${ARGS[@]}"
    assertEquals "" "${DESIRED_USER}"
    assertEquals "devbox" "${DESIRED_HOSTNAME}"
}

test_functions_with_long_options_user_and_hostname(){
    ARGS=('--user' 'justme' '--hostname' 'devbox')
    shell_options "${ARGS[@]}"
    assertEquals "justme" "${DESIRED_USER}"
    assertEquals "devbox" "${DESIRED_HOSTNAME}"
}

tearDown(){
    unset DESIRED_USER
    unset DESIRED_HOSTNAME
}
. shunit2