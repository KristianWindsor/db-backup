#!/bin/bash

# check parameters
source ./check_parameters.sh

# create backup
if [[ $DB_ENGINE == *"mysql"* ]]; then
    FILE_NAME="$FILE_NAME-$(date '+%Y-%m-%d').sql"
    export MYSQL_PWD="$DB_PASSWORD"
    set -x
    mysqldump -h $DB_HOST -P $DB_PORT -u $DB_USERNAME $DB_NAME > $FILE_NAME
elif [[ $DB_ENGINE == *"postgres"* ]]; then
    FILE_NAME="$FILE_NAME-$(date '+%Y-%m-%d').dump"
    export PGPASSWORD="$DB_PASSWORD"
    set -x
    pg_dump -h $DB_HOST -p $DB_PORT -Fc -o -U $DB_USERNAME $DB_NAME > $FILE_NAME
fi

# upload to s3
aws s3 cp $FILE_NAME s3://$S3_BUCKET_NAME/

# keep alive in debug mode
if [[ $DEBUG_MODE == "true" ]]; then
    while true; do sleep 10000; done
fi