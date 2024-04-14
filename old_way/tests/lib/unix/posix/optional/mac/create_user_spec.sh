# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional/mac.sh"


Describe "create_user() on Mac" Test:Unit
    
    Skip if "only for Mac"  is_not_mac
    
    Parameters
    #   USER        RETURN STATUS
        "AnyUser"   "Not Implemented"  $NOT_IMPLEMENTED
    End

    It "is $2 for user $1"
        When call create_user "$1"
        The status should equal $3
    End

End