#######
# Please add following lines at the end of .bashrc before using this script and, if anything is missing it will fail silently
# SMB_SHARE_LOCATION="//<ip>/<share>"
# SMB_MOUNT_DEST_DIR="/<this>/<directory>"
# SMB_SHARE_USER="share_user"
# SMB_SHARE_PASSWD="share_password" 
#
# source /location/of/mount_windows_share.sh

#Check if variables are set?
if [[ ! -z ${SMB_SHARE_LOCATION} || ! -z ${SMB_MOUNT_DEST_DIR} || ! -z ${SMB_SHARE_USER} || ! -z ${SMB_SHARE_PASSWD} ]] 
then 

	#Create $SMB_MOUNT_DEST_DIR if it does not exist
	if [ ! -d ${SMB_MOUNT_DEST_DIR} ]
	then
		mkdir -p ${SMB_MOUNT_DEST_DIR}
	fi

	#Mount if directory is not mounted
	smb_mount_count=`mount | grep -c ${SMB_MOUNT_DEST_DIR}`
	if [ 1 -ne ${smb_mount_count} ]
	then
		echo "Mounting windows Share ${SMB_SHARE_LOCATION} to ${SMB_MOUNT_DEST_DIR}"
		sudo mount.cifs ${SMB_SHARE_LOCATION} ${SMB_MOUNT_DEST_DIR} -o user=${SMB_SHARE_USER},password=${SMB_SHARE_PASSWD},uid=${UID},gid=${UID}
	fi
fi
