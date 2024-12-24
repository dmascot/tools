# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix.sh"

ORI_UNIX_SYSTEM="$UNIX_SYSTEM"
ORI_CURRENT_SHELL="$CURRENT_SHELL"

#Note: This is to adjust index of PREREQUISITE_COMMANDS array, since bash and zsh started index at 0 and 1 respectively
[[ $CURRENT_SHELL =~ zsh ]] && INDEX=1

Describe "is_prerequisites_satisfied()" Test:SetupUnit

    Context "on fully supported environment"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL
            "Darwin"    "Mac"           "OSX"       "/bin/zsh"
            "Linux"     "WSL"           "Ubuntu"    "/usr/bin/zsh"
            "Linux"     "WSL_Docker"    "Ubuntu"    "/usr/bin/zsh"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/zsh"
            "Linux"     "Docker"        "Ubuntu"    "/usr/bin/zsh"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/zsh"
            "Darwin"    "Mac"           "OSX"       "/bin/bash"
            "Linux"     "WSL"           "Ubuntu"    "/usr/bin/bash"
            "Linux"     "WSL_Docker"    "Ubuntu"    "/usr/bin/bash"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/bash"
            "Linux"     "Docker"        "Ubuntu"    "/usr/bin/bash"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/bash"
        End 

        It "should success"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be success
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....$UNIX_SYSTEM system"
            The line 3 should equal "Found....$platform_name platform"
            The line 4 should equal "Found....$os_name os"
            The line 5 should equal "Found....$5$CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "Found....$TOOLS_HOME"
        End

    End 

    Context "with unpported shell"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL          
            "Darwin"    "Mac"           "OSX"       "/bin/tcsh"    
            "Linux"     "WSL"           "Ubuntu"    "/usr/bin/tcsh"
            "Linux"     "WSL_Docker"    "Ubuntu"    "/usr/bin/tcsh"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/tcsh"
            "Linux"     "Docker"        "Ubuntu"    "/usr/bin/tcsh"
            "Linux"     "Generic"       "Ubuntu"    "/usr/bin/tcsh"
        End 

        It "should fail"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be failure
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....$UNIX_SYSTEM system"
            The line 3 should equal "Found....$platform_name platform"
            The line 4 should equal "Found....$os_name os"
            The line 5 should equal "Found....unsupported $CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "Found....$TOOLS_HOME"
        End

    End 


    Context "with unpported os and shell"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL          
            "Darwin"    "Mac"           "OXS"       "/bin/tcsh"    
            "Linux"     "WSL"           "RedHat"    "/usr/bin/tcsh"
            "Linux"     "WSL_Docker"    "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Generic"       "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Docker"        "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Generic"       "RedHat"    "/usr/bin/tcsh"
        End 

        It "should fail"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be failure
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....$UNIX_SYSTEM system"
            The line 3 should equal "Found....$platform_name platform"
            The line 4 should equal "Found....unsupported $os_name os"
            The line 5 should equal "Found....unsupported $CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "Found....$TOOLS_HOME"
        End

    End 

    Context "with unpported platform,os and shell"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL          
            "Darwin"    "Make"          "OXS"       "/bin/tcsh"    
            "Linux"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "Linux"     "Anything"      "RedHat"    "/usr/bin/tcsh"
        End 

        It "should fail"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be failure
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....$UNIX_SYSTEM system"
            The line 3 should equal "Found....unsupported $platform_name platform"
            The line 4 should equal "Found....unsupported $os_name os"
            The line 5 should equal "Found....unsupported $CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "Found....$TOOLS_HOME"
        End

    End 

    Context "with unpported system,platform,os and shell"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL          
            "UnixA"      "Make"         "OXS"       "/bin/tcsh"    
            "UnixB"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixC"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixD"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixE"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixF"     "Anything"      "RedHat"    "/usr/bin/tcsh"
        End 

        It "should fail"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be failure
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....unsupported $UNIX_SYSTEM system"
            The line 3 should equal "Found....unsupported $platform_name platform"
            The line 4 should equal "Found....unsupported $os_name os"
            The line 5 should equal "Found....unsupported $CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "Found....$TOOLS_HOME"
        End

    End 

    Context "with unpported system,platform,os and shell and non0existing TOOLS_HOME"
        ORI_TOOLS_HOME="$TOOLS_HOME"

        Parameters
        #   SYSTEM      PLATFORM        OS          SHELL          
            "UnixA"      "Make"         "OXS"       "/bin/tcsh"    
            "UnixB"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixC"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixD"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixE"     "Anything"      "RedHat"    "/usr/bin/tcsh"
            "UnixF"     "Anything"      "RedHat"    "/usr/bin/tcsh"
        End 

        It "should fail"
            UNIX_SYSTEM="$1"
            CURRENT_SHELL="$4"

            platform_name="$2"
            os_name=$3
            TOOLS_HOME="/some/random/path"

            get_platform_name(){ echo "$platform_name"; }
            get_os_name(){ echo "$os_name"; }

            When call is_prerequisites_satisfied
            The status should be failure
            The line 1 should equal "Checking prerequisites...."
            The line 2 should equal "Found....unsupported $UNIX_SYSTEM system"
            The line 3 should equal "Found....unsupported $platform_name platform"
            The line 4 should equal "Found....unsupported $os_name os"
            The line 5 should equal "Found....unsupported $CURRENT_SHELL shell"
            The line 6 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+0]} command"
            The line 7 should equal "Found....${PREREQUISITE_COMMANDS[$INDEX+1]} command"
            The line 8 should equal "$TOOLS_HOME does not exist"
        End

        TOOLS_HOME="$ORI_TOOLS_HOME"
    End 

End

UNIX_SYSTEM="$ORI_UNIX_SYSTEM"
CURRENT_SHELL="$ORI_CURRENT_SHELL"