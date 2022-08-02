#!/usr/bin/env bash

#This Script simply installs tools listed below , it assumes you have your platform set the way you desire already

export SETUP_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export SCRIPT_PATH="${SETUP_ROOT}/scripts/linux"

source $SCRIPT_PATH/tools.sh

install_tools(){
    echo "Installing gitbash prompt..."
    install_or_update_bashGitPrompt
    configure_bashGitPrompt

    echo "Installing nvm..."
    install_or_update_nvm

    echo "installing pyenv..."
    install_or_update_pyenv
    configure_pyenv
}

install_tools

#Unset variables once all done
unset SETUP_ROOT
unset SCRIPT_PATH