Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

test_dir="$test_home/is_existing_path"
test_file="$test_dir/is_existing.file"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "is_existing_path()" Test:Unit

    Parameters
    #   DIRECTORY PATH  EXPECTED STATUS
        "$test_dir"     "True"  $TRUE
        "$test_file"    "True"  $TRUE
        "/some/path"    "False" $FALSE
    End

    It "is $2 for path $1"
        When call is_existing_path "$1"
        The status should equal $3
    End

End