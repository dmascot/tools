Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional.sh"


Describe "setup_options_usage()" Test:Unit
    
    Context "on Linux"

        Skip if "only for Linux"  is_not_linux

        It "shows usage"
            prog_name=$0
            [[ $CURRENT_SHELL =~ zsh ]] && prog_name=$ZSH_ARGZERO
            When call setup_options_usage
            The status should be successful
            The line 1 should equal "Usage: $prog_name -u <user name> -n <host name> -e"
        End

    End

    Context "on Mac"
    
        Skip if "only for Mac"  is_not_mac

        It "it simply returns NOT IMPLEMENTED"
            When call setup_options_usage
            The status should equal $NOT_IMPLEMENTED
        End
        
    End

End