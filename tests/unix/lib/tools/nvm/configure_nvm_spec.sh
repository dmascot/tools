Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/tools/helper.sh"
Include "$PWD/lib/unix/tools/nvm.sh"

test_dir="$test_home/nvmrc_test"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "configure_nvm()" Test:Integration

    Context "called once"
        Parameters
        #   NVM_DIR             NVMRC                       OUTPUT                                          RESULT STATUS
            "$test_dir/.nvm"        "$test_dir/.nvmrc"          "adding config...done!"                         "True"  $TRUE
            "$test_dir/tools/.nvm"  "$test_dir/tools/.nvmrc"    "failed! path $test_dir/tools does not exist"   "False" $FALSE
        End 

        It "is $4 for $2"
            When call configure_nvm "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"
        End
    End

    Context "called twice"
        Parameters
        #   NVM_DIR             NVMRC               OUTPUT      RESULT STATUS
            "$test_dir/.nvm"    "$test_dir/.nvmrc"  "done!"     "True"  $TRUE
        End 

        It "is True for $1"
            configure_nvm "$1" "$2" &> /dev/null
            When call configure_nvm "$1" "$2"
            The status should equal $5
            The output should equal "Configuring $2....$3"          
        End

    End

End