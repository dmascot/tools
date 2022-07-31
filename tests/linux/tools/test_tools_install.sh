#!/usr/bin/env bash

source scripts/linux/tools.sh

test_install_or_update_nvm(){
    NVM_DIR="${HOME}/.nvm"
    install_or_update_nvm
    assertTrue "Expected: ${NVM_DIR} to exist" "[ -d ${NVM_DIR} ]"
}

test_install_or_update_pyenv(){
    PYENV_DIR="${HOME}/.pyenv"
    install_or_update_pyenv
    assertTrue "Expected: ${PYENV_DIR} to exist" "[ -d ${PYENV_DIR} ]"
}

test_install_or_update_bashGitPrompt(){
    BASH_GIT_PROMPT="${HOME}/.bash-git-prompt"
    install_or_update_bashGitPrompt
    assertTrue "Expected: ${BASH_GIT_PROMPT} to exist" "[ -d ${BASH_GIT_PROMPT} ]"
}

. shunit2