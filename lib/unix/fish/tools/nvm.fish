# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function install_nvm
    
    set -l nvm_url "https://github.com/nvm-sh/nvm.git"
    set -l clone_dest "$HOME/.nvm"

    set -l nvm_config_src "$SOURCE_CONFIG_DIR/nvm.fish"
    set -l nvm_config_dest "$DEST_CONFIG_DIR"

   
    if ! test -d $clone_dest
        git_clone $nvm_url $clone_dest
        copy_config $nvm_config_src $nvm_config_dest
    end

end