Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe "is_supported_system()" Test:Unit

    Parameters
    #   SYSTEM          EXPECTED STATUS
        "Linux"         "True"  $TRUE
        "Darwin"        "True"  $TRUE
        "AnythingElse"  "False" $FALSE
    End
    
    It "is $2 when $1"
    
        When call is_supported_system "$1"
        The status should equal $3
        
    End

End