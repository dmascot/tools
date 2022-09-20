Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/tools/helper.sh"

test_dir="$test_home/get_tool"

AfterAll "rm_test_dir $test_home"

Describe "get_tool()" Test:Integration

    Context "when $test_dir directory does not exist"

        AfterEach "rm_test_dir $test_dir"

        Parameters
        #   NAME            DESTINATION             REPOSITORY          MESSAGE                                         RESULT STATUS
            "blunder-ful"   "$test_dir"             "$test_repo"        "done!"                                         "True"  $TRUE
            "wonder-fool"   "$invalid_test_path"    "$test_repo"        "failed! $invalid_test_path path is invalid"    "False" $FALSE
            "beauti-ful"    "$test_dir"             "$invalid_test_url" "failed! check if $invalid_test_url is valid?"  "False" $FALSE
        End

        It "is $5 when directory is $2 and repo is $3"
            When call get_tool "$1" "$2" "$3"
            The status should equal $6
            The output should equal "Cloning $1....$4"
        End

    End

    Context "when $test_dir directory is empty"
    
        BeforeEach "mk_test_dir $test_dir"
        AfterEach "rm_test_dir $test_dir"

        Parameters
        #   NAME            DESTINATION REPOSITORY      MESSAGE RESULT STATUS
            "blunder-ful"   "$test_dir" "$test_repo"    "done!" "True"  $TRUE
        End

        It "is $5 when directory is $2 and repo is $3"
            When call get_tool "$1" "$2" "$3"
            The status should equal $6
            The output should equal "Cloning $1....$4"
        End
    
    End

    Context "when $test_dir directory is not empty"
    
        BeforeEach "mk_test_dir $test_dir"
        AfterEach "rm_test_dir $test_dir"

        Parameters
        #   NAME            DESTINATION REPOSITORY      MESSAGE                             RESULT STATUS
            "blunder-ful"   "$test_dir" "$test_repo"    "failed! $test_dir is not empty"    "False" $FALSE
        End

        It "is $5 when directory is $2 and repo is $3"
            touch "$test_dir/.i_make_you_it_fail.txt"
            When call get_tool "$1" "$2" "$3"
            The status should equal $6
            The output should equal "Cloning $1....$4"
        End
    
    End
End

unset test_dir
