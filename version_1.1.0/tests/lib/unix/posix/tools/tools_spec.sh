# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

#check if functions exist
Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/tools.sh"

#Simply check all the function exist

Describe "tools functions"

    Parameters
    #   SOURCE      FUNCTION NAME
        "helper"        "get_tool"
        "helper"        "write_config_to_file"
        "helper"        "load_tool_in_shell"
        "git_prompt"    "get_git_prompt"
        "git_prompt"    "configure_git_prompt"
        "nvm"           "get_nvm"
        "nvm"           "configure_nvm"
        "pyenv"         "get_pyenv"
        "pyenv"         "configure_pyenv"
    End

    It "$1 function $2 Exists"
        Assert typeset -f $2 > /dev/null
    End

End