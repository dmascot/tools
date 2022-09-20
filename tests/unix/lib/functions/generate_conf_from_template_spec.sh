Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

test_dir="$test_home/generate_conf"
template_source="$lib_fixture_dir/conf.template"
template_destination="$test_dir/test.conf"

BeforeAll "mk_test_dir $test_dir"
AfterAll "rm_test_dir $test_dir"

Describe "generate_conf_from_template()"

    Parameters
    #   Emotion     Line                    Number
        "happy"     "multiline"             1
        ""          "some thing"            3
        ""          ""                      4
        "good"      "what ever"
        "very good" ""
        ""          ""             
    End

    It "should generate template containing $1,$2 and $3"
        set emotion="$1"
        set line="$2"
        set number="$3"

        When call generate_conf_from_template $template_source $template_destination
        Assert grep -qF "using envsubst makes me ${emotion}" $template_destination
        Assert grep -qF "which works in ${line} set up too" $template_destination
        Assert grep -qF "can also have number like ${number}" $template_destination

        unset emotion
        unset line
        unset number
    End
End