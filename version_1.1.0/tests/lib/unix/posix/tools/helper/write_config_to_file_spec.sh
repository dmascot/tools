# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"
Include "$PWD/lib/unix/posix/tools/helper.sh"

test_content_1='This is simple config'

test_content_2='This is\
multi line\
config'

test_content_3='This is\
multi line\
config\

with blank line'

test_dir="$test_home/write_config"

test_config="$test_home/write_test.cfg"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_home"

Describe "write_config_to_file()" Test:Integration

    Context "fail if"
        BeforeEach "touch_test_file $test_config"
        AfterEach "rm_test_file $test_config"

        Parameters
        #   WHEN                            FILE                CONTENT             MESSAGE                                                            RETURN STATUS
            "file is not defined"           ""                  ""                  "failed! both \$config_file and \$config_string must be defined"    "False" $FALSE
            "content not defined"           "$test_config"      ""                  "failed! both \$config_file and \$config_string must be defined"    "False" $FALSE
            "path does not exist"           "/some/file.txt"    "some content"      "failed! path /some does not exist"                                 "False" $FALSE
        End

        It "is $4 when $1"
            When call write_config_to_file "$2" "$3"  &> /dev/null
            The status should equal $6
            The output should equal "Configuring $2....$4"
        End

    End

    Context "when file exists but config does not exist"

        BeforeEach "touch_test_file $test_config"
        AfterEach "rm_test_file $test_config"

        Parameters
        #   WHEN                            FILE            CONTENT             MESSAGE                                                            RETURN STATUS
            "content is simple"             "$test_config"  "$test_content_1"   "adding config...done!"                                             "True"  $TRUE
            "content is multiline"          "$test_config"  "$test_content_2"   "adding config...done!"                                             "True"  $TRUE
            "content is with blank line"    "$test_config"  "$test_content_3"   "adding config...done!"                                             "True"  $TRUE            
        End

        It "is $4 when $1"
            When call write_config_to_file "$2" "$3"  &> /dev/null
            The status should equal $6
            The output should equal "Configuring $2....$4"
        End

    End

    Context "when config alredy exist"

        BeforeEach "touch_test_file $test_config"
        AfterEach "rm_test_file $test_config"

        Parameters
        #   WHEN                            FILE            CONTENT             MESSAGE                                                            RETURN STATUS
            "content is simple"             "$test_config"  "$test_content_1"   "done!"                                             "True"  $TRUE
            "content is multiline"          "$test_config"  "$test_content_2"   "done!"                                             "True"  $TRUE
            "content is with blank line"    "$test_config"  "$test_content_3"   "done!"                                             "True"  $TRUE            
        End

        It "is $4 when $1"
            write_config_to_file "$2" "$3" &> /dev/null
            When call write_config_to_file "$2" "$3"
            The status should equal $6
            The output should equal "Configuring $2....$4"
        End

    End

    Skip if "root can write anywhere so skipping" is_running_as_root

    Context "when config can not be written"

        BeforeEach "touch_test_file $test_config"
        AfterEach "rm_test_file $test_config"

        root_file="/etc/hosts"

        Parameters
        #   WHEN                FILE            CONTENT             MESSAGE                                         RETURN STATUS
            "content is simple" "$root_file"    "$test_content_1"   "adding config...failed! can not write to file" "False" $FALSE
        End

        It "is $4 when $1"
            When call write_config_to_file "$2" "$3"  &> /dev/null
            The status should equal $6
            The output should equal "Configuring $2....$4"
            The stderr should include "$2"
        End

    End

End

unset test_content_1
unset test_content_2
unset test_content_3