#!/bin/sh

# Define the base command
COMMAND="/app/icloudpd_ex icloudpd"

# Check environment variables and add options if they exist
[ -n "$ICLOUD_DIRECTORY" ] && COMMAND="$COMMAND --directory $ICLOUD_DIRECTORY"
[ -n "$ICLOUD_USERNAME" ] && COMMAND="$COMMAND --username $ICLOUD_USERNAME"
[ -n "$ICLOUD_PASSWORD" ] && COMMAND="$COMMAND --password $ICLOUD_PASSWORD"
[ -n "$ICLOUD_AUTH_ONLY" ] && COMMAND="$COMMAND --auth-only"
[ -n "$ICLOUD_RECENT" ] && COMMAND="$COMMAND --recent $ICLOUD_RECENT"
[ -n "$ICLOUD_ALBUM" ] && COMMAND="$COMMAND --album $ICLOUD_ALBUM"
[ -n "$ICLOUD_SKIP_VIDEOS" ] && COMMAND="$COMMAND --skip-videos"
[ -n "$ICLOUD_SKIP_LIVE_PHOTOS" ] && COMMAND="$COMMAND --skip-live-photos"
[ -n "$ICLOUD_FOLDER_STRUCTURE" ] && COMMAND="$COMMAND --folder-structure $ICLOUD_FOLDER_STRUCTURE"
[ -n "$ICLOUD_SET_EXIF_DATETIME" ] && COMMAND="$COMMAND --set-exif-datetime"
[ -n "$ICLOUD_LOG_LEVEL" ] && COMMAND="$COMMAND --log-level $ICLOUD_LOG_LEVEL"
[ -n "$ICLOUD_NO_PROGRESS_BAR" ] && COMMAND="$COMMAND --no-progress-bar"
[ -n "$ICLOUD_DELETE_AFTER_DOWNLOAD" ] && COMMAND="$COMMAND --delete-after-download"

# Execute the resulting command
eval "$COMMAND"