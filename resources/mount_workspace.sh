#!/usr/bin/env bash 

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
