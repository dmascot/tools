Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/optional/linux.sh"
        
Describe "is_existing_user() on Linux" Test:Unit
    
    Skip if "only for Linux" is_not_linux

    Parameters
    #   USER                RETURN STATUS
        "$USER"             "True"  $TRUE
        "does_not_exist"    "False" $FALSE
    End

    It "is $2 for user $1"
        When call is_existing_user "$1"
        The status should equal $3
    End

End