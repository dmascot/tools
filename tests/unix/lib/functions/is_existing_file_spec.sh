Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe "is_existing_file()" Test:Unit

    Parameters
    #   DIRECTORY PATH  EXPECTED STATUS
        "/etc/hosts"    "True"  $TRUE
        "/some/file"    "False" $FALSE
    End

    It "is $2 for path $1"
        When call is_existing_file "$1"
        The status should equal $3
    End

End