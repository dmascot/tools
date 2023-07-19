# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "is_existing_directory()" Test:Unit

    Parameters
    #   DIRECTORY PATH  EXPECTED STATUS
        "$HOME"         "True"  $TRUE
        "/some/path"   "False" $FALSE
    End

    It "is $2 for path $1"
        When call is_existing_directory "$1"
        The status should equal $3
    End

End
