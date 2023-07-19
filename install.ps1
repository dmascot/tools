# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

$REPOSITORY = "https://github.com/dmascot/tools.git"

$DEST_DIR = [IO.Path]::Combine($env:TEMP, "tools")

function Test-Prerequisites {
    $counter = Get-Command "git" -ErrorAction Ignore | Measure-Object

    if ( $counter.Count -eq 0 ) { return $false }

    return $true
}

function Get-ToolsScripts() {
    Write-Output "Cloning tools repository to $DEST_DIR"
    git clone $REPOSITORY $DEST_DIR | Out-Null
}

function Install-Tools() {
    $SETUP_SCRIPT = [IO.Path]::Combine($DEST_DIR, "setup.ps1")
    Set-Location $DEST_DIR
    Invoke-Expression $SETUP_SCRIPT
}
function Remove-ToolsScripts {
    Set-Location $env:HOMEPATH
    Remove-Item -Recurse -Force $DEST_DIR
}
function main() {

    if (Test-Prerequisites) {
        Get-ToolsScripts
        Install-Tools
        Remove-ToolsScripts
    }
}

main