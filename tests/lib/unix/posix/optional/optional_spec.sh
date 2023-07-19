# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

#check if functions exist
Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/optional.sh"

#Simply check all the function exist

Describe "tools functions"

    Parameters
    #   SOURCE      FUNCTION NAME
        "optional"  "is_existing_user"
        "optional"  "create_user"
        "optional"  "set_hostname"
    End

    It "$1 function $2 Exists"
        Assert typeset -f $2 > /dev/null
    End

End