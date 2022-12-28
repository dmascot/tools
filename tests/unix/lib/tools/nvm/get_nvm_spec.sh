Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"
Include "$PWD/lib/unix/tools/helper.sh"
Include "$PWD/lib/unix/tools/nvm.sh"

test_dir="$test_home/get_nvm"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "get_nvm()" Test:Integration
    Parameters
 #   DESTINATION     MESSAGE                                 RESULT STATUS
        "$test_dir"     "done!"                                 "True"  $TRUE
        "\some\dir"     "failed! \some\dir path is invalid"     "False" $FALSE
    End 

    It "is $3 for $1"
        When call get_nvm "$1" "$NVM_GIT_URL"
        The status should equal $4
        The output should equal "Cloning NVM....$2"
    End

End