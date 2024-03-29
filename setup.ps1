# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

. $PWD\lib\windows\functions.ps1
. $PWD\lib\windows\tools.ps1

function setup() {

    Install-Git
    Get-PoshGit
    Install-NVM
    Install-Pyenv
}

setup