
is_existing_user(){
    #check if user name exists on Linux based os
    # Params:
    # - user_name, as first argument
    # Depends on:
    # - variables.sh ( via is_macos )
    # - functions.sh
    # Retruns:
    #
    # Note: only for Linux

    local user_name="$1"

    getent passwd $user_name &> /dev/null

    if [[ $? -eq 0 ]]
    then 
        return $TRUE
    fi 

    return $FALSE
}

create_user(){
    #Create user on Linux
    # Params:
    # - user_name , user_name to create
    # Depends on:
    # - variables.sh ( via is_macos )
    # - functions.sh
    # Retruns: Boolean 
    #
    # Note: 
    # - works only for root/sudo user
    # - ensure to check if is existing user and, user have sudo permission before using this
    local user_name="$1"

    addgroup --system --quiet netdev &> /dev/null
    useradd -U -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev -m -s $(which $CURRENT_SHELL) $user_name &> /dev/null ; local user_add_status=$?
    [[ $user_add_status -eq 0 ]] && return $TRUE || return $FALSE
}

set_hostname(){
    # set/change hostname on Linux
    # Params:
    # - name , new hostname
    # Depends on:
    # - variables.sh ( via is_macos )
    # Retruns: Boolean 
    #
    # Note: ensure to check if hostname is same as current hostname 
    local name="$1"
    local current_hostname=$(hostname)

    local hostnamectl_status
    local hosts_status 

    is_not_running_as_root && return $FALSE

    hostnamectl hostname "$1" &> /dev/null ; hostnamectl_status=$?

    if [[ $hostnamectl_status -eq $TRUE ]]
    then
        #attempt to Update hosts file if hostnamectl is sucess
        sed -i.bak "s/$current_hostname/$1/g" /etc/hosts &> /dev/null ; hosts_status=$?
    fi

    [[ $hostnamectl_status -ne $TRUE ]] || [[ $hosts_status -ne $TRUE ]] && return $FALSE || return $TRUE
}


setup_options_usage(){
    local prog_name=$0

    [[ $CURRENT_SHELL =~ zsh ]] && prog_name=$ZSH_ARGZERO

    logger "Usage: $prog_name -u <user name> -n <host name> -e\n"
    logger "-u  specifiys user for which tools need to be installed and, create user if user does not exist,defaults to current user\n"
    logger "-n specifys the hostname that you want to set,this option is not effective on docker platform,defaults to current hostname\n"
    logger "-e enable to install extras\n"
    logger "-h shows this message\n"
    logger "\n"

    return $TRUE
}

setup_options() {

    ARGS=("$@")

    PARSED_OPTIONS=$(getopt -n "${0}" -o u:n:eh -l user:,hostname:,extras,help: -- "$@")
    
    if [ $? -ne 0 ] ; then setup_options_usage && return $FALSE; fi 

    eval set -- "${PARSED_OPTIONS}"
    
    while true; do
        case "$1" in
        -u|--user)
            DESIRED_USER="$2"
            shift 2
            ;; 
        -n|--hostname)
            DESIRED_HOSTNAME="$2"
            shift 2
            ;;
        -e|--extras)
            INSTALL_EXTRAS=$TRUE
            shift 
            ;;
        -h|--help)
            setup_options_usage
            break
            ;;
        *)
            break
            ;;
         esac
    done

    return $TRUE
}