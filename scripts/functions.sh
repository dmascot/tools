#!/usr/bin/env bash 

declare SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
declare DETECTED_OS=$(cat /etc/os-release | grep '^NAME=' | awk -F'"' '{print $2}')

declare DESIRED_USER
declare DESIRED_HOSTNAME
declare DESIRED_USER_UID=1000
declare DETECTED_ENVIRONMENT


print_error(){
  >&2 echo  "$@";
}

detect_environment(){

    if [[ "$(uname -r)" =~ "WSL" ]]
    then 
        DETECTED_ENVIRONMENT='WSL'
        DESIRED_USER=$USER
        DESIRED_HOSTNAME=$HOSTNAME

        if ! [[ $(cat /proc/1/sched | head -n 1) =~ init ]]
        then
             DETECTED_ENVIRONMENT="WSL_DOCKER"
        fi
    else 
        if [[  $(cat /proc/1/sched | head -n 1) =~ init ]]
        then 
            DETECTED_ENVIRONMENT='UNSUPPORTED'
        else 
            DETECTED_ENVIRONMENT="DOCKER"
        fi 
    fi

}


set_defaults(){

    case $DETECTED_ENVIRONMENT in
        "WSL")
            DESIRED_USER="${USER}"
            DESIRED_HOSTNAME="${HOSTNAME}"
            return 0
            ;;
        "DOCKER")
            DESIRED_USER="ubuntu"
            DESIRED_HOSTNAME="sandbox"
            return 0
            ;;
        "UNSUPPORTED")
            print_error "Unsupported environment detected"
            return 1
            ;;
    esac
}

shell_options() {

    ARGS=("$@")

    PARSED_OPTIONS=$(getopt -n "${0}" -o u:h: -l user:,hostname: -- "$@")
    
    if [ $? -ne 0 ] ; then echo "Invalid options supplied" && exit 1; fi 

    eval set -- "${PARSED_OPTIONS}"
    
 
    while true; do
        case "$1" in
        -u|--user)
            DESIRED_USER="$2"
            shift 2
            ;; 
        -h|--hostname)
            DESIRED_HOSTNAME="$2"
            shift 2
            ;;
        *)
            break
            ;;
         esac
    done
}

validator(){
    [[ -z $DETECTED_OS ]] || [[ -z $DETECTED_ENVIRONMENT ]] && print_error "Both DETCTED_OS and, DETECTED_ENVIRONMENT must be set have you called detect_environemnt() function in your script?" && return 1;
    [[ ${DETECTED_OS} != "Ubuntu" ]] && print_error "Currently only Ubuntu is supported" && return 1;
    ! [[ $DETECTED_ENVIRONMENT =~ WSL|DOCKER|UNSUPPORTED ]] && print_error "Invalid environemt dected,Please report this to developer with as much detail you can to replicate the incident" && return 1;
    [[ "${DETECTED_ENVIRONMENT}" == "UNSUPPORTED" ]] && print_error "Only Docker and WSL environment are supported" && return 1;
    return 0
}


is_running_as_root(){
    [[ $EUID -eq 0 ]] && return 0;
    return 1;
}

#takes packages as a parameter
is_package_installed(){
    dpkg -L "$1" > /dev/null 2>&1 && return $?
}

#takes packages as a parameter
install_packages(){
    if is_running_as_root
    then
        apt-get install -y "$1"  > /dev/null 2>&1
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
    getent passwd $1 && return $?
}

#takes uer to be created as parameter
create_user(){
    if is_running_as_root
    then
        addgroup --system --quiet netdev
        useradd -u 1000 -U -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev -m -s /usr/bin/bash $1
    else 
        print_error "Skipping create user,need to be root/sudo"
    fi 
}

is_existing_sudo_user(){
    grep -q "^$1" /etc/sudoers && return $?
}


is_existing_file(){
    test -f "$1" && return $?
}

#takes user to be added as a parameter
add_user_to_sudoers(){
    if is_running_as_root
    then 
        echo "$1 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    fi 
}

is_existing_hostname(){
    grep -q "$1" /etc/hostname && return $?
}

#takes  hostname to be used as a parameter
update_hostname(){
    #Docker does not support updating hosts/hostname when inside container
    if is_running_as_root && ! [[ "${DETECTED_ENVIRONMENT}" =~ DOCKER ]]
    then 
        sed -i.bak "s/$HOSTNAME/$1/g" /etc/hosts
        sed -i.bak "s/$HOSTNAME/$1/g" /etc/hostname
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