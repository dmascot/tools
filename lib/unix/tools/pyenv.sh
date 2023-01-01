get_pyenv(){
    #This function clone pyenv repo to destination directory
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
  
    get_tool "pyenv" "$destination_dir" "$repository_url" && return $? 
}

configure_pyenv(){
    #This function adds pyenv config to appropriate file
    # Depends on
    # -----------
    # - variables.sh
    # - functions.sh
    # - helper.sh ( indirect dependencies )
    # 
    # Params:
    # -------
    # - pyenv_dir, pyenv installation dir
    # - pyenv_config, destination config file
    #
    # Returns:
    # --------
    # - Boolean values $TRUE or $FALSE
    # - it also prints appropriate message on screen
  
    local pyenv_dir="$1"
    local pyenv_config_file="$2"
    local pyenv_config='#Load PYENV\
PYENV_DIR="'$pyenv_dir'"\
command -v pyenv >/dev/null || PATH="$PYENV_DIR/bin:$PATH"\
eval "$(pyenv init -)"'

    write_config_to_file "$pyenv_config_file" "$pyenv_config" && return $?
} 