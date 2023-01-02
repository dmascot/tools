Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"


test_dir="$test_home/is_empty_directory"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "is_empty_directory()" Test:Unit

    Parameters
    #   DIRECTORY PATH  EXPECTED STATUS
        "$HOME"         "False" $FALSE
        "$test_dir"     "True"  $TRUE
    End

    It "is $2 for path $1"
        When call is_empty_directory "$1"
        The status should equal $3
    End

End

unset test_dir