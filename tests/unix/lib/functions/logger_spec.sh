Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe "logger()" Test:Unit
    It  "print expected messsage"
        local expected_message="this is expected"
        When call logger "$expected_message"
        The output should equal "$expected_message"
    End 
End