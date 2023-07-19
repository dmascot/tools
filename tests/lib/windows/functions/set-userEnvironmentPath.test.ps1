# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

BeforeAll {
    . $PWD\lib\windows\functions.ps1
    $global:new_path = "C:\test\path"
}


Describe "Set-UserEnvironmentPath" -Tag 'Unit' {

    it "should set and environment path but not refresh it" {

        Set-UserEnvironmentPath -Path $new_path

        $env:Path -match  [regex]::Escape($new_path) | Should -BeExactly $true
    }

    it "should add path once and only once" {

        Set-UserEnvironmentPath -Path $new_path
        Set-UserEnvironmentPath -Path $new_path
        
        $env:Path -match  [regex]::Escape($new_path) | Should -BeExactly $true

        [regex]::matches($env:Path, [regex]::Escape($new_path)).Count | Should -BeExactly 1

    }

    AfterEach{
        #Remove variable from path
        Remove-Path -Path $new_path
        __refresh_environment_path
    }       
}

AfterAll{
    #Remove global variable
    Remove-Variable -Name new_path -Scope Global
}