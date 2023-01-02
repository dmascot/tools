get_git_prompt(){
    #This function clone git prompt repo to destination directory
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

    local destination_dir="$1"
    local repository_url="$2"
  
    get_tool "GIT Prompt" "$destination_dir" "$repository_url" && return $? 
}

configure_git_prompt(){
    #This function adds git prompt config to appropriate file
    # Depends on
    # -----------
    # - variables.sh
    # - functions.sh
    # - helper.sh ( indirect dependencies )
    # 
    # Params:
    # -------
    # - git_prompt_dir, git_prompt installation dir
    # - git_prompt_config, destination config file
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen
  
    local git_prompt_dir="$1"
    local git_prompt_config_file="$2"

    if [[ $CURRENT_SHELL =~ bash ]]
    then
        local git_prompt_config='#Load GIT_PROMPT\
GIT_PROMPT_DIR="'$git_prompt_dir'"\
[[ -f "$GIT_PROMPT_DIR/gitprompt.sh" ]] && GIT_PROMPT_ONLY_IN_REPO=1 && . $GIT_PROMPT_DIR/gitprompt.sh'
    fi

    if [[ $CURRENT_SHELL =~ zsh ]]
    then
        local git_prompt_config='#Load GIT_PROMPT\
GIT_PROMPT_DIR="'$git_prompt_dir'"\
. $GIT_PROMPT_DIR/zshrc.sh'
    fi

    write_config_to_file "$git_prompt_config_file" "$git_prompt_config" && return $?
} 