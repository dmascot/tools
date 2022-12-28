Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/optional/mac.sh"


Describe "is_existing_user() on Mac" Test:Unit
    
    Skip if "only for Mac"  is_not_mac
    
    Parameters
    #   USER        RETURN STATUS
        "AnyUser"   "Not Implemented"  $NOT_IMPLEMENTED
    End

    It "is $2 for user $1"
        When call is_existing_user "$1"
        The status should equal $3
    End

End