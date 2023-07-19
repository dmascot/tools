# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\tools.ps1
}

Describe "Install-Pyenv" -Tag 'Integration' {

    it "should install Pyenv" {
        Install-Pyenv

        isCommandInstalled -commandName 'pyenv' | Should -BeExactly $true
    }
}