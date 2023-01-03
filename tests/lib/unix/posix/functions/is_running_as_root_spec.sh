Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

expected_result="False"

Describe "is_running_as_root()" Test:Unit
   
     [[ $(id -u) -eq 0 ]] && expected_result="True"

    It "is $expected_result when userid=$(id -u)"
        When call is_running_as_root
        if [[ $(id -u) -eq 0 ]]
        then 
            The status should be success
        else
            The status should be failure
        fi
    End

End

unset expected_result