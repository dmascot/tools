# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function install_pyenv
    
    set -l pyenv_url "https://github.com/pyenv/pyenv"
    set -l clone_dest "$HOME/.pyenv"

    set -l pyenv_config_src "$SOURCE_CONFIG_DIR/pyenv.fish"
    set -l pyenv_config_dest "$DEST_CONFIG_DIR"

   
    if ! test -d $clone_dest
        git_clone $pyenv_url $clone_dest
        copy_config $pyenv_config_src $pyenv_config_dest
    end

end