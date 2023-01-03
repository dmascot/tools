Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

test_dir="$test_home/create_directory_test"

AfterAll "rm_test_dir $test_home"

Describe "create_directory()" Test:Unit

    Parameters
    #   DIRECTORY PATH      EXPECTED STATUS
        "$test_dir"         "True"  $TRUE
        "/root/priv/path"   "False" $FALSE
    End

    Skip if "becasue it will always pass for root" is_running_as_root

    It "is $2 for path $1"
        When call create_directory "$1"
        The status should equal $3
    End

End

unset test_dir
