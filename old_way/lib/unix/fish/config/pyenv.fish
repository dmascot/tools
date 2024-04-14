# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function activate-pyenv --description "load pyenv and virtualenv if found"

    if ! command -q pyenv
        set -gx PYENV_ROOT $HOME/.pyenv
        fish_add_path -maP $PYENV_ROOT/shims
        fish_add_path -maP $PYENV_ROOT/bin
        set -gx PYENV_VIRTUALENV_DISABLE_PROMPT 1
        pyenv init - | source
    end

    if command -q python
        alias py='python'
    end

end

activate-pyenv