# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional/mac.sh"


Describe "setup_options() on Mac" Test:Unit
    
    Skip if "only for Mac"  is_not_mac

    It "it returns NOT_IMPLEMENTED"
        When call setup_options
        The status should equal $NOT_IMPLEMENTED
    End

End