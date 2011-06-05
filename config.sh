#!/bin/bash

#############################################################################################################
#                                                                                                           #
# Name : SyncDay                                                                                            #
# Author : Emilien Kenler <hello@emilienkenler.com>                                                         #
# Source : https://github.com/MiLk/SyncDay                                                                  #
# License : Beerware                                                                                        #
#                                                                                                           #
#############################################################################################################

NAS_IP="192.168.0.11"
NAS_USER="admin"
NAS_PASS="admin"

CONFIG_SRC="${HOME}/Dev/Rsync/From"
CONFIG_DST="Test"
CONFIG_LOG="${HOME}/Dev/Rsync/rsync.log"
CONFIG_BACKUP="${HOME}/Dev/Rsync/Backup"