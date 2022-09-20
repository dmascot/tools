Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"


Describe "get_os_name()" Test:Unit

    Parameters
    #   System          Expected OS
        "Linux"         "Ubuntu"
        "Darwin"        "OSX"
        "AnythingElse"  "None"
    End

    Skip if "Linux Only" is_not_linux
    
    It "is $2 when unix system is $1"
        When call get_os_name "$1"
        The output should equal "$2"
    End
End