. $PWD\lib\windows\functions.ps1


function Install-Git() {
    #Download git scm installer

    if ( -not (isCommandInstalled -commandName "git" )) {
        $GIT_Base_URL = "https://git-scm.com/download/win"
        $Req = Invoke-WebRequest -UseBasicParsing -Uri $GIT_Base_URL
        $DownloadLink = ($req.Links | Where-Object outerhtml -match "64-bit Git for Windows Setup").href

        $outFile = Get-Web-File -Url $DownloadLink

        if ( -not ( Test-Path -Path $outFile -PathType Leaf ) ) { throw "File Does not exist" }

        Start-Process $outFile -ArgumentList "/SILENT" -Wait

        Set-UserEnvironmentPath -Path "C:\Program Files\Git\cmd"
    }
}

function Get-PoshGit {

    #Install Git-Posh and add Import-Module posh-git to $PROFILE

    $module_name = "posh-git"

    $profile_string = "Import-Module $module_name"

    if ( -not (isModuleInstalled -ModuleName $module_name)) {
        Get-Module -ModuleName $module_name
    }
    else {
        Write-Information "$module_name is already installed"
    }

    if ( -not (Test-Path -Path $PROFILE -PathType Leaf )) {
        New-Item -ItemType File -Path $PROFILE -Force
    }

    #If import-module string does not exist in the Profile add it
    $porifle_string_status = Select-String -Path $PROFILE -Pattern $profile_string
    if ( $null -eq $porifle_string_status) {
        $current_content = Get-Content $PROFILE
        $new_content = New-Object System.Collections.ArrayList

        foreach ($content in $current_content) {
            $new_content.Add($content)
        }

        $new_content.Add($profile_string) | Out-Null

        $new_content | Out-File $PROFILE
    }

}


function Install-NVM {
    # Install NVM and, set the path

    if (-not(isCommandInstalled -commandName "nvm" )) {
        $BASE_URL = "https://github.com"
        $NVM_URL = $BASE_URL + "/coreybutler/nvm-windows/releases/latest"
        $DOWNLOAD_FILE = "nvm-setup.exe"
        $DOWNLOAD_URL = $BASE_URL + "/coreybutler/nvm-windows/releases/download/"

        $Req = Invoke-WebRequest -UseBasicParsing  -Uri $NVM_URL

        $LATEST_VERSION = $Req.BaseResponse.RequestMessage.RequestUri.Segments[-1]

        $DownloadLink = $DOWNLOAD_URL.Trim("/") + "/" + $LATEST_VERSION.Trim("/") + "/" + $DOWNLOAD_FILE.Trim("/")

        Write-Output $DownloadLink

        $outFile = Get-Web-File -Url $DownloadLink

        if ( -not ( Test-Path -Path $outFile -PathType Leaf ) ) { throw "File Does not exist" }

        Unblock-File $outFile
        Start-Process $outFile -ArgumentList "/SILENT" -Wait

        Set-UserEnvironmentPath -Path "$env:HOME\AppData\Roaming\nvm"
        Set-UserEnvironmentPath -Path "$env:ProgramFiles\nodejs"

        Remove-Path -Path "%NVM_HOME%"
        Remove-Path -Path "%NVM_SYMLINK%"

        __refresh_environment_path
    }
}


function Install-Pyenv {
    #install pywin-env

    if (-not (isCommandInstalled -commandName "pyenv") ) {
        $DownloadLink = "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1"

        $outFile = Get-Web-File -Url $DownloadLink

        & $outFile

        __refresh_environment_path
    }
}