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
# ./synchronize.sh -s ${SYNC_DIR}/From/ -d ${SYNC_DIR}/To -b ${SYNC_DIR}/Backup/ -l ${SYNC_DIR}/rsync.log   #
#                                                                                                           #
#############################################################################################################

. ./inc.sh

### INIT VARS ###
BACKUP=
DESTINATION=
SOURCE=
LOG=
PROGRESS=
RSYNC_OPTS="--verbose --update --recursive --xattrs --compress --times --stats --size-only --exclude ".DS_Store" --delete"

### BEGIN DEFINE FUNCTIONS ###
usage()
{
	echo "Usage: $0 -s source_directory -d destination_directory [-b backup_directory]"
	exit
}

do_rsync()
{
	rsync ${RSYNC_OPTS} ${PROGRESS} ${LOG_OPTS} ${BACKUP_OPTS} ${SOURCE} ${DESTINATION}
}
### END DEFINE FUNCTIONS ###

### BEGIN PARAMETERS LOADING ###
echo ""

while getopts s:d:b:l:p option
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
  p)
   PROGRESS=" --progress"
   ;;
  *) usage
   ;; 
  esac
done
### END PARAMETERS LOADING ###

### BEGIN PARAMETERS VALIDATORS ###
if [[ -z $SOURCE ]]
then
	echo -e "$ROUGE" "Erreur: Veuillez saisir un dossier source." "$NORMAL"
	usage
fi

if [[ -z $DESTINATION ]]
then
	echo -e "$ROUGE" "Erreur: Veuillez saisir un dossier destination." "$NORMAL"
	usage
fi

if [[ ! -e $SOURCE ]]
then
	echo -e "$JAUNE" "Avertissement: Dossier source introuvable." "$NORMAL"
	usage
fi

# Création automatique si vide - contrôle inutile
#if [[ ! -e $DESTINATION ]]
#then
#	echo -e "$ROUGE" "Erreur: Dossier destination introuvable." "$NORMAL"
#	usage
#fi

if [[ $SOURCE = $DESTINATION ]]
then
	echo -e "$ROUGE" "Erreur: Dossier source et destination identique." "$NORMAL"
	usage
fi

if [[ -n $BACKUP ]]
then
	if [[ ! -d $BACKUP ]]
	then
		mkdir -p $BACKUP
		echo -e "$JAUNE" "Avertissement: Le dossier " "$BACKUP" "a été créé." "$NORMAL"
    fi
    DATE="`date +%Y-%m-%d`"
    mkdir -p ${BACKUP}${DATE}
    BACKUP_OPTS=" --backup --backup-dir=${BACKUP}${DATE}"
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
