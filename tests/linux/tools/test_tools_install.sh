#!/usr/bin/env bash

source scripts/linux/tools.sh

test_install_or_update_nvm(){
    NVM_DIR="${HOME}/.nvm"
    install_or_update_nvm
    assertTrue "Expected: ${NVM_DIR} to exist" "[ -d ${NVM_DIR} ]"
}

test_install_or_update_pyenv(){
    ## circleci already comes with pyenv installed so if root is set we can just install and give it a go ..
    [[ -z $PYENV_ROOT ]] && PYENV_ROOT="${HOME}/.pyenv"

    install_or_update_pyenv
    assertTrue "Expected: ${PYENV_ROOT} to exist" "[ -d ${PYENV_ROOT} ]"
}

test_install_or_update_bashGitPrompt(){
    BASH_GIT_PROMPT="${HOME}/.bash-git-prompt"
    install_or_update_bashGitPrompt
    assertTrue "Expected: ${BASH_GIT_PROMPT} to exist" "[ -d ${BASH_GIT_PROMPT} ]"
}

. shunit2