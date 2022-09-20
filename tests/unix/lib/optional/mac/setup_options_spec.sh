Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/optional/mac.sh"


Describe "setup_options() on Mac" Test:Unit
    
    Skip if "only for Mac"  is_not_mac

    It "it returns NOT_IMPLEMENTED"
        When call setup_options
        The status should equal $NOT_IMPLEMENTED
    End

End