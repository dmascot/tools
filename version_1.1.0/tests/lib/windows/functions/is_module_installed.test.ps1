# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\functions.ps1
}

Describe "isModuleInstalled" -Tag 'Unit' {

    it "should return false for non exisiting or not installed module" {
        isModuleInstalled  -ModuleName "somerandomname" | Should -BeExactly $false
    }

    it "should return true for the installed module" {
        isModuleInstalled  -ModuleName "pester" | Should -BeExactly $true
    }    
}