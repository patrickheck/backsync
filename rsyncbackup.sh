#!/bin/sh
# written 2013 by Patrick Heck (heckp@uni-trier.de)
# this performs a remote backup with hard links to older versions
# (Apple Time Machine Style)

BASEDIR=`dirname "$(readlink -f "$0")"`

echo "Starting incremental rsync backup"
DATE=`date "+%Y-%m-%dT%H-%M-%S"`

CONFIG_FILE="${BASEDIR}/config/backup.conf"

echo "loading configuration from ${CONFIG_FILE}"

# Source configuration file
if [ -f $CONFIG_FILE ]
then
    . $CONFIG_FILE
else
    echo "Error: ${CONFIG_FILE} does not exists. Please create one. You can start by running:"
    echo "cp config/backup.conf.sample config/backup.conf"
    exit 1
fi

# read the dirs to be backed up from here
RSYNCDIRS="${BASEDIR}/config/rsyncdirs.conf"

# files and directories to be excluded
RSYNCRULES="${BASEDIR}/config/rsyncrules.conf"

# This is the day which's backups will expire today
EXPIRING_DATE=`date "+%Y-%m-%d" -d "${MAX_BACKUP_DAYS} days ago"` 

# always exit if a command fails 
set -o errexit


echo "Backing up Files"
echo "Target is \"${BACKUP_SERVER}:${BACKUP_DIR}/Backup-${DATE}\""

rsync -aPrv --delete --delete-excluded \
	  --exclude-from="${RSYNCRULES}" \
	  --files-from="${RSYNCDIRS}" \
	  --copy-links \
	  --link-dest="../current" \
	  / \
	  "${BACKUP_SERVER}:${BACKUP_DIR}/Backup-${DATE}.inprogress"
ssh ${BACKUP_SERVER} \
"mv \"${BACKUP_DIR}/Backup-${DATE}.inprogress\" \"${BACKUP_DIR}/Backup-${DATE}\" \
&& rm -rf \"${BACKUP_DIR}/current\" \
&& ln -s \"${BACKUP_DIR}/Backup-${DATE}\" \"${BACKUP_DIR}/current\" "
echo "Copying of data complete"

echo "Deleting data older than $MAX_BACKUP_DAYS days"
echo "Expiring Backup is ${BACKUP_DIR}/Backup-${EXPIRING_DATE}*"
ssh ${BACKUP_SERVER} \
"find \"${BACKUP_DIR}\" -maxdepth 1 -type d -mtime +$MAX_BACKUP_DAYS -exec rm -rf  {} \\; \
; find \"${BACKUP_DIR}\" -maxdepth 1 -type d -name '*.inprogress' -exec rm -rf  {} \\; "
# ssh ${BACKUP_SERVER} \
# "rm -rf \"${BACKUP_DIR}/Backup-${EXPIRING_DATE}\"* \
# ; rm -rf \"${BACKUP_DIR}\"/*.inprogress "
echo "Backup Complete"

