# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional.sh"
        
test_hostname="wanderlust"

Describe "set_hostname() on Linux" Test:Integration

    Context "Linux"

        Skip if "only for Generic linux" is_not_linux_or_is_docker

        Context "as sudo/root"

            Skip if "works only for root/sudo user" is_not_running_as_root

            original_hostname=$(hostname)

            BeforeEach "cp /etc/hosts /etc/hosts_beforetest"
            AfterAll "set_hostname $original_hostname && cp /etc/hosts_beforetest /etc/hosts && rm /etc/hosts_beforetest && rm /etc/hosts.bak"

            Parameters
            #   Hostname            RETURN STATUS
                "$(hostname)"       "True"  $TRUE
                "$test_hostname"    "True"  $TRUE    
            End

            It "$2 for hostname $1"
                When call set_hostname $1
                The status should equal $3
                Assert is_current_hostname "$1"
            End
        End

        Context "without sudo"

            Skip if "Only for non sudo/root test" is_running_as_root

            Parameters
            #   HOSTNAME    RETURN STATUS
                "WHATEVER"  "False" $FALSE
            End

            It "is $2 for hostname $1"
                When call set_hostname "$1"
                The status should equal $3
            End

        End
    End

    Context "Mac"
        
        Skip if "only for Mac"  is_not_mac
        
        Parameters
        #   HOSTNAME    RETURN STATUS
            "WHATEVER"  "Not Implemented"  $NOT_IMPLEMENTED
        End

        It "is $2 for user $1"
            When call set_hostname "$1"
            The status should equal $3
        End

    End

End