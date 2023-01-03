Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

test_dir="$test_home/git_clone_test"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "git_clone()" Test:Unit

    Parameters
    #   DIRECTORY           REPOSITORY      RESULT STATUS   
        "$test_dir"         "$test_repo"    "True"  $TRUE
        "/not/existing/"    "$test_Repo"    "False" $FALSE
    End

    It "is $3 when clone to $1"
        When call git_clone "$1" "$2"
        The status should equal $4
    End

End

unset test_dir