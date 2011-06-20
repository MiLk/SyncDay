#!/bin/bash

#############################################################################################################
#                                                                                                           #
# Name : SyncDay                                                                                            #
# Author : Emilien Kenler <hello@emilienkenler.com>                                                         #
# Source : https://github.com/MiLk/SyncDay                                                                  #
# License : Beerware                                                                                        #
#                                                                                                           #
#############################################################################################################

#############################################################################################################
#                                                                                                           #
# Example:                                                                                                  #
#  export SYNC_DIR="$HOME/Dev/Rsync/"                                                                       #
# ./mount_sync.sh config.sh                                                                                 #
#                                                                                                           #
#############################################################################################################

. ./inc.sh
. ${1}

### INIT VARS ###
VOLUMES_PREFIX="/Volumes/"

### BEGIN DEFINE FUNCTIONS ###
mount_dir()
{
	# $1 : dossier source sur le NAS
	DIR="${VOLUMES_PREFIX}${1}"
	
	if [[ -e ${DIR} ]]
	then
		umount_dir ${1}
	fi
	mkdir ${DIR}
	mount -t afp afp://${NAS_USER}:${NAS_PASS}@${NAS_IP}/${1} ${DIR}
	echo -e "$VERT" "Volume ${1} monte" "$NORMAL"
}

umount_dir()
{
	# $1 : dossier local
	DIR="${VOLUMES_PREFIX}${1}"
	
	diskutil umount ${DIR}
	echo -e "$VERT" "Volume ${1} demonte" "$NORMAL"
}
### END DEFINE FUNCTIONS ###

if [[ -z ${NAS_IP} ]]
then
       ./synchronize.sh -s "${CONFIG_SRC}" -d "${CONFIG_DST}" -l "${CONFIG_LOG}" -b "${CONFIG_BACKUP}"
else
       mount_dir ${CONFIG_DST}
       ./synchronize.sh -s "${CONFIG_SRC}" -d "${VOLUMES_PREFIX}${CONFIG_DST}" -l "${CONFIG_LOG}" -b "${CONFIG_BACKUP}"
       umount_dir ${CONFIG_DST}
fi
exit
