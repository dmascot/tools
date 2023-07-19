# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

get_tool(){
    #This is a Generic installer function,it integrates functions ensure appropriate results
    #it clones git repository to given destination or prints appropriate error
    #
    # Depends on
    # -----------
    # - functions.sh
    #
    # Params:
    # -------
    # - tool_name, name of the tool being cloned
    # - destination_dir, destination directory where tool be cloned
    # - repository_url, url to be cloned/copied
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen
    #
    # Note:
    # -----
    # You should not use this function directly , it is kinda proxy function to clone tool from git

    local tool_name="$1"
    local destination_dir="$2"
    local repository_url="$3"

    logger "Cloning $tool_name...."

    #if path is not valid log error and return $FALSE
    if ! is_valid_unix_path "$destination_dir"
    then 
        logger "failed! $destination_dir path is invalid"
        return $FALSE
        #if directory is not existing create it
    elif ! is_existing_directory "$destination_dir"
    then
        #if creating directory fails  log error and return $FALSE
        if ! create_directory "$destination_dir"
        then
            logger "failed! can not create $destination_dir\n"
            return $FALSE
        fi 
    #if directory exist but is not empty, log an error and return $FALSE
    elif ! is_empty_directory "$destination_dir"
    then
        logger "failed! $destination_dir is not empty"
        return $FALSE 
    fi

    #if all that is fine,  try to clone repository in destination
    if git_clone "$destination_dir" "$repository_url" -eq $TRUE 
    then
        logger "done!\n"
        return $TRUE
    else
        logger "failed! check if $repository_url is valid?\n"
        return $FALSE 
    fi
}

write_config_to_file(){
    #This functions writes config to given file
    #
    # Depends on
    # -----------
    # - variables.sh to return status
    # - functions.sh for logger
    #
    # Params:
    # -------
    # - config_file, path of config file 
    # - config_string, config to be written
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen

    local config_file="$1"
    local config_string="$2"
    local IFS='\'

    logger "Configuring $config_file...."

    [[ -z "${config_file}" ]] || [[ -z "${config_string}" ]] && logger "failed! both \$config_file and \$config_string must be defined\n" && return $FALSE

    ! is_existing_path "$config_file" && logger "failed! path $(dirname $config_file) does not exist\n" && return $FALSE

    #if config file exists check if condif exists in a file
    if is_existing_file "$config_file"
    then 
        local config_status
        config_is_in_file "$config_file" "$config_string" && config_status=$TRUE || config_status=$FALSE
    else
        #we will create config gile it does not exist
        local config_status=$FALSE
    fi 

    [[ $config_status -eq $TRUE ]] && logger "done!\n" && return $TRUE

    #if we are here...we are ready to add config to file
    logger "adding config..."
    [[ $CURRENT_SHELL =~ bash ]] && config_string="$(echo $config_string | sed 's:\\:\n:g' | sed 's/ +/ /g')"
    [[ $CURRENT_SHELL =~ zsh ]] && config_string="$(echo $config_string | sed 's:\\::g' | sed 's/ +/ /g')"
        
    printf "\n$config_string" >> $config_file
    write_status=$?

    if [[ $write_status -eq $FALSE ]]
    then
        logger "failed! can not write to file\n"
        return $FALSE
    fi
         
    logger "done!\n"
    return $TRUE
}


#note
# for zsh config can be in $HOME/.zshrc and will be read by both interactive as well as non interactive shels
# for bash, we need to add config in both .bashrc and .profile so interactaive-login and interactive nonlogin shell can set 
load_tool_in_shell(){
    #This function adds config file to shell profile for both interactive-login and, non-interactive login
    #
    # it sources tools config file in .bashrc or .zshrc depending upon the shell
    # if shell is bash, it also checks if it sources .bashrc if not, it adds config
    #
    # Depends on
    # -----------
    # - variables.sh to return status
    # - functions.sh for logger
    #
    # Params:
    # -------
    # - tool_config, file that we want to add to .bashrc or .zshrc
    #
    # Returns: None
    # --------

    local tool_config="$1"
    local tool_config_loader="[[ -f $tool_config ]] && . $tool_config"
    local bash_profile="$HOME/.profile"

    # select shell resource file
    [[ $CURRENT_SHELL =~ bash ]] && local rcfile="$HOME/.bashrc" || local rcfile="$HOME/.zshrc"

    #add loader to resoure file
    write_config_to_file "$rcfile" "$tool_config_loader" 

    #if bash we need to check if we have to add it in profile file or not
    if [[ $CURRENT_SHELL =~ bash ]]
    then
        #if profile is not sourcing bashrc add resource loaded to it
        if ! config_is_in_file "$bash_profile" ".bashrc"
        then
            write_config_to_file "$bash_profile" "$tool_config_loader"
            [[ $? -eq $TURE ]] && return $TRUE || return $FASLE
        fi 
    fi

}