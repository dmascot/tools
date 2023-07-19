# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional.sh"


Describe "is_existing_user()" Test:Integration
 
    Context "on Linux"
        Skip if "only for Linux" is_not_linux

        Parameters
        #   USER                RETURN STATUS
            "$USER"             "True"  $TRUE
            "does_not_exist"    "False" $FALSE
        End
    

        It "is $2 for user $1"
            When call is_existing_user "$1"
            The status should equal $3
        End

    End

    Context "on Mac"

        Skip if "only for Mac"  is_not_mac
        
        Parameters
        #   USER        RETURN STATUS
            "AnyUser"   "Not Implemented"  $NOT_IMPLEMENTED
        End
    

        It "is $2 for user $1"
            When call is_existing_user "$1"
            The status should equal $3
        End

    End
End