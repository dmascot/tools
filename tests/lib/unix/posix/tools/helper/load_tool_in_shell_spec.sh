Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/tools/helper.sh"


test_dir="$test_home/load_tools_in_shell"
ORI_HOME="$HOME"
HOME="$test_dir"


BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

tool_config="$test_dir/toolrc"

Describe "load_tool_in_shell()" Test:Integration

    BeforeEach "copy_profiles $test_dir"
  
    
    [[ $CURRENT_SHELL =~ bash ]] && local destination_file="$HOME/.bashrc" || local destination_file="$HOME/.zshrc"

    It "adds config to $destination_file"
        When call load_tool_in_shell "$tool_config"
        The output should equal "Configuring $destination_file....adding config...done!"
        The status should equal $TRUE
    End
  
    It "validate $tool_config is in $destination_file"
        load_tool_in_shell "$tool_config" &> /dev/null
        When call config_is_in_file "$destination_file" "$tool_config"
        The status should equal $TRUE
    End

    Skip if "Only for BASH" is_not_bash_shell "$CURRENT_SHELL"

    It "validate $tool_config is in "$HOME/.profile""
        printf "" > "$HOME/.profile"
        load_tool_in_shell "$tool_config" &> /dev/null
        When call config_is_in_file "$HOME/.profile" "$tool_config"
        The status should equal $TRUE
    End

End

HOME="$ORI_HOME"
unset ORI_HOME

