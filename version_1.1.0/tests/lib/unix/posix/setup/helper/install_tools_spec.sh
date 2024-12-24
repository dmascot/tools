# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix.sh"

test_dir="$test_home/setup_install_tools"


AfterAll "rm_test_dir $test_home"


ORI_GIT_PROMPT_DIR="$GIT_PROMPT_DIR"
ORI_GIT_PROMPTRC="$GIT_PROMPTRC"

ORI_NVM_DIR="$NVM_DIR"
ORI_NVMRC="$NVMRC"

ORI_PYENV_DIR="$PYENV_DIR"
ORI_PYENVRC="$PYENVRC"

GIT_PROMPT_DIR="$test_dir/.git_prompt"
GIT_PROMPTRC="$test_dir/.git_promptrc"

NVM_DIR="$test_dir/.nvm"
NVMRC="$test_dir/.nvmrc"

PYENV_DIR="$test_dir/.pyenv"
PYENVRC="$test_dir/.pyenvrc"

ORI_HOME="$HOME"
HOME="$test_dir"

RC_FILE="$HOME/.bashrc"
[[ $CURRENT_SHELL =~ zsh ]] && RC_FILE="$HOME/.zshrc"

Describe "install_tools()" Test:SetupUnit

    BeforeEach "mk_test_dir $test_dir && copy_profiles $test_dir"
    AfterEach "rm_test_dir $test_dir"

    It "should install tools and update config and know profile is loading bashrc"
        When call install_tools
        The status should be successful
        The line 1 should equal "Cloning GIT Prompt....done!"
        The line 2 should equal "Configuring $GIT_PROMPTRC....adding config...done!"
        The line 3 should equal "Configuring $RC_FILE....adding config...done!"
        The line 4 should equal "Cloning NVM....done!"
        The line 5 should equal "Configuring $NVMRC....adding config...done!"
        The line 6 should equal "Configuring $RC_FILE....adding config...done!"
        The line 7 should equal "Cloning pyenv....done!"
        The line 8 should equal "Configuring $PYENVRC....adding config...done!"
        The line 9 should equal "Configuring $RC_FILE....adding config...done!"
        Assert config_is_in_file $RC_FILE $GIT_PROMPTRC
        Assert config_is_in_file $RC_FILE $NVMRC
        Assert config_is_in_file $RC_FILE $PYENVRC
    End

    Skip if "only for bash shell" is_not_bash_shell $CURRENT_SHELL

    It "should install tools and update config and know profile is not loading bashrc"
        
        printf "" &> "$HOME/.profile"
        When call install_tools
        The status should be successful
        The line 1 should equal "Cloning GIT Prompt....done!"
        The line 2 should equal "Configuring $GIT_PROMPTRC....adding config...done!"
        The line 3 should equal "Configuring $RC_FILE....adding config...done!"
        The line 4 should equal "Configuring $HOME/.profile....adding config...done!"
        The line 5 should equal "Cloning NVM....done!"
        The line 6 should equal "Configuring $NVMRC....adding config...done!"
        The line 7 should equal "Configuring $RC_FILE....adding config...done!"
        The line 8 should equal "Configuring $HOME/.profile....adding config...done!"
        The line 9 should equal "Cloning pyenv....done!"
        The line 10 should equal "Configuring $PYENVRC....adding config...done!"
        The line 11 should equal "Configuring $RC_FILE....adding config...done!"
        The line 12 should equal "Configuring $HOME/.profile....adding config...done!"
        Assert config_is_in_file $RC_FILE $GIT_PROMPTRC
        Assert config_is_in_file $RC_FILE $NVMRC
        Assert config_is_in_file $RC_FILE $PYENVRC
        Assert config_is_in_file "$HOME/.profile" $GIT_PROMPTRC
        Assert config_is_in_file "$HOME/.profile" $NVMRC
        Assert config_is_in_file "$HOME/.profile" $PYENVRC
    End

End

HOME="$ORI_HOME"
GIT_PROMPT_DIR="$ORI_GIT_PROMPT_DIR"
GIT_PROMPTRC="$ORI_GIT_PROMPTRC"
NVM_DIR="$ORI_NVM_DIR"
NVMRC="$ORI_NVMRC"
PYENV_DIR="$ORI_PYENV_DIR"
PYENVRC="$ORI_PYENVRC"