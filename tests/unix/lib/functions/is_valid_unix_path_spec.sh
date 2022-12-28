Include "$PWD/lib/unix/variables.sh"
Include "$PWD/lib/unix/functions.sh"

Describe 'is_valid_unix_path()'

    Parameters
    #   PATH                        RESULT STATUS
        'invalid\path\'         'False' $FALSE
        'c:\another\invalid\'   'False' $FALSE
        '/valid/path'           'True'  $TRUE
        'this/is/valid'         'True'  $TRUE
        'this/is/valid/too/'    'True'  $TRUE
        '/so/is/this'           'True'  $TRUE
    End

    It "is $2 for $1"
        When call is_valid_unix_path "$1"
        The status should equal $3
    End

End