# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

logger(){
    # Print messages to stdout ( and log to file eventually)
    # Params: None
    # -------
    #
    # Return: None
    # -------
    local message=$1
    printf "%b" "$message"
}

is_supported_shell(){
    # Checks if uses current shell is supported to install tools
    # Params: CURRENT_SHELL aka $SHELL
    # -------
    #
    # Return: Boolean $TRUE or $FALSE
    # -------
    local current_shell=$1
    STATUS=$FALSE

    for shell_name in ${SUPPORTED_SHELLS[@]}
    do
        if [[ $current_shell =~ $shell_name ]]
        then
            STATUS=$TRUE
            break
        fi
    done
    return $STATUS
}

is_supported_system(){
    # Checks if uses current system is supported to install tools
    # Params: UNIX system name ( UNIX_SYSTEM ) obtained with uname -s
    # -------
    #
    # Return: Boolean $TRUE or $FALSE
    # ------
    local current_system=$1
    STATUS=$FALSE

    for system in ${SUPPORTED_UNIX_SYSTEM[@]}
    do
        if [[ $system =~ $current_system ]]
        then
            STATUS=$TRUE
            break
        fi
    done
    return $STATUS  
}

is_supported_os(){
    # Checks if uses current os/os flavour is supported to install tools
    # Params: OS Name obtained with get_os_name
    # -------
    #
    # Return: Boolean $TRUE or $FALSE
    # ------
    local current_os=$1
    STATUS=$FALSE

    for os in ${SUPPORTED_OS[@]}
    do
        if [[ $os =~ $current_os ]]
        then
            STATUS=$TRUE
            break
        fi
    done
    return $STATUS  
}

is_valid_unix_path(){
    # Checks if path is valid unix path with regex match
    # Params: 
    # - path_to_check as first argument
    # -------
    #
    # Return: Boolean $TRUE or $FALSE
    # ------
    local path_to_check="$1"
    local path_regex='(\/{0,}[A-Za-z0-9]+\/{1,})+'

    [[ $path_to_check =~ $path_regex ]] && return $TRUE

    return $FALSE
}

is_supported_platform(){
    # Checks if uses current platform is supported to install tools
    # Params: platform name obtained with get_platform_name
    # -------
    #
    # Return: Boolean $TRUE or $FALSE
    # ------
    local current_platform=$1
    STATUS=$FALSE

    for platform in ${SUPPORTED_PLATFORMS[@]}
    do
        if [[ $platform == $current_platform ]]
        then
            STATUS=$TRUE
            break
        fi
    done
    return $STATUS  
}

get_os_name(){
    # Try to determine the OS/Flavour name
    # Params:
    # ---------
    # - It takes current system ( $UNIX_SYSTEM ) as a paramater
    # Returns:
    # ---------
    # It returns (using echo) name of the OS 
    #
    # Note:
    # -----
    # This function should be called after ensuring below listed functions are $TRUE
    #  - is_supported_shell
    #  - is_supported_system

    local current_system=$1
    local os_name="None"
    
    if [[ "$current_system" == "Darwin" ]]
    then
        os_name="OSX"
    elif [[  "$current_system" == "Linux" ]]
    then
        os_name=$(cat /etc/os-release | grep '^NAME=' | awk -F'"' '{print $2}')
    fi

    printf "%s" "$os_name"
}

get_platform_name(){
    # Try to guess the platform on which OS is running
    # what we really care about is if,Ubuntu is running as DOCKER Container , WSL,Docker in WSL or is Generic ( i.e. anything else )
    # - How we determine WSL/Non WSL is by looking at kernel version ( with uname -v) if it has WSL in name it is WSL!
    # - How we determine Docker/Non Docker is by looking at init proc, if it is init(or systemd) it is non Docker 
    #   if Current shell is same as the init proc and/or if cgroups have docker(or lxc) it is Docker
    # Params: 
    # --------
    # - $UNIX_SYSTEM as a first paramater
    #
    #  We would think to use OS here to determine platform, however 
    #  We only need to know Unix system being used before we guesstimate platfrom
    # Returns:
    # ---------
    # It returns Platfrom , default is generic
    #
    # Note:
    # -----
    # This function should be called after ensuring below listed functions are $TRUE
    # - is_supported_system 
    # - is_supported_os
    
    local current_system=$1
    local kernal_name="$(uname -a)"
    local platform_name="None"
    local dockerenv_status

    if [[ "$current_system" == "Darwin" ]]
    then
        platform_name="Mac"

    elif [[ "$current_system" == "Linux" ]]
    then
        is_existing_file "/.dockerenv" && dockerenv_status=$?

        if [[ "$kernal_name" =~ "WSL" ]]
        then 
            platform_name='WSL'

            if [[  $dockerenv_status == $TRUE ]]
            then
                platform_name="WSL_Docker"
            fi
        else
        
            if [[ $dockerenv_status == $TRUE  ]]
            then
                platform_name='Docker'
            else 
                platform_name="Generic"
            fi 
        fi
    fi

    printf "%s" "$platform_name"
}

is_command_available(){
    #Check if command is available
    # Params:
    # -------
    # - command to be tested goes as the first parameter
    #
    # Returns: Boolean $TRUE or $FALSE
    # --------
    local command_to_test="$1"

    if $(command -v $command_to_test &> /dev/null)
    then
        return $TRUE
    fi

    return $FALSE
}

is_running_as_root(){
    #Simply checks if command/script is running as root or not
    #
    # Params: None
    # -------
    #
    # Returns: Boolean $TRUE or $FALSE
    # --
    [[ $(id -u) -eq 0 ]] && return $TRUE || return $FALSE
}

is_not_running_as_root(){
    #Simply checks if command/script is not running as root
    #
    # Params: None
    # -------
    #
    # Returns: Boolean $TRUE or $FALSE
    # --
    [[ $(id -u) -ne 0 ]] && return $TRUE || return $FALSE
}

is_existing_directory(){
    # This method simply checks if directory exists or not
    #
    # Params:
    # -------
    # check_directory , path to directory in question
    #
    # Returns:
    # --------
    # Boolean $TRUE or $FASLE 

    local check_directory="$1"

    [[ -d "$check_directory" ]] && return $TRUE || return $FALSE
}

is_existing_file(){
    # This method simply checks if directory exists or not
    #
    # Params:
    # -------
    # check_file , path to file in question
    #
    # Returns:
    # --------
    # Boolean $TRUE or $FASLE 

    local check_file="$1"

    [[ -f "$check_file" ]] && return $TRUE || return $FALSE
}

is_empty_directory(){
    # This method simply checks if directory is empty or not
    #
    # Params:
    # -------
    # check_directory , path to directory in question
    #
    # Returns:
    # --------
    # Boolean $TRUE or $FASLE  

    local check_directory="$1"
    [[ $(find $check_directory  -maxdepth 0 -empty) ]] && return $TRUE || return $FALSE
}

create_directory(){
    # This method simply created the directory if does not exist
    #
    # Params:
    # -------
    # destination_dir , path to create directory
    #
    # Returns:
    # --------
    # Boolean $TRUE or $FASLE 

    local destination_dir="$1"

    mkdir -p "$destination_dir" &> /dev/null

    [[ $? -eq $TRUE ]] && return $TRUE || return $FALSE
}

git_clone(){
    # This method clones repository to destination
    # However we will not be updating existing repository with git pull
    #
    # Params:
    # -------
    # - destination_dir, destination where repository need to be cloned
    # - repository_url , http/ssh url for repository
    #
    # Returns:
    # --------
    #  - Boolean $TRUE or $FALSE
    #
    # Note: It assumes destination directory exists, if not it fails
    # Use create_directory() before you call this function

    local destination_dir="$1"
    local repository_url="$2"

    git -C "$destination_dir" clone "$repository_url" . &> /dev/null
    
    [[ $? -eq $TRUE ]] && return $TRUE || return $FALSE
    
}

is_mac(){
    # This is a helper fucntion for tests skip/run certain tests on Mac
    #
    # Params: None
    # ---------   
    #
    # Depends On: 
    # -----------
    # - variables.sh
    #
    # Retruns: Boolean $TRUE or $FALSE
    # -------- 
    
    [[ "$UNIX_SYSTEM" == Darwin ]] && return $TRUE || return $FALSE
}

is_not_mac(){
    # This is a helper fucntion for tests skip/run certain tests on Mac
    #
    # Params: None
    # ---------   
    #
    # Depends On: 
    # -----------
    # - variables.sh
    #
    # Retruns: Boolean $TRUE or $FALSE
    # -------- 
    [[ "$UNIX_SYSTEM" != Darwin ]] && return $TRUE || return $FALSE
}

is_linux(){
    # This is a helper fucntion for tests skip/run certain tests on Linux
    #
    # Params: None
    # ---------   
    #
    # Depends On: 
    # -----------
    # - variables.sh
    #
    # Retruns: Boolean $TRUE or $FALSE
    # -------- 
    
    [[ "$UNIX_SYSTEM" == Linux ]] && return $TRUE || return $FALSE
}

is_not_linux(){
    # This is a helper fucntion for tests skip/run certain tests on Linux
    #
    # Params: None
    # ---------   
    #
    # Depends On: 
    # -----------
    # - variables.sh
    #
    # Retruns: Boolean $TRUE or $FALSE
    # -------- 
    
    [[ "$UNIX_SYSTEM" != Linux ]] && return $TRUE || return $FALSE
}

config_is_in_file(){
    #This is a basic function to check if given config exists in a file.
    #it does so checking line by line and, returns $FALSE on first mis-match
    #
    # Depends on
    # -----------
    # - variables.sh
    #
    # Params:
    # -------
    # - config_file, path of config file to be checked
    # - config_to_check, actual config to check
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen
    
    local IFS='\'
    local config_file="$1"
    local config_to_check="$2"
    typeset -a config_array

    [[ -z "${config_file}" ]] || [[ -z "${config_to_check}" ]] && return $VARIABLE_NOT_DEFINED

    if [[ $CURRENT_SHELL =~ bash ]]
    then 
        readarray -td"$IFS" config_array <<< "${config_to_check}"
    fi


    if [[ $CURRENT_SHELL =~ zsh ]]
    then
        setopt sh_word_split
        local lines=("${(f)$(echo "$config_to_check")}")
     
        for line in ${=lines}
        do
            config_array+=($line)
        done
        unset sh_word_split
    fi 

    local is_in_file=$TRUE
    for i in ${config_array[@]}
    do 
        #Remove any new line/carriage return from the variable if present
        local term=`tr -d '\n' <<< "$i" | tr -d '\r'`
        command_status=$(grep -qF ${term} ${config_file}; printf $?)
        if [[ $command_status != $TRUE ]]
        then 
            is_in_file=$FALSE
            break
        fi 

    done 
    
    unset IFS

    return $is_in_file
}

is_existing_path(){
    #This function checks if path exists. 
    # be aware, It only check for the path it does not care if file exists
    # i.e. if /this/path/exist it would retuen TRUE for /this/path/exist/file.does.not.exist
    # Depends on
    # -----------
    # - variables.sh
    #
    # Params:
    # -------
    # - path_to_check, path with (or without file name)
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    path_to_check="$1"
    [[ -d $(dirname $path_to_check) ]] && return $TRUE || return $FALSE
}

is_current_hostname(){
    # This function checks if supplied name is same as current hostname 
    # 
    # Depends on
    # -----------
    # - None
    #
    # Params:
    # -------
    # - name, name of the host
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE

    local name="$1"

    [[ $name == $(hostname) ]] && return $TRUE || return $FALSE
}

generate_conf_from_template(){
    #This function is used to generate configuration file from template
    # Depends on : gettext must be installed
    # ----------
    # Mac: brew install gettext
    # Ubuntu apt-get install -y gettext
    # Params:
    # -------
    # - local template_source, actual template file
    # - local template_destination, location where template needs to be copied
    #
    #
    template_source=$1
    template_destination=$2

    if [ -f $template_destination ]; then mv $template_destination $template_destination.bak ; fi 

    envsubst < $template_source > $template_destination

}