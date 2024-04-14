# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

optional_scripts_path="$(pwd -P )/lib/unix/posix/optional"

case $UNIX_SYSTEM in
    Linux)
    optional_functions='linux.sh'
    ;;
    Darwin)
    optional_functions='mac.sh'   
    ;;
esac

source "$optional_scripts_path/$optional_functions"