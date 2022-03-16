#!/usr/bin/env bash

source scripts/tools.sh

setUp(){
    MOCK_FILE_SOURCE='resources/empty_bashrc'
    MOCK_FILE_DESTINATION='/tmp/bashrc'
    cp "${MOCK_FILE_SOURCE}" "${MOCK_FILE_DESTINATION}"
}

test_bashGitPrompt_config_when_present(){

    configure_bashGitPrompt "${MOCK_FILE_DESTINATION}"
    assertTrue "EXPECTED: CONFIG to be present" "is_bashGitPrompt_config_in_file ${MOCK_FILE_DESTINATION}"
}

test_bashGitPrompt_config_when_not_present(){
    assertFalse "EXPECTED: CONFIG to be not present" "is_bashGitPrompt_config_in_file ${MOCK_FILE_DESTINATION}"
}

tearDown(){
    rm -f "${MOCK_FILE_DESTINATION}"
    unset MOCK_FILE_SOURCE
    unset MOCK_FILE_DESTINATION
}

. shunit2