# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Describe "NVM_GIT_URL in variables.sh"

    It "is default when not set"
        source "$PWD/lib/unix/posix/variables.sh"
        The value "$NVM_GIT_URL" should equal "https://github.com/nvm-sh/nvm"
        unset NVM_GIT_URL
    End

    It "is value that we set when environment variable is set"
        repo_url="http://something/else"
        NVM_GIT_URL="$repo_url"

        source "$PWD/lib/unix/posix/variables.sh"
        The value "$NVM_GIT_URL" should equal "$repo_url"

        unset repo_url
        unset NVM_GIT_URL
    End
End