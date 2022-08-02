#!/usr/bin/env bash

source scripts/linux/tools.sh

setUp(){
    MOCK_BASHRC_SOURCE='resources/empty_bashrc'
    MOCK_BASHRC_DESTINATION='/tmp/bashrc'
    MOCK_PROFILE_DESTINATION='/tmp/profile'
    cp "${MOCK_BASHRC_SOURCE}" "${MOCK_BASHRC_DESTINATION}"
    cp "${MOCK_BASHRC_SOURCE}" "${MOCK_PROFILE_DESTINATION}"
}

# test_nvm_config_when_present(){

#     configure_nvm "${MOCK_BASHRC_DESTINATION}"
#     assertTrue "EXPECTED: CONFIG to be present" "is_nvm_config_in_file ${MOCK_BASHRC_DESTINATION}"
# }

test_py_config_when_noting_present(){
    assertFalse "EXPECTED: CONFIG to be not present" "is_pyenv_config_in_file ${MOCK_BASHRC_DESTINATION} ${MOCK_PROFILE_DESTINATION}"
}

test_py_config_when_present(){
    configure_pyenv  ${MOCK_BASHRC_DESTINATION} ${MOCK_PROFILE_DESTINATION}
    assertTrue "EXPECTED: CONFIG to be present" "is_pyenv_config_in_file ${MOCK_BASHRC_DESTINATION} ${MOCK_PROFILE_DESTINATION}"
}

tearDown(){
    rm -f "${MOCK_BASHRC_DESTINATION}"
    unset MOCK_BASHRC_SOURCE
    unset MOCK_BASHRC_DESTINATION
}

. shunit2