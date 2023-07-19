# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

source "$PWD/lib/unix/fish.fish"

function is_prerequisites_satisfied --description "Check Prerequisites"

    if command -q git
        echo "git found....OK"
    else 
        echo "Install git command!"
        false
    end 

    if test -f  "$HOME/.config/fish/functions/bass.fish"
        echo "bass found....OK"
    else
        echo "Install bass from https://github.com/edc/bass"
        false
    end

end

function setup --description "run setup"

    if make_dir $DEST_CONFIG_DIR

        echo "Configuring git prompt"
        config_gitprompt

        echo "Installing and configuring pyenv"
        install_pyenv

        echo "Installing and configuring nvm"
        install_nvm

        echo "source $DEST_CONFIG_DIR/git_prompt.fish" > $FISHRC
        echo "source $DEST_CONFIG_DIR/pyenv.fish" >> $FISHRC
        echo "source $DEST_CONFIG_DIR/nvm.fish" >> $FISHRC
        echo "source $FISHRC" >> $HOME/.config/fish/config.fish
        
        true 
    else 
        false
    end

end

if is_prerequisites_satisfied
    setup
end 