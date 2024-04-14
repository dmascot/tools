# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\functions.ps1
}


Describe "Remove-Path" -Tag 'Unit' {


    it "should remove path" {

        $new_path = "C:\test\path"

        Set-UserEnvironmentPath -Path $new_path

        $env:Path -match  [regex]::Escape($new_path) | Should -BeExactly $true

        Remove-Path -Path $new_path

        $env:Path -match  [regex]::Escape($new_path) | Should -BeExactly $false

    }

}
