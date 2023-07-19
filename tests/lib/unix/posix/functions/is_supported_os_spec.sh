# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "is_supported_os()" Test:Unit

    Parameters
    #   OS              EXPECTED STATUS
        "OSX"           "True"  $TRUE
        "Ubuntu"        "True"  $TRUE
        "AnythingElse"  "False" $FALSE
    End

    It "is $2 when $1"
    
        When call is_supported_os "$1"
        The status should equal $3

    End

End