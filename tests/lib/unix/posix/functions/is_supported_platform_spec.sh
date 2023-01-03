Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "is_supported_platform()" Test:Unit

    Parameters
    #   Platform        EXPECTED STATUS
        "Generic"       "True"  $TRUE
        "WSL"           "True"  $TRUE
        "Docker"        "True"  $TRUE
        "WSL_Docker"    "True"  $TRUE
        "AnythingElse"  "False" $FALSE

    End

    It "is $2 when platform is $1"

        When call is_supported_platform "$1"
        The status should equal $3

    End
End