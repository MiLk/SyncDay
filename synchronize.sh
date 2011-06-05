#!/bin/bash

#############################################################################################################
#                                                                                                           #
# Name : SyncDay                                                                                                          #
# Author : Emilien Kenler <hello@emilienkenler.com>                                                         #
# Source : https://github.com/MiLk/SyncDay                                                                  #
# License : Beerware                                                                                        #
#                                                                                                           #
#############################################################################################################

#############################################################################################################
#                                                                                                           #
# Example:                                                                                                  #
#  export SYNC_DIR="$HOME/Dev/Rsync/"                                                                       #
# ./synchronize.sh -s ${SYNC_DIR}/From/ -d ${SYNC_DIR}/To -b ${SYNC_DIR}/Backup/ -l ${SYNC_DIR}/rsync.log   #
#                                                                                                           #
#############################################################################################################

### BEGIN DEFINE COLORS ###
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"
### END DEFINE COLORS ###

### INIT VARS ###
BACKUP=
DESTINATION=
SOURCE=
LOG=
RSYNC_OPTS="--verbose --update --recursive --xattrs --compress --times --stats --size-only --exclude ".DS_Store" --delete"

### BEGIN DEFINE FUNCTIONS ###
usage()
{
	echo "Usage: $0 -s source_directory -d destination_directory [-b backup_directory]"
	exit
}

do_rsync()
{
	rsync ${RSYNC_OPTS} ${LOG_OPTS} ${BACKUP_OPTS} ${SOURCE} ${DESTINATION}
}
### END DEFINE FUNCTIONS ###

### BEGIN PARAMETERS LOADING ###
echo ""

while getopts s:d:b:l: option
do
 case $option in
  s)
   echo -e "$BLEU" "Dossier source : " "$JAUNE" "$OPTARG" "$NORMAL"
   SOURCE=$OPTARG 
   ;;
  d)
   echo -e "$BLEU" "Dossier destination : " "$JAUNE" "$OPTARG" "$NORMAL"
   DESTINATION=$OPTARG
   ;;
  b)
   echo -e "$BLEU" "Dossier backup : " "$JAUNE" "$OPTARG" "$NORMAL"
   BACKUP=$OPTARG
   ;;
  l)
   echo -e "$BLEU" "Fichier log : " "$JAUNE" "$OPTARG" "$NORMAL"
   LOG=$OPTARG
   ;;
  *) usage
   ;; 
  esac
done
### END PARAMETERS LOADING ###

### BEGIN PARAMETERS VALIDATORS ###
if [[ -z $SOURCE ]]
then
	echo -e "$ROUGE" "Veuillez saisir un dossier source" "$NORMAL"
	usage
fi

if [[ -z $DESTINATION ]]
then
	echo -e "$ROUGE" "Veuillez saisir un dossier destination" "$NORMAL"
	usage
fi

if [[ ! -d $SOURCE ]]
then
	echo -e "$ROUGE" "Dossier source introuvable" "$NORMAL"
	usage
fi

if [[ ! -d $DESTINATION ]]
then
	echo -e "$ROUGE" "Dossier destination introuvable" "$NORMAL"
	usage
fi

if [[ $SOURCE = $DESTINATION ]]
then
	echo -e "$ROUGE" "Dossier source et destination identique" "$NORMAL"
	usage
fi

if [[ -n $BACKUP ]]
then
	if [[ ! -d $BACKUP ]]
	then
		echo -e "$ROUGE" "Dossier backup introuvable" "$NORMAL"
		usage
    else
        BACKUP_OPTS=" --backup --backup-dir=${BACKUP}"
	fi
fi

if [[ -n $LOG ]]
then
	LOG_OPTS=" --log-file=${LOG}"
fi
### END PARAMETERS VALIDATORS ###

echo ""
echo -e "$VERT" "Synchronisation Start" "$NORMAL"
echo ""
do_rsync
echo ""
echo -e "$VERT" "Synchronisation End" "$NORMAL"
echo ""
