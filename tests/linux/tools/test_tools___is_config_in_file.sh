#!/usr/bin/env bash

source scripts/linux/tools.sh

setUp(){
    MOCK_FILE_SOURCE='resources/empty_bashrc'
    MOCK_FILE_DESTINATION='/tmp/bashrc'
    cp "${MOCK_FILE_SOURCE}" "${MOCK_FILE_DESTINATION}"
}

test___is_config_in_file_config_not_present(){
   assertFalse "Expected: config be not present"  "__is_config_in_file ${MOCK_FILE_DESTINATION} \"This CONFIG is not there\""
}

test___is_config_in_file_config_present(){
   assertTrue "Expected: config to be present" "__is_config_in_file ${MOCK_FILE_DESTINATION} \"mock\""
}

test___is_config_in_file_missing_config_file(){
    __is_config_in_file '' 'This config'
    assertEquals 12 $?
}

test___is_config_in_file_missing_config_check(){
    __is_config_in_file ${MOCK_FILE_DESTINATION} ''
    assertEquals 13 $?
}

tearDown(){
    rm -f "${MOCK_FILE_DESTINATION}"
    unset MOCK_FILE_SOURCE
    unset MOCK_FILE_DESTINATION
}

. shunit2