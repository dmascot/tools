ORI_HOME=$HOME
HOME="$test_home/integration"

mk_test_dir $HOME
copy_profiles $HOME

Describe "Setup" Test:SetUpIntegration

    source "$PWD/setup.sh" 2>&1 > /dev/null
    
    It "should have following file"
        Assert is_existing_file "$HOME/.nvmrc"
        Assert is_existing_file "$HOME/.pyenvrc"
        Assert is_existing_file "$HOME/.git_promptrc"

        [[ $CURRENT_SHELL =~ bash ]] && local rcfile="$HOME/.bashrc" || local rcfile="$HOME/.zshrc"
        
        Assert config_is_in_file "$rcfile" "$HOME/.nvmrc"
        Assert config_is_in_file "$rcfile" "$HOME/.pyenvrc"
        Assert config_is_in_file "$rcfile" "$HOME/.git_promptrc"

        is_bash_shell && Assert "$HOME/.profile" "$HOME/.bashrc"

    End 

    It "should have following dir"
        Assert is_existing_directory "$HOME/.nvm"
        Assert is_existing_directory "$HOME/.pyenv"
        Assert is_existing_directory "$HOME/.git_prompt"     
    End 

End

rm_test_dir $test_home
HOME=$ORI_HOME