is_prerequisites_satisfied(){
    # This function checks suitablity of system by running various checks common across all platfrom and OS
    # it ensures all prerequisite are met
    #
    # Params: None
    # -------
    # 
    # Depends on
    # -----------
    # - unix.sh

    local prerequisite_satisfied=$TRUE

    local platform_name="$(get_platform_name $UNIX_SYSTEM)"
    local os_name=$(get_os_name "$UNIX_SYSTEM")

    logger "Checking prerequisites....\n"

    # is supported system ?
    ! is_supported_system "$UNIX_SYSTEM" && logger "Found....unsupported $UNIX_SYSTEM system\n" && prerequisite_satisfied=$FALSE || logger "Found....$UNIX_SYSTEM system\n"

    # is supported platform?
    ! is_supported_platform "$platform_name" && logger "Found....unsupported $platform_name platform\n" && prerequisite_satisfied=$FALSE || logger "Found....$platform_name platform\n"

    # is supported OS?
    ! is_supported_os "$os_name" && logger "Found....unsupported $os_name os\n" && prerequisite_satisfied=$FALSE || logger "Found....$os_name os\n"

    # is supported shell?
    ! is_supported_shell "$CURRENT_SHELL" && logger "Found....unsupported $CURRENT_SHELL shell\n" && prerequisite_satisfied=$FALSE || logger "Found....$CURRENT_SHELL shell\n"

    # Do we have required commands installed?
    for command in ${PREREQUISITE_COMMANDS[@]}
    do
       ! is_command_available "$command" && logger "Failed to locate....$command" && prerequisite_satisfied=$FALSE || logger "Found....$command command\n"
    done

    # if TOOLS_HOME does not exists set should_exit to TRUE
    ! is_existing_directory $TOOLS_HOME && logger "$TOOLS_HOME does not exist\n" && prerequisite_satisfied=$FALSE || logger "Found....$TOOLS_HOME\n"

    # After all checks, if prerequisite_satisfied is $FALSE than exit!
    [[ $prerequisite_satisfied -eq $FALSE ]] && return $FALSE || return $TRUE
}

install_tools(){
    #Install all tools to Install Root
    #
    # Params: None
    # -------
    # 
    # Depends on
    # -----------
    # - unix.sh
    #
    # DEPENDS ON USER CONFIGUREABLE VARIABLES
    # ----------------------------------------
    # - GIT_PROMPT_URL  git_prompt repository url
    # - GIT_PROMPT_DIR  install dir for git_prompt
    # - GIT_PROMPTRC    config file for git_prompt
    # - NVM_GIT_URL     nvm git repository url
    # - NVM_DIR         install dir for NVM
    # - NVMRC           config file for NVM
    # - PYENV_GIT_URL   pyenv git repository url
    # - PYENV_DIR       install dir for PYENV   
    # - PYENVRC         config file for PYENV

  
    SUCCESS=$TRUE

    get_git_prompt $GIT_PROMPT_DIR $GIT_BASH_PROMPT_URL && configure_git_prompt $GIT_PROMPT_DIR $GIT_PROMPTRC && load_tool_in_shell "$GIT_PROMPTRC" || SUCCESS=$FALSE

    get_nvm $NVM_DIR $NVM_GIT_URL && configure_nvm $NVM_DIR $NVMRC && load_tool_in_shell "$NVMRC" || SUCCESS=$FALSE

    get_pyenv $PYENV_DIR $PYENV_GIT_URL && configure_pyenv $PYENV_DIR $PYENVRC && load_tool_in_shell "$PYENVRC" || SUCCESS=$FALSE

    [[ $SUCCESS -eq $FALSE ]] && return $FALSE || return $TRUE
  
}