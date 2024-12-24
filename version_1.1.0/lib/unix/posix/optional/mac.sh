# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

is_existing_user(){
    #Check if user name exists on Mac
    # Params:
    # - user_name, user name to check
    # Depends on:
    # - variables.sh ( via is_macos )
    # - functions.sh
    # Retruns: NOT_IMPLEMENTED
    #
    # Note: not implemented for Mac
    local user_name="$1"
    return $NOT_IMPLEMENTED
}

create_user(){
    #Create user on Mac
    # Params:
    # - user_name , user_name to create
    # Depends on:
    # - variables.sh ( via is_macos )
    # - functions.sh
    # Retruns: NOT_IMPLEMENTED
    #
    # Note: not implemented for Mac  and, when you implement, ensure to check if is existing user before using this
    local user_name="$1"
    return $NOT_IMPLEMENTED   
}

set_hostname(){
    # set/change hostname on Linux
    # Params:
    # - name , new hostname
    # Depends on:
    # - variables.sh ( via is_macos )
    # Retruns: Boolean 
    #
    # Note: ensure to check if hostname is same as current hostname
    local name="$1"
    return $NOT_IMPLEMENTED
}

setup_options_usage(){
    return $NOT_IMPLEMENTED
}

setup_options(){
    # read CLI options , this is not implemented for Mac
    return $NOT_IMPLEMENTED
}