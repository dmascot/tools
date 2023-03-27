Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "is_supported_shell()" Test:Unit

    Parameters
    #   SHELL           EXPECTED STATUS
        "bash"          "True"  $TRUE
        "zsh"           "True"  $TRUE
        "qemuaarch64"   "True"  $TRUE
        "AnythingElse"  "False" $FALSE
    End

    It "is $2 when $1"
        When call is_supported_shell "$1"       
        The status should equal $3
    End 

End