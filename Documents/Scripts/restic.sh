#!/bin/bash

source /home/morten/.config/restic/environment.sh

notify-send "Restic backup started."

echo "Creating incremental backup ..."
### Backup new stuff
restic backup \
        --verbose \
        --files-from /home/morten/.config/restic/backup.files \
#        --exclude-file /home/morten/.config/restic/exclude.files
        
### Remove old stuff
echo "Deleting old backups ..."
restic forget \
        --keep-last 7 \
        --keep-daily 14 \
        --keep-weekly 4 \
        --keep-monthly 6

# restic -r $BACKARCH check
echo "Don't forget to run \"restic check\" from time to time"
echo "Backup finished."
        
notify-send "Restic backup finished."