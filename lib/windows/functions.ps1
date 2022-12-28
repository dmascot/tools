

#Import this module , esle Install-Module/Get-InstalledModule commands would not work
Import-Module -Name PowerShellGet -Scope Local

function Get-Username {
   # Function simply returns current logged in name
    return $env:USERNAME
}

function _webCleint(){
    param(
        [string]$URL,
        [string]$OutFile
    )

    $wc = New-Object net.webclient
    $wc.DownloadFile($URL,$OutFile)
    $wc.Dispose()
}
function Get-Web-File{
    #Function downloads the file and returns download file location
    # Parameters
    #-----------
    # .<URL>
    # .<Direct download link to file>
    # .<SaveAs>
    # <Save file as name, it must have both file name and an extension>
    # .<DownloadPath>
    # <Path where file will be downloaded>
    #
    # Returns
    #--------
    # <Outfile , i.e. file download location >

    param(  [string]$URL,
            [string]$SaveAs,
            [string]$DownloadPath
        )

    #Error: if URL is not supplied
    if ( [string]::IsNullOrEmpty($URL) ) { throw 'Error: $URL can not be an emptry string' }

    #if SaveAs is not supplied, get the filename from url
    if ( [string]::IsNullOrEmpty($SaveAs) ) { $SaveAs = split-path -Leaf $URL }
    
    #if DownloadPath is not supplied, set it to default download directory
    if ( [string]::IsNullOrEmpty($DownloadPath) ) { $DownloadPath = Join-path $env:HOME 'Downloads' }

    #check if  download path exist or throw and error
    if ( -not ( Test-Path -Path $DownloadPath ) ) { throw "Error: $DownloadPath does not exist"}

    $OutFile = Join-Path $DownloadPath $SaveAs

    #throw original exception 
    try { 
        #Invoke-WebRequest -Uri $URL -OutFile $Outfile 
        _webCleint -URL $URL -OutFile $OutFile
    }

    catch {
        throw $_
    }

    return $OutFile
}

function Get-Module(){
    #Install module forcefully without prompt
    param( [string]$ModuleName)
    
    try {  
        Install-Module $ModuleName -Force  -ErrorAction Stop
    }
    catch {
        throw $_
    }
}

function isModuleInstalled(){
    #Returns true if module is installed, false otherwise
    param( [string]$ModuleName)

    $counter = Get-InstalledModule | Where-Object { $_.Name -eq $ModuleName } | Measure-Object

    if( $counter.Count -eq 0 ) { return $false }

    return $true
}

function isCommandInstalled(){
    #Returns true if command is installed, false otherwise
    param( [string]$commandName)

    try {
        $counter = Get-Command $commandName  -ErrorAction Ignore | Measure-Object 

        if( $counter.Count -eq 0 ) { return $false }

        return $true    
    }
    catch {
        return $false
    }
}

function __refresh_environment_path(){
    #Refresh Environment Path after setting it
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Set-UserEnvironmentPath(){
    #Add new path to $env:Path and refresh it
    param(
        [string]$Path
    )

    if( -not ($env:Path -match  [regex]::Escape($Path) ))
    {
        [System.Environment]::SetEnvironmentVariable("PATH",$env:Path+";$Path",[EnvironmentVariableTarget]::User)
    }
    
    __refresh_environment_path

}


function Remove-Path(){
    #Remove Path from the $env:Path for both user and system

    param(
        [string]$Path
    )
    
    if([regex]::matches($env:Path,$match)){
        $system_paths = [System.Environment]::GetEnvironmentVariable("Path","Machine")
        $user_paths = [System.Environment]::GetEnvironmentVariable("Path","User")

        $new_system_path = $system_paths.Replace(";$Path","")
        $new_uer_path = $user_paths.Replace(";$Path","")

        [System.Environment]::SetEnvironmentVariable("PATH",$new_system_path,[EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable("PATH",$new_uer_path,[EnvironmentVariableTarget]::User)

        __refresh_environment_path
    }
}