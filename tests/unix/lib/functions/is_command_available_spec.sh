Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe "is_command_available()" Test:Unit

    Parameters
    #   COMMAND EXPECTED STATUS
        "ls"    "True"  $TRUE
        "kjnh"  "False" $FALSE
    End

    It "is $2 for command $1"
        When call is_command_available "$1"
        The status should equal $3
    End

End
