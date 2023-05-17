. $PWD\lib\windows\functions.ps1
. $PWD\lib\windows\tools.ps1

function setup() {

    Install-Git
    Get-PoshGit
    Install-NVM
    Install-Pyenv
}

setup