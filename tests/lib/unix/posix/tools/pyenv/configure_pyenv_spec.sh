Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/tools/helper.sh"
Include "$PWD/lib/unix/posix/tools/pyenv.sh"

test_dir="$test_home/pyenvrc"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "configure_pyenv()" Test:Integration

    Context "called once"
        Parameters
        #   PYENV_DIR                   PYENVRC                     OUTPUT                                          RESULT STATUS
            "$test_dir/.pyenv"        "$test_dir/.pyenvrc"          "adding config...done!"                                         "True"  $TRUE
            "$test_dir/tools/.pyenv"  "$test_dir/tools/.pyenvrc"    "failed! path $test_dir/tools does not exist"   "False" $FALSE
        End 

        It "is $4 for $2"
            When call configure_pyenv "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"
        End
    End

    Context "called twice"
        Parameters
        #   PYENV_DIR               PYENVRC             OUTPUT      RESULT STATUS
            "$test_home/.pyenv"     "$HOME/.pyenvrc"    "done!"     "True"  $TRUE
        End 

        It "is True for $1"
            configure_pyenv "$1" "$2" &> /dev/null
            When call configure_pyenv "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"          
        End

    End

End