Include "$PWD/lib/unix/posix/variables.sh"
Include "$PWD/lib/unix/posix/functions.sh"

Describe "get_platform_name()" Test:Unit

    Parameters
    #   SYSTEM      KERNEL VERSION      DOCKERENV   EXPECTED PLATFORM    
        "Darwin"    "does-not-matter"   $FALSE      "Mac"
        "Linux"     "some-kernel"       $FALSE      "Generic"
        "Linux"     "some-kernel"       $TRUE       "Docker"
        "Linux"     "some-WSL-version"  $FALSE      "WSL"
        "Linux"     "some-WSL-version"  $TRUE       "WSL_Docker"
    End 
    
    It "is $5 when $1 is with kernel $2 and, init $3"
        UNIX_SYSTEM=$1
        KNAME="$2"
        DOCKERENV_PRESENT=$3
    
        uname() { echo "$KNAME" ; }

        is_existing_file(){
            return $DOCKERENV_PRESENT
        }    

        When call get_platform_name "$1"
        The output should equal "$4"
    End



End