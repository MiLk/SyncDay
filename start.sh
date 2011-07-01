#!/bin/bash

#############################################################################################################
#                                                                                                           #
# Name : SyncDay                                                                                            #
# Author : Emilien Kenler <hello@emilienkenler.com>                                                         #
# Source : https://github.com/MiLk/SyncDay                                                                  #
# License : Beerware                                                                                        #
#                                                                                                           #
#############################################################################################################

CD=""

if [ -d "/Applications/CocoaDialog.app" ]; then
    CD="/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"
elif [ -d "$HOME/Applications/CocoaDialog.app" ]; then
    CD="$HOME/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"
else
    echo "CocoaDialog.app not found"
    exit 1
fi

SYNCDAY=""

if [ -d "${HOME}/SyncDay" ]; then
    SYNCDAY="${HOME}/SyncDay"
elif [ -d "$PWD" ]; then
    SYNCDAY="$PWD"
else
    rv=`$CD fileselect \
    --title "Localisation de SyncDay" \
    --text "Ou se trouve SyncDay ?" \
    --with-directory $HOME \
    --select-directories \
    --select‑only‑directories`
	if [ -n "$rv" ]; then
	    echo -e "$rv" | while read file; do
	        if [ -d "$file" ]; then
	            SYNCDAY="$file"
	        else
				echo "SyncDay non trouvé."
	   			exit 1
	        fi
	    done
	else
	    echo "SyncDay non trouvé."
	    exit 1
	fi
fi

CONFIG=""

rv=`$CD fileselect \
--title "SyncDay - Fichier de configuration de la synchronisation" \
--text "Choississez le fichier de configuration correspondant à la synchronisation que vous souhaitez faire." \
--with-directory ${SYNCDAY}/config \
--select‑only‑directories`
if [ -n "$rv" ]; then
	echo -e "$rv" | while read file; do
	    if [ -e "$file" ]; then
	        CONFIG="$file"
	        ${SYNCDAY}/mount_sync.sh "${CONFIG}"
	    else
            echo "Fichier de configuration non trouvé."
            exit 1
	    fi
     done
else
    echo "Fichier de configuration non trouvé."
	exit 1
fi

rv=`$CD ok-msgbox --title "SyncDay" \
--text "Synchronisation terminée" \
--float \
--icon "info" \
--no-cancel \
--informative-text "La synchronisation a été effectuée avec succès."`