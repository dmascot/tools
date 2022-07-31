. $PWD\scripts\windows\functions.ps1
. $PWD\scripts\windows\tools.ps1

function Initialize-dev-box(){
    Install-Git
    Get-PoshGit
    Install-NVM
    Install-Pyenv
}

Initialize-dev-box