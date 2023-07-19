# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

#multiline test config with no blank line
test_config_1='This file is to test config related functions\
Line two\
Line three'

#multiline test config with blank line
test_config_2='This file is to test config related functions\
Line two\
Line three\

some other Line'


fixture_config="$lib_fixture_dir/config"

Describe "config_is_in_file()" Test:Unit

    Parameters
    #   WHEN                                    CONFIG FILE         CONFIG               RESULT STATUS
        "both args are unset"                   ""                  ""                   "VARIABLE_NOT_DEFINED" $VARIABLE_NOT_DEFINED
        "only one arg is set"                   "SOMEFILE"          ""                   "VARIABLE_NOT_DEFINED" $VARIABLE_NOT_DEFINED
        "config not in file"                    "$fixture_config"   "not in File"        "False"                $FALSE        
        "config is in file"                     "$fixture_config"   "This file"          "True"                 $TRUE
        "multiline config without blank line"   "$fixture_config"   "$test_config_1"     "True"                 $TRUE
        "multiline config with blank line"      "$fixture_config"   "$test_config_2"     "True"                 $TRUE
    End

    It "$4 when $1"
        When call config_is_in_file "$2" "$3"
        The status should equal $5
    End

End

unset test_config_1
unset test_config_2