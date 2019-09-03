#!/bin/bash

source /home/morten/.config/restic/environment.sh

echo "Creating incremental backup ..."
### Backup new stuff
restic backup \
        --verbose \
        --files-from /home/morten/.config/restic/backup.files \
#        --exclude-file /home/morten/.config/restic/exclude.files
        
### Remove old stuff
#echo "Deleting old backups ..."
#restic forget \
#        --keep-last 7 \
#        --keep-daily 14 \
#        --keep-weekly 4 \
#        --keep-monthly 6 \
#        --prune

no_errors=$(restic check | grep -c "no errors were found")

if [ "$no_errors" = "1" ]
then
	notify-send "Backup succesful"
else
	notify-send "Backup error"		
fi
