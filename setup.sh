# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

source $PWD/lib/unix/posix.sh

is_prerequisites_satisfied && install_tools && return $TRUE || return $FALSE
