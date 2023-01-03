#!/usr/bin/env bash 
#######
# Please add following lines at the end of .bashrc before using this script and, if anything is missing it will fail silently
# $WORKSPACE="$HOME/workspace"
# WORKSPACE_SRC="/mount/path/to/source/directory"
#
# source /location/of/mount_workspace.sh

is_mounted() {
    mount | awk -v DIR="$1" '{if ($3 == DIR) { exit 0}} ENDFILE{exit -1}'
}

if [[ ! -z $WORKSPACE ]] && [[ ! -z $WORKSPACE_SRC ]]
then 
    if [ ! -d "$WORKSPACE" ]
    then
        mkdir -p "$WORKSPACE"
    fi
    
    if ! is_mounted $WORKSPACE
    then
        sudo mount -o bind $WORKSPACE_SRC $WORKSPACE
    fi
fi