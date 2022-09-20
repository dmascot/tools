Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"


        
Describe "is_not_linux()" Test:Unit

    Parameters
    #   SYSTEM          EXPECTED STATUS
        "Linux"         "False" $FALSE
        "AnythingElse"  "True"  $TRUE
    End

    It "is $2 when $1"
        UNIX_SYSTEM_ORI="$UNIX_SYSTEM"

        UNIX_SYSTEM="$1"
        When call is_not_linux
        The status should equal $3

        UNIX_SYSTEM="$UNIX_SYSTEM_ORI"
    End

End

