# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

ORI_HOME=$HOME
export TOOLS_HOME="$test_home/integration"
export HOME=$TOOLS_HOME

mk_test_dir $TOOLS_HOME
copy_profiles $TOOLS_HOME

source "$PWD/setup.sh" 1>/dev/null 2>&1

Describe "Setup" Test:SetUpIntegration

    It "should have following file and directory"

        Assert is_existing_file "$TOOLS_HOME/.nvmrc"
        Assert is_existing_file "$TOOLS_HOME/.pyenvrc"
        Assert is_existing_file "$TOOLS_HOME/.git_promptrc"
        
        [[ $CURRENT_SHELL =~ bash ]] && local rcfile="$HOME/.bashrc" || local rcfile="$HOME/.zshrc"
        Assert config_is_in_file "$rcfile" "$TOOLS_HOME/.nvmrc"
        Assert config_is_in_file "$rcfile" "$TOOLS_HOME/.pyenvrc"
        Assert config_is_in_file "$rcfile" "$TOOLS_HOME/.git_promptrc"

        is_bash_shell && Assert "$TOOLS_HOME/.profile" "$TOOLS_HOME/.bashrc"

        Assert is_existing_directory "$TOOLS_HOME/.nvm"
        Assert is_existing_directory "$TOOLS_HOME/.pyenv"
        Assert is_existing_directory "$TOOLS_HOME/.git_prompt"     
    End 

End

rm_test_dir $test_home
export HOME=$ORI_HOME
unset rcfile
unset TOOLS_HOME
unset ORI_HOME