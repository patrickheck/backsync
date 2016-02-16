#!/bin/sh
# written 2014 by Patrick Heck (heckp@uni-trier.de)
# this performs a MYSQL backup

echo "Starting database backup"
DATE=`date "+%Y-%m-%dT%H-%M-%S"`

# always exit if a command fails 
set -o errexit

BASEDIR=`dirname "$(readlink -f "$0")"`

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

# This is the day who's backups will expire today
EXPIRING_DATE=`date "+%Y-%m-%d" -d "${MAX_BACKUP_DAYS} days ago"` 

echo "Backing up MySQL Databases" 
for DATABASE in $MYSQL_DATABASES
do
	DBBACKUP_DIR="${MYSQL_BACKUP_DIR}/${DATABASE}"
	mkdir -p "$DBBACKUP_DIR"
	NEW="${DBBACKUP_DIR}/${DATABASE}_dump_${DATE}.sql.bz"
	CURRENT="${DBBACKUP_DIR}/${DATABASE}_dump_current"
	echo "Backing up $DATABASE to ${DBBACKUP_DIR}"
	echo "File: $NEW"
	/usr/bin/mysqldump --skip-comments --quick -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD $DATABASE | bzip2 > "$NEW"
	# if the files are the same make new file hardlink to old one
	if diff "$NEW" "$CURRENT"
	then
		echo "Files are the same. Creating link to last version"
		ln -fv `readlink "$CURRENT"` "$NEW"
		touch "$NEW"
	else
		echo "Files differ."
	fi
	rm -rf "$CURRENT"
	ln -s "$NEW" "$CURRENT"
        echo "Deleting old Database Backup Files"
        find "${DBBACKUP_DIR}" -name '*bz' -mtime +$MAX_BACKUP_DAYS -exec rm -fv {} \;

done
echo "done"
