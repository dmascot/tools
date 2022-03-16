#!/usr/bin/env bash

DEFAULT_BASHRC_FILE="${HOME}/.bashrc"
DEFAULT_PROFILE_FILE="${HOME}/.profile"

NVM_BASHRC_CONFIG='#Load NVM\
export NVM_DIR="$HOME/.nvm"\
[ -s "$NVM_DIR/nvm.sh" ]  && . "$NVM_DIR/nvm.sh"\
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"'

PYENV_PROFILE_CONFIG_PART1='export PYENV_ROOT="$HOME/.pyenv"\
export PATH="$PYENV_ROOT/bin:$PATH"'

PYENV_PROFILE_CONFIG_PART2='eval $(pyenv init --path)'

PYENV_BASHRC_CONFIG='eval "$(pyenv init -)'

GITBASHPROMPT_BASHRC_CONFIG='if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]\
then\
    GIT_PROMPT_ONLY_IN_REPO=1\
    source $HOME/.bash-git-prompt/gitprompt.sh\
fi'

# Generic function to install tool from git
# Param
# 1st ARG is install dir, where git will be copied
# 2nd ARG is the command which will clone repository to destination
# feature: if it is called again, it will try to update the tool with git pull
__git_installer(){
    INSTALL_DIR=$1
    INSTALL_COMMAND=$2
    
    if [ ! -d "${INSTALL_DIR}" ]
    then
         eval ${INSTALL_COMMAND}
    else 
        git --git-dir="${INSTALL_DIR}/.git" fetch > /dev/null 2>&1
        git --git-dir="${INSTALL_DIR}/.git" --work-tree "${INSTALL_DIR}" merge origin master > /dev/null 2>&1        
    fi 
}

#Generic function to check if configuration is in file
#Param:
# 1st ARG config file, that needs to be checked 
# 2nd ARG config that needs to be tested, it cant accept multiline config too
#feature: 
# returns 12 if config file is not supplied
# return 13 if config file is supplied but, config to be checked is missing
# return 1 if grep exit with status 1 at any point, it instantly exits the loop and returns error status 1
# return 0 this is default assuming there is no error when we run check and returns 1 as the end result if no errors are encounterd
#  it break multiline config into an array, and grep the config in loop , if ever exit status is 1 , break and return error
__is_config_in_file(){

    CONFIG_FILE="${1}"
    CONFIG_TO_CHECK="${2}"
    status=0

    #if you missed to supply the config, it will retrn 12, meaning missing config file
    [[ -z "${CONFIG_FILE}" ]] && status=12;

    #return 13 if you do not supply config to be checked
    [[ ! -z "${CONFIG_FILE}" ]] && [[ -z "${CONFIG_TO_CHECK}" ]] && status=13;

    #Go ahed and run the check if both config file and config are present
    if [ ! -z "${CONFIG_FILE}" ] && [ ! -z "${CONFIG_TO_CHECK}" ]
    then 
        readarray -td'\' CONFIG_ARRAY <<< "${CONFIG_TO_CHECK}"

      
        for i in ${!CONFIG_ARRAY[@]}
        do 
            #Remove any new line/carriage return from the variable if present
            term="`sed 's/[\n\r]//g' <<< "${CONFIG_ARRAY[$i]}"`"
            
            grep -qF "${term}" ${CONFIG_FILE}
            status=$?

            if [ $status != 0 ] 
            then
                return $status
            fi  

        done 
    fi 

    return $status
}


install_or_update_nvm(){

    NVM_DIR="${HOME}/.nvm"

    __git_installer "${NVM_DIR}" 'wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash > /dev/null 2>&1'

}

install_or_update_pyenv(){
    PYENV_DIR="${HOME}/.pyenv"
    __git_installer "${PYENV_DIR}" 'wget -qO- https://pyenv.run | bash > /dev/null 2>&1'
}

install_or_update_bashGitPrompt() {
    BASH_GIT_PROMPT="${HOME}/.bash-git-prompt"
    __git_installer "${BASH_GIT_PROMPT}"  "git clone https://github.com/magicmonty/bash-git-prompt.git ${BASH_GIT_PROMPT} --depth=1 > /dev/null 2>&1"
}


is_nvm_config_in_file(){
    #This ensures variale /strings with spaces are passed properly, since default IFS is space!    
    local IFS='^'
    BASHRC_FILE="${1}"
    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"

    __is_config_in_file $BASHRC_FILE $NVM_BASHRC_CONFIG
    return $?
}

configure_nvm(){
    BASHRC_FILE="${1}"
    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"

    if ! is_nvm_config_in_file $BASHRC_FILE 
    then 
        [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"

        sed -E -i.bak -e "$ a $NVM_BASHRC_CONFIG"  $BASHRC_FILE
    fi
}


is_pyenv_config_in_file(){
    #This ensures variale /strings with spaces are passed properly, since default IFS is space!    
    local IFS='^'
    BASHRC_FILE="${1}"
    PROFILE_FILE="${2}"

    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"
    [[ -z "${PROFILE_FILE}" ]] && PROFILE_FILE="${DEFAULT_PROFILE_FILE}"

    __is_config_in_file $BASHRC_FILE  $PYENV_BASHRC_CONFIG
    status=$?
    [[ $status != 0 ]] && return $status
    
    __is_config_in_file $PROFILE_FILE  $PYENV_PROFILE_CONFIG_PART1
    status=$?
    [[ $status != 0 ]] && return $status

    __is_config_in_file $PROFILE_FILE  $PYENV_PROFILE_CONFIG_PART2
    return $?

}

configure_pyenv(){
    BASHRC_FILE="${1}"
    PROFILE_FILE="${2}"

    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"
    [[ -z "${PROFILE_FILE}" ]] && PROFILE_FILE="${DEFAULT_PROFILE_FILE}"

    if ! is_pyenv_config_in_file $BASHRC_FILE $PROFILE_FILE
    then
        #Add right after the end of first comment 
        sed -E -i.bak -e "/^([^#]|$)/{a $PYENV_PROFILE_CONFIG_PART1"  -e ':a' -e "$!{n;ba};}" $PROFILE_FILE

        #Add to the end of file
        sed -E -i.bak -e "$ a $PYENV_PROFILE_CONFIG_PART2"  $PROFILE_FILE 

        #Add to the end of file
        sed -E -i.bak -e "$ a $PYENV_BASHRC_CONFIG"  $BASHRC_FILE

    fi
}

is_bashGitPrompt_config_in_file(){
    #This ensures variale /strings with spaces are passed properly, since default IFS is space!
    local IFS='^'
    BASHRC_FILE="${1}"
    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"

    __is_config_in_file $BASHRC_FILE $GITBASHPROMPT_BASHRC_CONFIG
    return $?
}

configure_bashGitPrompt(){
    BASHRC_FILE="${1}"
    [[ -z "${BASHRC_FILE}" ]] && BASHRC_FILE="${DEFAULT_BASHRC_FILE}"

    if ! is_bashGitPrompt_config_in_file $BASHRC_FILE 
    then 
        sed -E -i.bak -e "$ a $GITBASHPROMPT_BASHRC_CONFIG"  $BASHRC_FILE
    fi
}