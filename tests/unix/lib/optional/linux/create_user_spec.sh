Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/optional/linux.sh"


test_user="anyuser"

Describe "create_user() on Linux" Test:Unit
    
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