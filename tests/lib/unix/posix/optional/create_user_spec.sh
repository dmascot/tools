Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional.sh"


test_user="anyuser"

Describe "create_user()" Test:Integration

    Context "on Linux"
        Skip if "Only for Linux" is_not_linux

        Context "as sudo/root"
        
            AfterEach "userdel -r $test_user &> /dev/null"

            Skip if "works only for root/sudo user" is_not_running_as_root

            Parameters
            #   USER            RETURN STATUS
                "$test_user"    "True"  $TRUE
            End

            It "is $2 for user $1"
                When call create_user "$1"
                The status should equal $3
                Assert is_existing_user "$1"
            End

        End

        Context "without sudo"

            Skip if "Only for non sudo/root test" is_running_as_root

            Parameters
            #   USER        RETURN STATUS
                "AnyUser"   "False"  $FALSE
            End

            It "is $2 for user $1"
                When call create_user "$1"
                The status should equal $3
            End

        End
    End

    Context "on Mac"
        Skip if "only for Mac"  is_not_mac
    
        Parameters
        #   USER        RETURN STATUS
            "AnyUser"   "Not Implemented"  $NOT_IMPLEMENTED
        End

        It "is $2 for user $1"
            When call create_user "$1"
            The status should equal $3
        End
        
    End

End