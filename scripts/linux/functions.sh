#!/usr/bin/env bash 

print_error(){
  >&2 echo  "$@";
}

#Not tested
declare_variables(){
    declare SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    declare DETECTED_OS=$(cat /etc/os-release | grep '^NAME=' | awk -F'"' '{print $2}')

    declare DESIRED_USER
    declare DESIRED_HOSTNAME
    declare DESIRED_USER_UID=1000
    declare DETECTED_PLATFORM
}

#Not tested
clear_variables(){
    unset SCRIPTPATH
    unset DETECTED_OS
    unset DESIRED_USER
    unset DESIRED_HOSTNAME
    unset DESIRED_USER_UID
    unset DETECTED_PLATFORM
}

set_defaults(){

    export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    export DETECTED_OS=$(cat /etc/os-release | grep '^NAME=' | awk -F'"' '{print $2}')
    [[ -z $DESIRED_HOSTNAME ]] && export DESIRED_HOSTNAME=$HOSTNAME;
    [[ -z $DESIRED_USER ]] && export DESIRED_USER=$USER;   
    [[ -z $DESIRED_UID ]] && export DESIRED_UID=1000

}

detect_platform(){

    PROC_INIT=$(cat /proc/1/sched | head -n 1)

    if [[ "$(uname -r)" =~ "WSL" ]]
    then 
        DETECTED_PLATFORM='WSL'

        if ! [[ $PROC_INIT =~ init ]]
        then
             DETECTED_PLATFORM="WSL_DOCKER"
        fi
    else 
        is_docker=$(grep -c 'docker\|lxc' /proc/1/cgroup)
        if [ $is_docker -gt 0 ]
        then
            DETECTED_PLATFORM='DOCKER'
        else 
            DETECTED_PLATFORM="GENERIC"
        fi 
    fi

    export DETECTED_PLATFORM
}

#Not tested
options_usage(){
    echo "Usage: $0 -u <user name> -i <user id> -n <host name>"
    echo "-u  specifiys user for which tools need to be installed and, create user if user does not exist,defaults to current user"
    echo "-i User and group id of the user you wish to create, defaults to 1000"
    echo "-n specifys the hostname that you want to set,this option is not effective on docker platform,defaults to current hostname"
    echo "-h shows this message"
    echo 
    echo "creating user and, setting hostname needs sudo/root access,if that is not the case, script would exit"
    echo 
}

shell_options() {

    ARGS=("$@")

    PARSED_OPTIONS=$(getopt -n "${0}" -o u:n:i:h -l user:,hostname:,uid:,help: -- "$@")
    
    if [ $? -ne 0 ] ; then options_usage && exit 1; fi 

    eval set -- "${PARSED_OPTIONS}"
    
 
    while true; do
        case "$1" in
        -u|--user)
            DESIRED_USER="$2"
            shift 2
            ;; 
        -i|--uid)
            DESIRED_UID="$2"
            shift 2
            ;; 
        -n|--hostname)
            DESIRED_HOSTNAME="$2"
            shift 2
            ;;
        -h|--help)
            options_usage
            exit 0
            ;;
        *)
            break
            ;;
         esac
    done
}

validator(){
    uid_re='^[[:digit:]]{4,5}$'

    [[ -z $DETECTED_OS ]] || [[ -z $DETECTED_PLATFORM ]] && print_error "Both DETCTED_OS and, DETECTED_PLATFORM must be set have you called detect_environemnt() function in your script?" && return 1;
    [[ ${DETECTED_OS} != "Ubuntu" ]] && print_error "Currently only Ubuntu is supported" && return 1;
    ! [[ $DETECTED_PLATFORM =~ WSL|DOCKER|GENERIC ]] && print_error "Invalid environemt dected,Please report this to developer with as much detail you can to replicate the incident" && return 1;
    ! [[ $DESIRED_UID =~ $uid_re ]] && print_error "--uid/-i needs to be 4 to 5 digit long number" && return 1;
    return 0
}


is_running_as_root(){
    [[ $EUID -eq 0 ]] && return 0;
    return 1;
}

is_existing_sudo_user(){
   sudo -v -u $1 > /dev/null 2>&1 && return $?
}

#Not tested
has_superpower(){
    if [ is_running_as_root ] || [ is_existing_sudo_user ${USER} ]
    then 
        return 0
    fi 
    return 1
}

#takes packages as a parameter
is_package_installed(){
    dpkg-query --show --showformat='${db:Status-Status}' "${1}" 2>/dev/null | grep -q 'installed' > /dev/null 2>&1 && return $?
}

#read packages that needs to be installed
#Not tested
read_packages_from_file(){
    packages=""
    while read -r line || [ -n "${line}" ]
    do
        words=($line)
        for word in ${words[@]}
        do 
            packages+="$word "
        done 
    done < $1

    packages=$(echo ${packages} | sed 's/[[:blank:]]*$//')
    echo "${packages}"
}

#takes packages as a parameter
install_packages(){
    if is_running_as_root
    then
        apt-get update -y > /dev/null 2>&1
        apt-get install -y $1  > /dev/null 2>&1
    else 
        print_error "Skipping package installation,user need to be root/sudo"
    fi 
}

#Have not tested this with shuint2
#takes no parameter
update_and_upgrade(){
    if is_running_as_root
    then
        apt-get update > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1
    else
        print_error "Skipping Update and,Upgrade,user need to be root/sudo"
    fi
}

#Have not tested this with shuint2
#takes no parameter
clean_installation(){
    apt-get clean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
}

#Takes username as a parameter
is_existing_user(){
    getent passwd $1  > /dev/null 2>&1 && return $?
}

#Not tested
is_existing_uid(){
    getent passwd $1  > /dev/null 2>&1 && return $?
}
#takes uer to be created as parameter
create_user(){
    sudo addgroup --system --quiet netdev
    sudo useradd -u $2 -U -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev -m -s /usr/bin/bash $1
}

is_existing_file(){
    test -f "$1" && return $?
}

#takes user to be added as a parameter
add_user_to_sudoers(){
    if is_running_as_root
    then 
        echo "$1 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    else
        print_error "Skipping add to sudo for ${DESIRED_USER}, script need to need to be root/sudo"
    fi 
}

is_existing_hostname(){
    grep -q "$1" /etc/hostname && return $?
}

#takes  hostname to be used as a parameter
update_hostname(){
    #Docker does not support updating hosts/hostname when inside container
    if ! [[ "${DETECTED_PLATFORM}" =~ "DOCKER" ]]
    then 
        sudo sed -i.bak "s/$HOSTNAME/$1/g" /etc/hosts
        sudo sed -i.bak "s/$HOSTNAME/$1/g" /etc/hostname
    fi 
}

#This assumes, you have varialbe placed in environemtn and
# template file as variable to be replaced in ${THIS_VARIABLE} format
generate_conf_from_template(){
    TEMPLATE_SRC=$1
    TEMPLATE_DEST=$2

    if [ -f $TEMPLATE_DEST ]; then mv $TEMPLATE_DEST $TEMPLATE_DEST.bak ; fi 

    cp $TEMPLATE_SRC $TEMPLATE_DEST

    env | while IFS='=' read -r key val; do
        if $(grep -q "\\\${$key}" "${TEMPLATE_DEST}")
        then
            sed -i "s/\${$key}/$val/g" "${TEMPLATE_DEST}"
        fi
    done

    dos2unix $TEMPLATE_DEST > /dev/null 2>&1
}

