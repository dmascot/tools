Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"


        
Describe "is_mac()" Test:Unit

    Parameters
    #   SYSTEM          EXPECTED STATUS
        "Darwin"        "True"  $TRUE
        "AnythingElse"  "False" $FALSE
    End

    It "is $2 when $1"
        UNIX_SYSTEM_ORI="$UNIX_SYSTEM"

        UNIX_SYSTEM="$1"
        When call is_mac
        The status should equal $3

        UNIX_SYSTEM="$UNIX_SYSTEM_ORI"
    End

End

