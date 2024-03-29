# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "is_current_hostname()" Test:Unit

    Parameters
    #   HOSTNAME        RESULT STATUS   
        "$(hostname)"   "True"  $TRUE
        "someName"      "False" $FALSE
    End

    It "is $2 when hostname is $1"
        When call is_current_hostname "$1"
        The status should equal $3
    End

End
