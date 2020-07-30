#!/bin/bash

NOW_file=$(date +"%Y%m%d%H%M%S")
NOW_log=$(date +"%m-%d-%Y")

echo $NOW_file
echo $NOW_log


# Check ENV vars
if [ -z "$MONGO_URI" ]; then
    echo " MONGO_URI is unset or set to the empty string"
    exit 1
fi
if [ -z "$BUCKET_NAME" ]; then
    echo " BUCKET_NAME is unset or set to the empty string"
    exit 1
fi
if [ -z "$BACKUP_PATH" ]; then
    echo " BACKUP_PATH is unset or set to the empty string"
    exit 1
fi
if [ -z "$DATABASE_NAME" ]; then
    echo " DATABASE_NAME is unset or set to the empty string"
    exit 1
fi


# START
echo " Mongo backup started"


# Activate google cloud service account
echo " Activating service account"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

# Backup filename
BACKUP_FILENAME="$NOW_file-$DATABASE_NAME.tar.gz"

# Create the backup
echo " [Step 1/3] Running mongodump from $MONGO_URI to $BACKUP_PATH"
mongodump --uri $MONGO_URI -o $BACKUP_PATH --quiet

# Compress
echo " [Step 2/3] Creating tar file"
tar -czf $BACKUP_PATH$BACKUP_FILENAME $BACKUP_PATH/$DATABASE_NAME

# Copy to Google Cloud Storage
echo " [Step 3/3] Uploading archive to Google Cloud Storage"
echo "Copying $BACKUP_PATH$BACKUP_FILENAME to gs://$BUCKET_NAME/$BACKUP_FILENAME"
gsutil cp $BACKUP_PATH$BACKUP_FILENAME gs://$BUCKET_NAME/$BACKUP_FILENAME 2>&1

# Clean
echo " Removing backup data"
rm -rf $BACKUP_PATH*


# FINISH
echo " Copying finished"


