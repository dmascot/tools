Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional/linux.sh"


Describe "setup_options_usage() on Linux" Test:Unit
    
    Skip if "only for Linux"  is_not_linux

    It "it shows options"
        prog_name=$0
        [[ $CURRENT_SHELL =~ zsh ]] && prog_name=$ZSH_ARGZERO
        When call setup_options_usage
        The status should be successful
        The line 1 should equal "Usage: $prog_name -u <user name> -n <host name> -e"
    End

End