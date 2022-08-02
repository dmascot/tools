#This script needs to run as an Administrator

function Install-SSHClient(){

    $ssh_client_pagkage = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

    if($ssh_client_pagkage.State -eq 'Installed'){
        Write-Information "$ssh_client_package.Name is already installed..."
    }

    else{
        Write-Information "Installing... $ssh_client_package.Name"
        Add-WindowsCapability -Online -Name $ssh_client_pagkage.Name
    }
}

function Install-SSHServer(){

    $ssh_server_pagkage = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

    if($ssh_server_pagkage.State -eq 'Installed'){
        Write-Information "$ssh_server_package.Name is already installed..."
    }

    else{
        Write-Information "Installing... $ssh_server_package.Name"
        Add-WindowsCapability -Online -Name $ssh_server_pagkage.Name
    }
}

function updateSSHDConfig{

    #It's job is to comment lines dhowed below from sshd_config to enable looking at
    # users home directory ( i.e. $env:USERPROFILE/.ssh/ ) for authorized_keys
    # sshd_config snippet
    #-----------------
    # Match Group administrators
    # AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

    $SSH_DIR = Join-Path $env:ProgramData 'ssh'
    $SSHD_CONFIG = Join-Path $SSH_DIR 'sshd_config'

    $pattern = 'administrators'

    $new_content = New-Object System.Collections.ArrayList

    [string[]]$content = Get-Content -Path $SSHD_CONFIG

    foreach($line in $content){
        if($line -match [regex]::new($pattern)){
            #if line is already commented skip it
            if (-not ($line -match '#')){
                $line =  '#' + $line
            }
        }

        $new_content.Add($line) | Out-Null
    }

    #Allow Agent Forwarding so ssh agent can forwd the keys
    if($new_content -match '#AllowAgentForwarding yes'){

        $new_content = $new_content.replace('#AllowAgentForwarding yes','AllowAgentForwarding yes')
    }

    #Enable public key auth
    if($new_content -match '#PubkeyAuthentication yes'){
        $new_content = $new_content.replace('#PubkeyAuthentication yes','PubkeyAuthentication yes')
    }

    [System.IO.File]::WriteAllLines($SSHD_CONFIG,$new_content)
}


function Start-SSHServer(){
    #Start sshd

    $ssh_service_status = {Get-Service sshd}.Status

    if( $ssh_service_status -eq 'Running' ){
        Write-Information "Servive shhd is already ... $ssh_service_status"
    }
    else {
        Write-Information "Starting sshd..."
        Start-Service sshd
    }

    #Set it to start automatically
    if($ssh_service_status.StartType -eq 'Automatic'){
        Write-Information "sshd is set to start automatically"
    }
    else {
        Write-Information "Enabling sshd to start Automatically..."
        Set-Service -Name sshd -StartupType 'Automatic'
    }
}


function Start-SSHAgent(){
    #Start sshd-agent

    $ssh_agent_service_status = {Get-Service ssh-agent}.Status

    if( $ssh_agent_service_status -eq 'Running' ){
        Write-Information "Servive ssh-agent is already ... $ssh_agent_service_status"
    }
    else {
        Write-Information "Starting ssh-agent..."
        Start-Service ssh-agent
    }

    #Set it to start automatically
    if($ssh_agent_service_status.StartType -eq 'Automatic'){
        Write-Information "ssh-agent is set to start automatically"
    }
    else {
        Write-Information "Enabling ssh-agent to start Automatically..."
        Set-Service -Name ssh-agent -StartupType 'Automatic'
    }
}


function Enable-SSHFirewall(){

    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)){
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } 
    else {
        Write-Information "Firewall rule 'OpenSSH-Server-In-TCP' exists."
    }
}


function Setup-SSH(){
    Install-SSHClient
    Install-SSHServer
    updateSSHDConfig
    Start-SSHServer
    Start-SSHAgent
    Enable-SSHFirewall
}


Setup-SSH