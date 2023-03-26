#!/usr/bin/env sh

# Purpose of this script is to determine if user exists and, if so start docker with user login shell and home directory

set -u

user_status=$(id -u > /dev/null 1>&2 ; echo $?)

if [ $user_status -eq 0 ]
then
    USER=${USER:-$(id -u)}
    SHELL=${SHELL:-$(getent passwd "${USER}" | awk -F':' '{print $7}')}
    USER_NAME=$(getent passwd "${USER}" | awk -F':' '{print $1}')
    USER_HOME=$(getent passwd "${USER}" | awk -F':' '{print $6}')

    echo "starting session for $USER_NAME with $SHELL"

    cd "${USER_HOME}"

    $SHELL
fi