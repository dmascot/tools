Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/optional/mac.sh"


Describe "setup_options_usage() on Mac" Test:Unit
    
    Skip if "only for Mac"  is_not_mac

    It "it simply returns NOT IMPLEMENTED"
        When call setup_options_usage
        The status should equal $NOT_IMPLEMENTED
    End

End