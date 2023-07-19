# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\tools.ps1
}

Describe "Install-Git" -Tag 'Integration' {

    it "should install git scm and , add path to environmnet" {
        Install-Git

        isCommandInstalled -commandName 'git' | Should -BeExactly $true

        $env:Path -match  [regex]::Escape("C:\Program Files\Git\cmd") | Should -BeExactly $true
    }
}