#!/bin/sh
# written 2010 by Patrick Heck (heckp@uni-trier.de)
# this performs a remote backup with hard links to older versions
# (Apple Time Machine Style)

echo "Starting database backup"
DATE=`date "+%Y-%m-%dT%H-%M-%S"`

MAX_BACKUP_DAYS=45
# This is the day who's backups will expire today
EXPIRING_DATE=`date "+%Y-%m-%d" -d "${MAX_BACKUP_DAYS} days ago"` 

# always exit if a command fails 
set -o errexit

echo "Backing up MySQL Databases" 
for DATABASE in piwik cag cag_demo dwb_website_c5 dwv_website_c5 egoPersonenDB egoTerminDB exilnetz33 gwb_website_c5 koze_website_c5 mwv_website_c5 schlegel_website_c5 transcribo
do
	DBBACKUP_DIR="/home/heckp/backup/db/${DATABASE}"
	mkdir -p "$DBBACKUP_DIR"
	NEW="${DBBACKUP_DIR}/${DATABASE}_dump_${DATE}.sql.bz"
	CURRENT="${DBBACKUP_DIR}/${DATABASE}_dump_current"
	echo "Backing up $DATABASE to ${DBBACKUP_DIR}"
	echo "File: $NEW"
	/usr/bin/mysqldump --skip-comments --quick -u root --password=hFv37jKs3 $DATABASE | bzip2 > "$NEW"
	# if the files are the same make new file hardlink to old one
	if diff "$NEW" "$CURRENT"
	then
		echo "Files are the same. Creating link to last version"
		ln -fv `readlink "$CURRENT"` "$NEW"
	else
		echo "Files differ."
	fi
	rm -rf "$CURRENT"
	ln -s "$NEW" "$CURRENT"
        echo "Deleting old Database Backup Files"
        find "${DBBACKUP_DIR}" -name '*bz' -mtime +$MAX_BACKUP_DAYS -exec rm -fv {} \;

done
echo "done"
