# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\functions.ps1
}

Describe "Get-Usernane" -Tag 'Unit' {
    IT "must be same as environment username" {
        Get-Username | Should -BeExactly $env:USERNAME
    }
}
