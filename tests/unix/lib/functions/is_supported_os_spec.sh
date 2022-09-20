Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe "is_supported_os()" Test:Unit

    Parameters
    #   OS              EXPECTED STATUS
        "OSX"           "True"  $TRUE
        "Ubuntu"        "True"  $TRUE
        "AnythingElse"  "False" $FALSE
    End

    It "is $2 when $1"
    
        When call is_supported_os "$1"
        The status should equal $3

    End

End