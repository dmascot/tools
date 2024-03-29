# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"


        
Describe "is_not_mac()" Test:Unit

    Parameters
    #   SYSTEM          EXPECTED STATUS
        "Darwin"        "False" $FALSE
        "AnythingElse"  "True"  $TRUE
    End

    It "is $2 when $1"
        UNIX_SYSTEM_ORI="$UNIX_SYSTEM"

        UNIX_SYSTEM="$1"
        When call is_not_mac
        The status should equal $3

        UNIX_SYSTEM="$UNIX_SYSTEM_ORI"
    End

End