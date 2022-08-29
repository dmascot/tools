#!/usr/bin/env bash

#This script lets you set up whole set of things i.e.
# - install required packages
# - create user 
# - give new user sudo access (with NOPASSWD )
# - Install tools
# - update/change hostname
# Along with this , it does following optional settings
# For Both WSL and Generic
# - Adds script to autoadd ssh key to agent when you open terminal for the firt time
# - Adds script to mount SMB Share
# For WSL Only
#  - Add wsl.conf file
# - addes script to mount direcoty from host
#
# It also  installs tools for the user

#########
# Todo #
#########
# Can be improved to 
# - install git first than , clone whole repo over http ( it being public )
# - finally run install from there that is if other files/resources are not present
# - else usual install

SETUP_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_PATH="${SETUP_ROOT}/scripts/linux"
RESOURCE_PATH="${SETUP_ROOT}/resources"
PACKAGES_FILE="${RESOURCE_PATH}/packages.txt"

source $SCRIPT_PATH/functions.sh
source $SCRIPT_PATH/tools.sh


##Ensure script is executed as root
if ! is_running_as_root
then 

    echo "You must run this script as a root or with sudo user permissions"
    exit 1
fi


#Declare and set variables
declare_variables
set_defaults 
detect_platform

#Update variables with set options
shell_options $@
if ! validator ; then clear_variables && exit 1; fi 

#Install packages
packges_list=$(read_packages_from_file ${PACKAGES_FILE})
install_packages "${packges_list[@]}"

if [[ $DETECTED_PLATFORM =~ "DOCKER" ]]
then
    #Install tzdata in docker
    sudo DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
fi 

#Create user if 
# - it is not an existing user 
if ! is_existing_user ${DESIRED_USER}
then
    echo "Creating ${DESIRED_USER} with id ${DESIRED_UID}..."
    # if uid exists exit with error
    if is_existing_uid ${DESIRED_UID}
    then
        print_error "${DESIRED_UID} is not avaialbe,please choose another uid"
        exit 128
    else
        create_user ${DESIRED_USER} ${DESIRED_UID}
    fi 
    echo "Adding ${DESIRED_USER} to sudo..."
    add_user_to_sudoers ${DESIRED_USER}
else 
    echo "${DESIRED_USER} exists...moving on"
fi 

#Update Hosts file
# - if host name is not same as current

if ! is_existing_hostname ${DESIRED_HOSTNAME}
then
    echo "Updating ${HOSTNAME} to ${DESIRED_HOSTNAME}..."
    update_hostname ${DESIRED_HOSTNAME}
fi 


DESIRED_HOME=$(sudo -E su ${DESIRED_USER} -c 'echo $HOME;exit 0')

#Install tools
echo "Installing tools.."
SUDOER_USER=${SUDO_USER:-$USER}

if [[ ${DESIRED_USER} == "root" ]] || [[ ${SUDOER_USER} == ${DESIRED_USER} ]]
then 
    sudo -E su ${DESIRED_USER} -c "source ${SETUP_ROOT}/install_tools.sh && exit 0"
else 
    COPY_PATH="/tmp/$(basename ${SETUP_ROOT})"

    cp -R ${SETUP_ROOT} ${COPY_PATH}
    chown -R ${DESIRED_USER}:${DESIRED_USER} ${COPY_PATH}
    chmod -R +x ${COPY_PATH}
    sudo -E su ${DESIRED_USER} -c "cd ${COPY_PATH} && source ${COPY_PATH}/install_tools.sh && exit 0"
    rm -rf ${COPY_PATH}

    unset COPY_PATH
fi

#Adding github to known hosts
echo "Adding github.com to known hosts"
if [ ! -d ${DESIRED_HOME}/.ssh ]
then 
    mkdir -p ${DESIRED_HOME}/.ssh
fi

ssh-keyscan -H github.com > ${DESIRED_HOME}/.ssh/known_hosts
chown ${DESIRED_USER}:${DESIRED_USER} ${DESIRED_HOME}/.ssh/known_hosts

#Install helpers for WSL
if [[ ${DETECTED_PLATFORM} =~ "WSL$" ]]
then

    echo "setup helpers for WSL"
    if ! grep -sq  ${DESIRED_HOME}/.mount_workspace ${DESIRED_HOME}/.bashrc
    then 
        echo "Installing mount workspace script"
        cp  ${RESOURCE_PATH}/mount_workspace.sh ${DESIRED_HOME}/.mount_workspace
        chmod +x ${DESIRED_HOME}/.mount_workspace
        chown ${DESIRED_USER}:${DESIRED_USER} ${DESIRED_HOME}/.mount_workspace

        echo -e "\nWORKSPACE_SRC=\"\"\nWORKSPACE=\"\"\nsource  ${DESIRED_HOME}/.mount_workspace" >> ${DESIRED_HOME}/.bashrc

    fi 

    if ! grep -sq  ${DESIRED_HOME}/.autosshadd ${DESIRED_HOME}/.bashrc
    then 
        echo "Installing autosshadd script..."
        cp  ${RESOURCE_PATH}/keychain.sh ${DESIRED_HOME}/.autosshadd
        chmod +x ${DESIRED_HOME}/.autosshadd
        chown ${DESIRED_USER}:${DESIRED_USER} ${DESIRED_HOME}/.autosshadd 

        echo -e "\nSSH_PRIVATE_KEY=\"\"\nsource  ${DESIRED_HOME}/.autosshadd" >> ${DESIRED_HOME}/.bashrc
    fi

    echo "Installing/Updating WSL Config"
    TEMPLATE_SRC="${RESOURCE_PATH}/wsl.template"
    TEMPLATE_DEST="/etc/wsl.conf"
    generate_conf_from_template $TEMPLATE_SRC $TEMPLATE_DEST
    dos2unix ${TEMPLATE_DEST}
    
    echo "Set up WORKSPACE_SRC,WORKSPACE and SSH_PRIVATE_KEY in ${DESIRED_HOME}/.bashrc if you want to bind workspace to home directory and automatically add ssh key to agent"    

fi 

#Install helpers for generic
if [[ ${DETECTED_PLATFORM} =~ "GENERIC" ]]
then
    echo "setup helpers for Generic Ubuntu"

    if ! grep -sq  ${DESIRED_HOME}/.mount_windows_share ${DESIRED_HOME}/.bashrc
    then 
        cp  ${RESOURCE_PATH}/mount_windows_share.sh ${DESIRED_HOME}/.mount_windows_share
        chmod +x ${DESIRED_HOME}/.mount_windows_share
        chown ${DESIRED_USER}:${DESIRED_USER}  ${DESIRED_HOME}/.mount_windows_share

        echo -e "\nSMB_SHARE_LOCATION=\"\"\nSMB_MOUNT_DEST_DIR=\"\"\nSMB_SHARE_USER=\"\"\nSMB_SHARE_PASSWD=\"\"\nsource  ${DESIRED_HOME}/.mount_windows_share\n" >> ${DESIRED_HOME}/.bashrc

    fi

    if ! grep -sq  ${DESIRED_HOME}/.autosshadd ${DESIRED_HOME}/.bashrc
    then  
        cp  ${RESOURCE_PATH}/keychain.sh ${DESIRED_HOME}/.autosshadd
        chmod +x ${DESIRED_HOME}/.autosshadd
        chown ${DESIRED_USER}:${DESIRED_USER} ${DESIRED_HOME}/.autosshadd 

        echo -e "\nSSH_PRIVATE_KEY=\"\"\nsource  ${DESIRED_HOME}/.autosshadd\n" >> ${DESIRED_HOME}/.bashrc

    fi
    echo "Set up nSMB_SHARE_LOCATION,SMB_MOUNT_DEST_DIR,SMB_SHARE_USER,SMB_SHARE_PASSWD and SSH_PRIVATE_KEY in ${DESIRED_HOME}/.bashrc if you want to mount windows sahre to workspace on home directory and automatically add ssh key to agent"

fi 

# Unset variables
clear_variables
unset DESIRED_HOME
unset SETUP_ROOT
unset SCRIPT_PATH
unset RESOURCE_PATH