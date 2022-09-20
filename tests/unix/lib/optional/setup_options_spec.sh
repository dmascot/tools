Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/optional.sh"


Describe "setup_options()" Test:Unit

    Context "on Linux "

        Skip if "only for Linux"  is_not_linux

        It "with no options"
            When call setup_options
            The status should be successful
        End

        It "with -h option"
            prog_name=$0

            [[ $CURRENT_SHELL =~ zsh ]] && prog_name=$ZSH_ARGZERO

            When call setup_options -h 
            The status should be successful
            The line 1 should equal "Usage: $prog_name -u <user name> -n <host name> -e"
        End

        It "with invalid option prints help and exist with FALSE"
            prog_name=$0

            [[ $CURRENT_SHELL =~ zsh ]] && prog_name=$ZSH_ARGZERO

            When call setup_options -a
            The status should be successful
            The stderr should include "invalid option -- 'a'"
            The line 1 should equal "Usage: $prog_name -u <user name> -n <host name> -e"
        End

        It "with -u option sets DESIRED_USER"
            my_user="TestUser"
            When call setup_options -u "$my_user"
            The status should be successful
            Assert [ "$DESIRED_USER" = "$my_user" ]
        End

        It "with --h sets DESIRED_HOSTNAME"
            my_host="TesHost"
            When call setup_options -n "$my_host"
            The status should be successful
            Assert [ "$DESIRED_HOSTNAME" = "$my_host" ] 
        End

        It "with -e sets INSTALL_EXTRAS to True"
            When call setup_options -e
            The status should be successful
            Assert [ $INSTALL_EXTRAS -eq $TRUE ]
        End

        It "with all options i.e. -u -n and -e suppied"
            my_user="TestUser_TWO"
            my_host="TesHost_TWO"

            When call setup_options -u $my_user -n $my_host -e
            The status should be successful
            Assert [ "$DESIRED_USER" = "$my_user" ]
            Assert [ "$DESIRED_HOSTNAME" = "$my_host" ]
            Assert [ $INSTALL_EXTRAS -eq $TRUE ]
        End

    End

    Context "on Mac"
    
        Skip if "only for Mac"  is_not_mac

        It "it returns NOT_IMPLEMENTED"
            When call setup_options
            The status should equal $NOT_IMPLEMENTED
        End  
    End

End