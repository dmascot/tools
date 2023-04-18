get_nvm(){
    #This function clone nvm repo to destination directory
    # Depends on
    # -----------
    # - variables.sh
    # - helper.sh ( indirect dependency via get_tool )
    # Params:
    # -------
    # - destination_dir, destination directory where tool be cloned
    # - repository_url, source url
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen
    #
    # Note: It used global set variable NVM_GIT_URL (set in variables.sh with default value)

    local destination_dir="$1"
    local repository_url="$2"
  
    get_tool "NVM" "$destination_dir" "$repository_url" && return $? 
}

configure_nvm(){
    #This function adds nvm config to appropriate file
    # Depends on
    # -----------
    # - variables.sh
    # - functions.sh
    # - helper.sh ( indirect dependencies )
    # 
    # Params:
    # -------
    # - nvm_dir, nvm installation dir
    # - nvm_config, destination config file
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen

    local nvm_dir="$1"
    local nvm_config_file="$2"
    local nvm_config='#Load NVM\
NVM_DIR="'$nvm_dir'"\
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"\
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"'

    write_config_to_file "$nvm_config_file" "$nvm_config" && return $?
}
