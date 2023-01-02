test_home="/tmp/tools"
test_repo="https://github.com/octocat/Spoon-Knife.git"

invalid_test_repo="https://this/should/fail"
invalid_test_path="\some\path\\"
lib_fixture_dir="$PWD/tests/fixtures/lib/unix/posix"


is_not_linux_or_is_docker(){
    local platform_name=$(get_platform_name $UNIX_SYSTEM)
    local is_not_linux_status

    is_not_linux && is_not_linux_status=$?
    
    [[ $is_not_linux_status == $TRUE ]] || [[ $platform_name =~ (Docker|None) ]] && return $TRUE

    return $FALSE
}

is_bash_shell(){
    [[ $1 =~ bash ]] && return $TRUE || return $FALSE
}

is_zsh_shell(){
    [[ $1 =~ zsh ]] && return $TRUE || return $FALSE
}

is_not_bash_shell(){
    [[ $1 =~ bash ]] && return $FALSE || return $TRUE
}

is_not_zsh_shell(){
    [[ $1 =~ zsh ]] && return $FALSE || return $TRUE
}

mk_test_dir(){
    if [[ ! -d "$1" ]]
    then 
        mkdir -p "$1" &> /dev/null
    fi
}

rm_test_dir(){
    if [[ -d "$1" ]]
    then
        rm -rf "$1" &> /dev/null 
    fi
}

touch_test_file(){
    if [[ ! -f "$1" ]]
    then 
        touch "$1"
    fi
}

rm_test_file(){
    if [[ ! -f "$1" ]]
    then 
        rm "$1"
    fi
}

copy_profiles(){
    destination="$1"

    cp "$lib_fixture_dir/.bashrc" "$destination"
    cp "$lib_fixture_dir/.profile" "$destination"
    cp "$lib_fixture_dir/.zshrc" "$destination"

}

rm_profiles(){
    destination="$1"
    rm "$destination/.bashrc"
    rm "$destination/.profile" 
    rm "$destination/.zshrc"

}
