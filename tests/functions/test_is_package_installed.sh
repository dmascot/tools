#!/usr/bin/env bash

source scripts/functions.sh

test_is_known_package_installed(){
    package_name='coreutils'
    assertTrue "Expected: package $package_name to be installed" "is_package_installed $package_name"
}

test_is_unknown_package_installed(){
    package_name='this-should-never-exist'
    assertFalse "Expected: package $package_name to be non existing" "is_package_installed $package_name"
}

. shunit2