# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "logger()" Test:Unit
    It  "print expected messsage"
        local expected_message="this is expected"
        When call logger "$expected_message"
        The output should equal "$expected_message"
    End 
End