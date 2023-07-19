# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\tools.ps1
}

Describe "Get-PoshGit" -Tag 'Integration' {

    it "should install posh-git module and, add it to user profile" {
        Get-PoshGit

        isModuleInstalled -ModuleName 'posh-git' | Should -BeExactly $true

        $content = Get-Content $PROFILE

        $match = "Import-Module posh-git"
        [regex]::matches($content,$match) | Should -Be $match
    }

    it "should add profile entry once and only once" {

        Get-PoshGit
        Get-PoshGit

        $content = Get-Content $PROFILE

        $match = "Import-Module posh-git"
        [regex]::matches($content,$match).Count | Should -BeExactly 1
    }

}