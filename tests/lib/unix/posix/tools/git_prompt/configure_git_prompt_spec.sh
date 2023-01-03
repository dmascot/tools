Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/tools/helper.sh"
Include "$PWD/lib/unix/posix/tools/git_prompt.sh"

test_dir="$test_home/git_promptrc_test"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"


Describe "configure_git_prompt()" Test:Integration

    Context "called once"
        Parameters
            #   GIT_PROMPT_DIR              GIT_PROMPTRC                    OUTPUT                                          RESULT STATUS
            "$test_dir/.git_prompt"         "$test_dir/.git_promptrc"       "adding config...done!"                         "True"  $TRUE
            "$test_dir/tools/.git_prompt"   "$test_dir/tools/.git_promptrc" "failed! path $test_dir/tools does not exist"   "False" $FALSE
        End 

        It "is $4 for $2"
            When call configure_git_prompt "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"
        End
    End

    Context "called twice"
        Parameters
        #   GIT_PROMPT_DIR          GIT_PROMPTRC                OUTPUT      RESULT STATUS
            "$test_dir/.git_prompt" "$test_dir/.git_promptrc"   "done!"     "True"  $TRUE
        End 

        It "is True for $1"
            configure_git_prompt "$1" "$2" &> /dev/null
            When call configure_git_prompt "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"       
        End

    End

End