# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\tools.ps1
}

Describe "Install-NVM" -Tag 'Integration' {

    it "should install NVM" {
        Install-NVM

        isCommandInstalled -commandName 'nvm' | Should -BeExactly $true
    }
}