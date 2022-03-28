#!/usr/bin/env bash

source scripts/functions.sh

test_install_package(){
    package_name='vim'

    is_package_installed $package_name || ! is_running_as_root && startSkipping

    if ! is_package_installed $package_name && is_running_as_root; then install_packages $package_name ; fi 

    assertTrue "is_package_installed $package_name"
    
    if is_running_as_root;then apt-get remove -y $package_name > /dev/null 2>&1 ; fi 
    
    assertFalse "is_package_installed $package_name"    
}

. shunit2